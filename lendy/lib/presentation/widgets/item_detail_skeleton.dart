import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemDetailSkeleton extends StatelessWidget {
  const ItemDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title skeleton
          Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            child: Container(
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Status badge skeleton
          Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            child: Container(
              height: 28,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Section skeletons
          ...List.generate(4, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  child: Container(
                    height: 24,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
