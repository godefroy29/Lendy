import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/item_status.dart';
import '../../config/app_theme.dart';
import 'retryable_image.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;
  final Function(String borrowerName)? onBorrowerTap;

  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onBorrowerTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = item.dueAt != null && _isOverdue(item.dueAt!);
    final daysUntilDue = item.dueAt?.difference(DateTime.now()).inDays;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image/Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: item.photoUrls != null && item.photoUrls!.isNotEmpty
                    ? RetryableImage(
                        imageUrl: item.photoUrls!.first,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(12),
                        placeholder: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.inventory_2,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        errorWidgetBuilder: (context, retry) => Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.inventory_2,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.inventory_2,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Borrower
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: GestureDetector(
                            onTap: onBorrowerTap != null
                                ? () => onBorrowerTap!(item.borrowerName)
                                : null,
                            child: Text(
                              item.borrowerName,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.7),
                                decoration: onBorrowerTap != null
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Dates row
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        _buildDateChip(
                          context,
                          Icons.calendar_today,
                          'Lent',
                          DateFormat('MMM d').format(item.lentAt),
                        ),
                        if (item.status == ItemStatus.returned && item.returnedAt != null)
                          _buildDateChip(
                            context,
                            Icons.check_circle,
                            'Returned',
                            DateFormat('MMM d').format(item.returnedAt!),
                          )
                        else if (item.dueAt != null)
                          _buildDateChip(
                            context,
                            Icons.event,
                            'Due',
                            DateFormat('MMM d').format(item.dueAt!),
                            isOverdue: isOverdue,
                            daysUntilDue: daysUntilDue,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Chevron
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

  Widget _buildDateChip(
    BuildContext context,
    IconData icon,
    String label,
    String date, {
    bool isOverdue = false,
    int? daysUntilDue,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    Color chipColor;
    Color textColor;
    
    // Use semantic colors from theme extension
    if (isOverdue) {
      // Error: Coral Red for overdue items
      chipColor = colorScheme.errorContainer;
      textColor = colorScheme.error;
    } else if (daysUntilDue != null && daysUntilDue <= 3) {
      // Warning: Amber for items due within 3 days
      chipColor = colorScheme.warningContainer;
      textColor = colorScheme.warning;
    } else {
      // Default: Surface variant for normal items
      chipColor = colorScheme.surfaceContainerHighest;
      textColor = colorScheme.onSurface.withValues(alpha: 0.7);
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            '$label: $date',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  bool _isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now());
  }
}

