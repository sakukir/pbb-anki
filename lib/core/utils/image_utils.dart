import 'dart:io';
import 'package:flutter/material.dart';

/// 图片工具类
class ImageUtils {
  ImageUtils._();

  /// 获取图片文件的扩展名
  static String getExtension(String path) {
    final lastDot = path.lastIndexOf('.');
    if (lastDot == -1) return 'jpg';
    return path.substring(lastDot + 1).toLowerCase();
  }

  /// 判断文件是否为图片
  static bool isImageFile(String path) {
    final ext = getExtension(path);
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
  }

  /// 安全加载本地图片
  static ImageProvider loadLocalImage(String fullPath) {
    return FileImage(File(fullPath));
  }

  /// 构建图片 Widget，处理错误情况
  static Widget buildLocalImage({
    required String fullPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Widget? errorWidget,
  }) {
    final file = File(fullPath);

    return FutureBuilder<bool>(
      future: file.exists(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Image.file(
            file,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) {
              return errorWidget ?? _buildImageError();
            },
          );
        }
        return errorWidget ?? _buildImageError();
      },
    );
  }

  static Widget _buildImageError() {
    return Container(
      color: const Color(0xFFF5F5F3),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image_outlined, size: 32, color: Color(0xFF9B9B9B)),
            SizedBox(height: 4),
            Text(
              '图片加载失败',
              style: TextStyle(fontSize: 12, color: Color(0xFF9B9B9B)),
            ),
          ],
        ),
      ),
    );
  }
}
