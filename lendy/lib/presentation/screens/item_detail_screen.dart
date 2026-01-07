import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/items_provider.dart';
import '../../data/repositories/item_repository_providers.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/item_status.dart';
import '../../services/auth_providers.dart';
import '../../services/local_notification_service.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final String itemId;

  const ItemDetailScreen({
    super.key,
    required this.itemId,
  });

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not authenticated')),
      );
    }

    final itemFuture = ref.watch(itemDetailProvider(widget.itemId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: itemFuture.when(
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Item not found'));
          }
          return _buildItemDetails(item);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(itemDetailProvider(widget.itemId));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemDetails(Item item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Title
          Text(
            item.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Status Badge
          Chip(
            label: Text(
              item.status.value.toUpperCase(),
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: item.status == ItemStatus.lent 
                ? Colors.orange.shade100 
                : Colors.green.shade100,
          ),
          const SizedBox(height: 24),
          
          // Borrower Information
          _buildInfoRow('Borrower', item.borrowerName),
          if (item.borrowerContact != null)
            _buildInfoRow('Contact', item.borrowerContact!),
          
          const Divider(height: 32),
          
          // Dates
          _buildInfoRow(
            'Date Lent',
            DateFormat('MMM d, y').format(item.lentAt),
          ),
          if (item.dueAt != null)
            _buildInfoRow(
              'Due Date',
              DateFormat('MMM d, y').format(item.dueAt!),
              valueColor: _isOverdue(item.dueAt!) ? Colors.red : null,
            ),
          // Reminder section (editable)
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reminder',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.reminderAt != null
                        ? DateFormat('MMM d, y h:mm a').format(item.reminderAt!)
                        : 'Not set',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              Row(
                children: [
                  if (item.reminderAt != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _handleRemoveReminder(item.id),
                      tooltip: 'Remove reminder',
                    ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _handleSetReminder(item.id, item.reminderAt, item.title),
                    tooltip: 'Set reminder',
                  ),
                ],
              ),
            ],
          ),
          if (item.returnedAt != null) ...[
            const Divider(height: 32),
            _buildInfoRow(
              'Returned On',
              DateFormat('MMM d, y').format(item.returnedAt!),
            ),
          ],
          
          // Description
          if (item.description != null) ...[
            const Divider(height: 32),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(item.description!),
          ],
          
          // Photos section
          if (item.photoUrls != null && item.photoUrls!.isNotEmpty) ...[
            const Divider(height: 32),
            Text(
              'Photos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: item.photoUrls!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        // Show full screen image
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => _FullScreenImage(
                              imageUrl: item.photoUrls![index],
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.photoUrls![index],
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 200,
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          
          const SizedBox(height: 32),
          
          // Action Buttons
          if (item.status == ItemStatus.lent) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _handleMarkAsReturned(item.id),
                icon: const Icon(Icons.check_circle),
                label: const Text('Mark as Returned'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _handleDelete(item.id),
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: valueColor != null ? FontWeight.w500 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now());
  }

  Future<void> _handleMarkAsReturned(String itemId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Returned'),
        content: const Text('Are you sure this item has been returned?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final authState = ref.read(authStateProvider);
      final user = authState.value;
      
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final repository = ref.read(itemRepositoryProvider);
      await repository.markAsReturned(
        userId: user.id,
        itemId: itemId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item marked as returned!')),
        );
        // Refresh the item detail and lists
        ref.invalidate(itemDetailProvider(itemId));
        ref.invalidate(lentItemsProvider);
        ref.invalidate(returnedItemsProvider);
        // Navigate back
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDelete(String itemId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final authState = ref.read(authStateProvider);
      final user = authState.value;
      
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final repository = ref.read(itemRepositoryProvider);
      await repository.deleteItem(
        userId: user.id,
        itemId: itemId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item deleted')),
        );
        // Refresh lists
        ref.invalidate(lentItemsProvider);
        ref.invalidate(returnedItemsProvider);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleSetReminder(String itemId, DateTime? currentReminder, String itemTitle) async {
    // Pick date
    final date = await showDatePicker(
      context: context,
      initialDate: currentReminder ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date == null || !mounted) return;
    
    // Pick time
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentReminder ?? DateTime.now()),
    );
    
    if (time == null || !mounted) return;
    
    final reminderAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    try {
      final authState = ref.read(authStateProvider);
      final user = authState.value;
      
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final repository = ref.read(itemRepositoryProvider);
      await repository.updateItem(
        userId: user.id,
        itemId: itemId,
        updates: {
          'reminder_at': reminderAt.toIso8601String(),
        },
      );

      // Schedule local notification
      final notificationService = LocalNotificationService();
      await notificationService.scheduleReminder(
        id: itemId.hashCode,
        title: 'Item Reminder',
        body: 'Don\'t forget: $itemTitle',
        scheduledDate: reminderAt,
        payload: itemId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder set!')),
        );
        ref.invalidate(itemDetailProvider(itemId));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleRemoveReminder(String itemId) async {
    try {
      final authState = ref.read(authStateProvider);
      final user = authState.value;
      
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final repository = ref.read(itemRepositoryProvider);
      await repository.updateItem(
        userId: user.id,
        itemId: itemId,
        updates: {
          'reminder_at': null,
        },
      );

      // Cancel local notification
      final notificationService = LocalNotificationService();
      await notificationService.cancelReminder(itemId.hashCode);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder removed')),
        );
        ref.invalidate(itemDetailProvider(itemId));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}

