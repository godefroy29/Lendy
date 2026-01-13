import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/item_repository_providers.dart';
import '../../data/repositories/storage_repository.dart';
import '../../domain/entities/item.dart';
import '../../services/auth_providers.dart';
import '../../services/local_notification_service.dart';
import '../widgets/success_animation.dart';
import '../widgets/retryable_image.dart';
import '../../utils/error_handler.dart';

class EditItemScreen extends ConsumerStatefulWidget {
  final Item item;
  
  const EditItemScreen({
    super.key,
    required this.item,
  });

  @override
  ConsumerState<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends ConsumerState<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _borrowerNameController = TextEditingController();
  final _borrowerContactController = TextEditingController();
  
  DateTime _lentAt = DateTime.now();
  DateTime? _dueAt;
  DateTime? _reminderAt;
  DateTime? _originalReminderAt;
  String? _category;
  
  final List<File> _newImages = [];
  final List<String> _existingPhotoUrls = [];
  final List<String> _removedPhotoUrls = [];
  bool _isLoading = false;
  
  // Predefined categories (same as CreateItemScreen)
  static const List<String> _predefinedCategories = [
    'Books',
    'Tools',
    'Electronics',
    'Clothing',
    'Games',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill form with existing item data
    _titleController.text = widget.item.title;
    _descriptionController.text = widget.item.description ?? '';
    _borrowerNameController.text = widget.item.borrowerName;
    _borrowerContactController.text = widget.item.borrowerContact ?? '';
    _lentAt = widget.item.lentAt;
    _dueAt = widget.item.dueAt;
    _reminderAt = widget.item.reminderAt;
    _originalReminderAt = widget.item.reminderAt;
    _category = widget.item.category;
    _existingPhotoUrls.addAll(widget.item.photoUrls ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _borrowerNameController.dispose();
    _borrowerContactController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      ImageSource? source;
      
      if (kIsWeb) {
        source = ImageSource.gallery;
      } else {
        source = await showDialog<ImageSource>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      }

      if (source == null) return;

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );

      if (image != null) {
        setState(() {
          _newImages.add(File(image.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserFriendlyMessage(e)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeExistingPhoto(String photoUrl) {
    setState(() {
      _existingPhotoUrls.remove(photoUrl);
      _removedPhotoUrls.add(photoUrl);
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() {
      _isLoading = true;
    });

    try {
      final authState = ref.read(authStateProvider);
      final user = authState.value;
      
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final repository = ref.read(itemRepositoryProvider);
      final storageRepo = ref.read(storageRepositoryProvider);
      final notificationService = LocalNotificationService();
      
      // Prepare updates
      final updates = <String, dynamic>{
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        'borrower_name': _borrowerNameController.text.trim(),
        'borrower_contact': _borrowerContactController.text.trim().isEmpty 
            ? null 
            : _borrowerContactController.text.trim(),
        'lent_at': _lentAt.toIso8601String(),
        'due_at': _dueAt?.toIso8601String(),
        'reminder_at': _reminderAt?.toIso8601String(),
        'category': _category,
      };

      // Handle photo updates
      List<String> finalPhotoUrls = List.from(_existingPhotoUrls);
      
      // Upload new photos
      if (_newImages.isNotEmpty) {
        final PhotoUploadResult uploadResult = await storageRepo.uploadPhotos(
          userId: user.id,
          itemId: widget.item.id,
          imageFiles: _newImages,
        );
        
        if (uploadResult.successfulUrls.isNotEmpty) {
          finalPhotoUrls.addAll(uploadResult.successfulUrls);
        }
        
        if (uploadResult.hasErrors && mounted) {
          final errorMessages = uploadResult.errors
              .map((e) => '${e.fileName}: ${e.error}')
              .join('\n');
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Some photos failed to upload:\n$errorMessages'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
      
      // Delete removed photos from storage
      if (_removedPhotoUrls.isNotEmpty) {
        for (final url in _removedPhotoUrls) {
          try {
            await storageRepo.deletePhoto(url);
          } catch (e) {
            // Log but don't fail the update
            debugPrint('Failed to delete photo: $e');
          }
        }
      }
      
      updates['photo_urls'] = finalPhotoUrls.isEmpty ? null : finalPhotoUrls;

      // Update item
      await repository.updateItem(
        userId: user.id,
        itemId: widget.item.id,
        updates: updates,
      );

      // Handle notification updates
      if (_reminderAt != _originalReminderAt) {
        // Cancel old notification if it existed
        if (_originalReminderAt != null) {
          await notificationService.cancelReminder(widget.item.id.hashCode);
        }
        
        // Schedule new notification if reminder is set
        if (_reminderAt != null) {
          await notificationService.scheduleReminder(
            id: widget.item.id.hashCode,
            title: 'Item Reminder',
            body: 'Don\'t forget: ${_titleController.text.trim()}',
            scheduledDate: _reminderAt!,
            payload: widget.item.id,
          );
        }
      }

      if (mounted) {
        HapticFeedback.mediumImpact();
        SuccessAnimation.show(
          context,
          'Item updated successfully!',
          onComplete: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getUserFriendlyMessage(e)),
            backgroundColor: Colors.red,
            action: ErrorHandler.isRecoverable(e)
                ? SnackBarAction(
                    label: 'Retry',
                    textColor: Colors.white,
                    onPressed: _handleSave,
                  )
                : null,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Item Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory_2),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _borrowerNameController,
                decoration: const InputDecoration(
                  labelText: 'Borrower Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter borrower name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _borrowerContactController,
                decoration: const InputDecoration(
                  labelText: 'Borrower Contact (optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Category selector
              _buildCategorySelector(context),
              const SizedBox(height: 20),
              _buildDatePickerTile(
                context,
                title: 'Date Lent',
                value: DateFormat('MMM d, y').format(_lentAt),
                icon: Icons.calendar_today,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _lentAt,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _lentAt = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildDatePickerTile(
                context,
                title: 'Due Date (optional)',
                value: _dueAt != null 
                    ? DateFormat('MMM d, y').format(_dueAt!) 
                    : 'Not set',
                icon: Icons.event,
                hasClear: _dueAt != null,
                onClear: () {
                  setState(() {
                    _dueAt = null;
                  });
                },
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dueAt ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _dueAt = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildDatePickerTile(
                context,
                title: 'Reminder (optional)',
                value: _reminderAt != null 
                    ? DateFormat('MMM d, y h:mm a').format(_reminderAt!) 
                    : 'Not set',
                icon: Icons.notifications,
                hasClear: _reminderAt != null,
                onClear: () {
                  setState(() {
                    _reminderAt = null;
                  });
                },
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _reminderAt ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  
                  if (date == null || !mounted) return;
                  
                  final navigatorContext = context;
                  final time = await showTimePicker(
                    context: navigatorContext,
                    initialTime: TimeOfDay.fromDateTime(_reminderAt ?? DateTime.now()),
                  );
                  
                  if (time == null || !mounted) return;
                  
                  final reminderAt = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                  
                  if (reminderAt.isBefore(DateTime.now())) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(navigatorContext).showSnackBar(
                      const SnackBar(
                        content: Text('Reminder date must be in the future'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  
                  setState(() {
                    _reminderAt = reminderAt;
                  });
                },
              ),
              const SizedBox(height: 8),
              Divider(
                height: 40,
                thickness: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha:0.2),
              ),
              Text(
                'Photos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Display existing photos
              if (_existingPhotoUrls.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _existingPhotoUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Stack(
                          children: [
                            RetryableImage(
                              imageUrl: _existingPhotoUrls[index],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.error,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 18, color: Colors.white),
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    _removeExistingPhoto(_existingPhotoUrls[index]);
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 44,
                                    minHeight: 44,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              
              // Display new images
              if (_newImages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _newImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _newImages[index],
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.close, size: 18, color: Colors.white),
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      setState(() {
                                        _newImages.removeAt(index);
                                      });
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 44,
                                      minHeight: 44,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              
              const SizedBox(height: 12),
              
              // Add photo button
              OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _pickImages();
                },
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Add Photos'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(0, 44), // Minimum touch target
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(0, 44), // Minimum touch target
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(0, 44), // Minimum touch target
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerTile(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    bool hasClear = false,
    VoidCallback? onClear,
  }) {
    final isNotSet = value == 'Not set';
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
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
                color: Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
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
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isNotSet 
                          ? Theme.of(context).colorScheme.onSurface.withValues(alpha:0.5)
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isNotSet ? FontWeight.normal : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (hasClear && onClear != null)
              IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onClear();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha:0.2),
        ),
      ),
      child: InkWell(
        onTap: () => _showCategoryPicker(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.category,
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
                      'Category (optional)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _category ?? 'Not set',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _category == null
                            ? Theme.of(context).colorScheme.onSurface.withValues(alpha:0.5)
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: _category == null ? FontWeight.normal : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (_category != null)
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _category = null;
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCategoryPicker(BuildContext context) async {
    HapticFeedback.lightImpact();
    final TextEditingController customCategoryController = TextEditingController();
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Predefined categories
              ..._predefinedCategories.map((category) => ListTile(
                title: Text(category),
                selected: _category == category,
                selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context, category);
                },
                trailing: _category == category
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
              )),
              const Divider(),
              // Custom category option
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add Custom Category'),
                onTap: () async {
                  Navigator.pop(context);
                  // Show dialog for custom category
                  await Future.delayed(const Duration(milliseconds: 200));
                  final customCategory = await showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Custom Category'),
                      content: TextField(
                        controller: customCategoryController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Category Name',
                          hintText: 'Enter category name',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            minimumSize: const Size(88, 44),
                          ),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final category = customCategoryController.text.trim();
                            if (category.isNotEmpty) {
                              HapticFeedback.mediumImpact();
                              Navigator.pop(context, category);
                            } else {
                              HapticFeedback.lightImpact();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(88, 44),
                          ),
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  );
                  if (customCategory != null && mounted) {
                    setState(() {
                      _category = customCategory;
                    });
                  }
                },
              ),
              // Clear category option
              if (_category != null)
                ListTile(
                  leading: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'Clear Category',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context, '');
                  },
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(88, 44),
            ),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _category = result.isEmpty ? null : result;
      });
    }
  }
}
