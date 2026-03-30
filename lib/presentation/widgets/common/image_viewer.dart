import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_dimensions.dart';

/// 本地图片展示组件
/// 支持点击查看大图
class LocalImageView extends StatelessWidget {
  final String fullPath;
  final double? width;
  final double? height;
  final double? maxHeight;
  final BoxFit fit;
  final bool enablePreview;
  final BorderRadius? borderRadius;

  const LocalImageView({
    super.key,
    required this.fullPath,
    this.width,
    this.height,
    this.maxHeight,
    this.fit = BoxFit.contain,
    this.enablePreview = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(fullPath);

    final imageWidget = ClipRRect(
      borderRadius: borderRadius ??
          BorderRadius.circular(AppDimensions.radiusMd),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight ?? AppDimensions.imagePreviewMaxHeight,
        ),
        child: Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => _buildError(),
        ),
      ),
    );

    if (!enablePreview) return imageWidget;

    return GestureDetector(
      onTap: () => _showFullScreen(context, file),
      child: imageWidget,
    );
  }

  Widget _buildError() {
    return Container(
      width: width ?? 80,
      height: height ?? 60,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: borderRadius ??
            BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined,
              size: 24, color: AppColors.textTertiary),
          SizedBox(height: 2),
          Text(
            '图片加载失败',
            style: TextStyle(fontSize: 10, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  void _showFullScreen(BuildContext context, File file) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        barrierDismissible: true,
        pageBuilder: (context, _, __) {
          return _FullScreenImageView(file: file);
        },
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class _FullScreenImageView extends StatelessWidget {
  final File file;

  const _FullScreenImageView({required this.file});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Stack(
            children: [
              // 图片
              Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.file(
                    file,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),
              // 关闭按钮
              Positioned(
                top: AppDimensions.spacingBase,
                right: AppDimensions.spacingBase,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black38,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 缩略图组件（用于列表）
class ThumbnailImage extends StatelessWidget {
  final String fullPath;
  final double size;

  const ThumbnailImage({
    super.key,
    required this.fullPath,
    this.size = AppDimensions.thumbnailSize,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: SizedBox(
        width: size,
        height: size,
        child: Image.file(
          File(fullPath),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.surfaceVariant,
            child: const Icon(
              Icons.image_outlined,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}
