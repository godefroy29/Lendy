import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RetryableImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget Function(BuildContext, VoidCallback)? errorWidgetBuilder;

  const RetryableImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidgetBuilder,
  });

  @override
  State<RetryableImage> createState() => _RetryableImageState();
}

class _RetryableImageState extends State<RetryableImage> {
  int _retryKey = 0;

  void _retry() {
    setState(() {
      _retryKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build default placeholder widget
    Widget buildDefaultPlaceholder([double? progressValue]) {
      if (widget.placeholder != null) {
        return widget.placeholder!;
      }
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: widget.borderRadius,
        ),
        child: Center(
          child: CircularProgressIndicator(
            value: progressValue,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    // Use key to force rebuild on retry
    // Note: placeholder and progressIndicatorBuilder are mutually exclusive in CachedNetworkImage
    Widget imageWidget = CachedNetworkImage(
      key: ValueKey(_retryKey),
      imageUrl: widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      progressIndicatorBuilder: (context, url, progress) {
        return buildDefaultPlaceholder(progress.progress);
      },
      errorWidget: (context, url, error) {
        if (widget.errorWidgetBuilder != null) {
          return widget.errorWidgetBuilder!(context, _retry);
        }
        
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
            borderRadius: widget.borderRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                size: widget.width != null && widget.width! < 100 ? 32 : 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Failed to load image',
                  style: TextStyle(
                    fontSize: widget.width != null && widget.width! < 100 ? 10 : 12,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              TextButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Retry'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        );
      },
      // Cache configuration
      maxWidthDiskCache: 1920,
      maxHeightDiskCache: 1920,
      memCacheWidth: widget.width?.toInt(),
      memCacheHeight: widget.height?.toInt(),
    );

    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
