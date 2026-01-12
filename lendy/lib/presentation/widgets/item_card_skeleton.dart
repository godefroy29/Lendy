import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemCardSkeleton extends StatelessWidget {
  const ItemCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Image skeleton
            Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Content skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title skeleton
                  Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    child: Container(
                      height: 20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Borrower skeleton
                  Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    child: Container(
                      height: 16,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Date chips skeleton
                  Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        child: Container(
                          height: 24,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Shimmer.fromColors(
                        baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        child: Container(
                          height: 24,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Chevron skeleton
            Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
