import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/items_provider.dart';
import '../../data/repositories/item_repository_providers.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/item_status.dart';
import '../../services/auth_providers.dart';
import '../../services/local_notification_service.dart';
import '../../config/app_theme.dart';

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
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading item details...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                ),
              ),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer.withValues(alpha:0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Failed to load item',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(itemDetailProvider(widget.itemId));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemDetails(Item item) {
    final isOverdue = item.dueAt != null && _isOverdue(item.dueAt!);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Title
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => _handleEditTitle(item),
                tooltip: 'Edit title',
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Status Badge - Use semantic colors
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: item.status == ItemStatus.lent 
                  ? Theme.of(context).colorScheme.warningContainer
                  : Theme.of(context).colorScheme.successContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.status.value.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: item.status == ItemStatus.lent 
                    ? Theme.of(context).colorScheme.warning
                    : Theme.of(context).colorScheme.success,
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // Borrower Information Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Borrower Information'),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => _handleEditBorrower(item),
                tooltip: 'Edit borrower',
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // Navigate back to list with borrower search
              Navigator.pop(context, item.borrowerName);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha:0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Borrower',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.borrowerName,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (item.borrowerContact != null) ...[
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              icon: Icons.contact_mail,
              label: 'Contact',
              value: item.borrowerContact!,
            ),
          ],
          if (item.borrowerContact == null) ...[
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              icon: Icons.contact_mail,
              label: 'Contact',
              value: 'Not set',
            ),
          ],
          const SizedBox(height: 24),
          
          // Dates Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Dates'),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => _handleEditDateLent(item),
                tooltip: 'Edit date lent',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            context,
            icon: Icons.calendar_today,
            label: 'Date Lent',
            value: DateFormat('MMM d, y').format(item.lentAt),
          ),
          if (item.dueAt != null) ...[
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              icon: Icons.event,
              label: 'Due Date',
              value: DateFormat('MMM d, y').format(item.dueAt!),
              isError: isOverdue,
              isWarning: !isOverdue && item.dueAt!.difference(DateTime.now()).inDays <= 3,
            ),
          ],
          // Reminder section (editable)
          const SizedBox(height: 24),
          _buildSectionHeader('Reminder'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha:0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.notifications,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reminder',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.reminderAt != null
                            ? DateFormat('MMM d, y h:mm a').format(item.reminderAt!)
                            : 'Not set',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: item.reminderAt != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha:0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.reminderAt != null)
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                    ),
                    onPressed: () => _handleRemoveReminder(item.id),
                    tooltip: 'Remove reminder',
                  ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => _handleSetReminder(item.id, item.reminderAt, item.title),
                  tooltip: 'Set reminder',
                ),
              ],
            ),
          ),
          if (item.returnedAt != null) ...[
            const SizedBox(height: 24),
            _buildInfoCard(
              context,
              icon: Icons.check_circle,
              label: 'Returned On',
              value: DateFormat('MMM d, y').format(item.returnedAt!),
            ),
          ],
          
          // Description
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Description'),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => _handleEditDescription(item),
                tooltip: 'Edit description',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item.description ?? 'No description',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: item.description != null
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          
          // Photos section
          if (item.photoUrls != null && item.photoUrls!.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('Photos'),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: item.photoUrls!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
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
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.photoUrls![index],
                          width: 220,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.broken_image,
                                size: 48,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.4),
                              ),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isError = false,
    bool isWarning = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    Color? valueColor;
    Color? iconColor;
    
    if (isError) {
      // Error: Coral Red for overdue items
      valueColor = colorScheme.error;
      iconColor = colorScheme.error;
    } else if (isWarning) {
      // Warning: Amber for items due within 3 days
      valueColor = colorScheme.warning;
      iconColor = colorScheme.warning;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha:0.2),
        ),
      ),
      child: Row(
        children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (iconColor ?? colorScheme.primary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor ?? colorScheme.primary,
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: valueColor ?? Theme.of(context).colorScheme.onSurface,
                    fontWeight: (isError || isWarning) ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
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

  Future<void> _handleEditTitle(Item item) async {
    final titleController = TextEditingController(text: item.title);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Title'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = titleController.text.trim();
              if (newTitle.isNotEmpty) {
                Navigator.pop(context, newTitle);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result != item.title) {
      await _updateItemField(item.id, {'title': result});
    }
  }

  Future<void> _handleEditBorrower(Item item) async {
    final borrowerNameController = TextEditingController(text: item.borrowerName);
    final borrowerContactController = TextEditingController(text: item.borrowerContact ?? '');
    
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Borrower Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: borrowerNameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Borrower Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: borrowerContactController,
                decoration: const InputDecoration(
                  labelText: 'Contact (optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.contact_mail),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = borrowerNameController.text.trim();
              if (newName.isNotEmpty) {
                Navigator.pop(context, {
                  'borrower_name': newName,
                  'borrower_contact': borrowerContactController.text.trim().isEmpty
                      ? null
                      : borrowerContactController.text.trim(),
                });
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      final updates = <String, dynamic>{};
      if (result['borrower_name'] != item.borrowerName) {
        updates['borrower_name'] = result['borrower_name'];
      }
      if (result['borrower_contact'] != item.borrowerContact) {
        updates['borrower_contact'] = result['borrower_contact'];
      }
      if (updates.isNotEmpty) {
        await _updateItemField(item.id, updates);
      }
    }
  }

  Future<void> _handleEditDateLent(Item item) async {
    final date = await showDatePicker(
      context: context,
      initialDate: item.lentAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date != null && date != item.lentAt) {
      await _updateItemField(item.id, {
        'lent_at': date.toIso8601String(),
      });
    }
  }

  Future<void> _handleEditDescription(Item item) async {
    final descriptionController = TextEditingController(text: item.description ?? '');
    
    final result = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Description'),
        content: TextField(
          controller: descriptionController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
            hintText: 'Enter description (optional)',
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newDescription = descriptionController.text.trim();
              Navigator.pop(context, newDescription.isEmpty ? null : newDescription);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result != item.description) {
      await _updateItemField(item.id, {'description': result});
    }
  }

  Future<void> _updateItemField(String itemId, Map<String, dynamic> updates) async {
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
        updates: updates,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item updated successfully!')),
        );
        // Refresh the item detail and lists
        ref.invalidate(itemDetailProvider(itemId));
        ref.invalidate(lentItemsProvider);
        ref.invalidate(returnedItemsProvider);
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

