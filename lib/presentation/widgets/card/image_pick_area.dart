import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/core/theme/app_typography.dart';

/// 图片选择区域
class ImagePickArea extends StatelessWidget {
  final String label;
  final File? selectedFile;
  final String? existingImagePath; // 已有图片的完整路径
  final ValueChanged<File?> onImageChanged;

  const ImagePickArea({
    super.key,
    required this.label,
    this.selectedFile,
    this.existingImagePath,
    required this.onImageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = selectedFile != null || existingImagePath != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelLarge),
        const SizedBox(height: AppDimensions.spacingSm),
        if (hasImage)
          _buildImagePreview(context)
        else
          _buildPickButton(context),
      ],
    );
  }

  Widget _buildPickButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Container(
        width: double.infinity,
        height: AppDimensions.imagePickAreaHeight,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppDimensions.radiusBase),
          border: Border.all(
            color: AppColors.border,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 32,
              color: AppColors.textTertiary.withOpacity(0.6),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              '点击添加图片',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            maxHeight: AppDimensions.imagePreviewMaxHeight,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusBase),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusBase),
            child: selectedFile != null
                ? Image.file(
                    selectedFile!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => _buildErrorPlaceholder(),
                  )
                : Image.file(
                    File(existingImagePath!),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => _buildErrorPlaceholder(),
                  ),
          ),
        ),
        // 操作按钮
        Positioned(
          top: AppDimensions.spacingSm,
          right: AppDimensions.spacingSm,
          child: Row(
            children: [
              _buildActionButton(
                icon: Icons.refresh,
                tooltip: '更换图片',
                onTap: () => _pickImage(context),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              _buildActionButton(
                icon: Icons.close,
                tooltip: '移除图片',
                onTap: () => onImageChanged(null),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.black38,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      height: 100,
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 32,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (image != null) {
      onImageChanged(File(image.path));
    }
  }
}
