import 'package:flutter/material.dart';

class SuccessAnimation extends StatelessWidget {
  final String message;
  final VoidCallback? onComplete;

  const SuccessAnimation({
    super.key,
    required this.message,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    // Simple success animation using built-in icons and animations
    // Since we don't have a lottie file, we'll use a Material success animation
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon with animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onComplete?.call();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context, String message, {VoidCallback? onComplete}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessAnimation(
        message: message,
        onComplete: onComplete,
      ),
    );
    
    // Auto-dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(context).pop();
        onComplete?.call();
      }
    });
  }
}
