import 'package:flutter/material.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_dimensions.dart';

/// 标签组件
class AppTag extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool removable;
  final VoidCallback? onRemove;

  const AppTag({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.removable = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    // 根据标签内容选择颜色
    final colorIndex = label.hashCode.abs() % AppColors.tagColors.length;
    final bgColor = backgroundColor ?? AppColors.tagColors[colorIndex];
    final fgColor = textColor ?? AppColors.tagTextColors[colorIndex];

    final content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: fgColor,
            ),
          ),
          if (removable) ...[
            const SizedBox(width: 2),
            GestureDetector(
              onTap: onRemove,
              child: Icon(Icons.close, size: 14, color: fgColor),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}

/// 标签列表（自动换行）
class AppTagList extends StatelessWidget {
  final List<String> tags;
  final void Function(String)? onTagTap;
  final bool removable;
  final void Function(String)? onRemove;

  const AppTagList({
    super.key,
    required this.tags,
    this.onTagTap,
    this.removable = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingXs,
      children: tags.map((tag) {
        return AppTag(
          label: tag,
          onTap: onTagTap != null ? () => onTagTap!(tag) : null,
          removable: removable,
          onRemove: onRemove != null ? () => onRemove!(tag) : null,
        );
      }).toList(),
    );
  }
}
