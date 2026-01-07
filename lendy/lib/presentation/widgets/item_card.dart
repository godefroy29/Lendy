import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: item.photoUrls != null && item.photoUrls!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  item.photoUrls!.first,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image, size: 50);
                  },
                ),
              )
            : const Icon(Icons.inventory_2, size: 50),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Borrower: ${item.borrowerName}'),
            const SizedBox(height: 4),
            Text(
              'Lent: ${DateFormat('MMM d, y').format(item.lentAt)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (item.dueAt != null) ...[
              const SizedBox(height: 4),
              Text(
                'Due: ${DateFormat('MMM d, y').format(item.dueAt!)}',
                style: TextStyle(
                  color: _isOverdue(item.dueAt!) 
                      ? Colors.red 
                      : Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  bool _isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now());
  }
}

