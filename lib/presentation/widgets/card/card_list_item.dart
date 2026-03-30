import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_typography.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/domain/entities/card.dart';
import 'package:mocard/domain/services/media_storage_service.dart';
import 'package:mocard/presentation/providers/database_providers.dart';
import 'package:mocard/presentation/widgets/common/image_viewer.dart';

/// 卡片列表项
class CardListItem extends ConsumerWidget {
  final StudyCard card;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CardListItem({
    super.key,
    required this.card,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaService = ref.watch(mediaStorageServiceProvider);

    return Material(
      color: AppColors.surface,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.pageHorizontalPadding,
            vertical: AppDimensions.spacingMd,
          ),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.divider, width: 0.5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 缩略图
              if (card.hasFrontImage)
                FutureBuilder<String>(
                  future: mediaService.getFullPath(card.frontImagePath!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          right: AppDimensions.spacingMd,
                        ),
                        child: ThumbnailImage(
                          fullPath: snapshot.data!,
                          size: 48,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

              // 内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 题目预览
                    Text(
                      card.frontText ?? '(图片题目)',
                      style: AppTypography.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (card.backText != null) ...[
                      const SizedBox(height: AppDimensions.spacingXs),
                      Text(
                        card.backText!,
                        style: AppTypography.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    // 标记图标行
                    const SizedBox(height: AppDimensions.spacingSm),
                    _buildMarkers(),
                  ],
                ),
              ),

              // 复习状态
              const SizedBox(width: AppDimensions.spacingSm),
              _buildReviewStatus(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkers() {
    final markers = <Widget>[];

    if (card.isFavorite) {
      markers.add(const Icon(
        Icons.star,
        size: 14,
        color: AppColors.accent,
      ));
    }
    if (card.isImportant) {
      markers.add(const Icon(
        Icons.flag,
        size: 14,
        color: AppColors.error,
      ));
    }
    if (card.isDifficult) {
      markers.add(const Icon(
        Icons.warning_amber,
        size: 14,
        color: AppColors.warning,
      ));
    }

    if (card.tags.isNotEmpty) {
      markers.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.label_outline, size: 13, color: AppColors.textTertiary),
          const SizedBox(width: 2),
          Text(
            card.tags.take(2).join(', '),
            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
          ),
        ],
      ));
    }

    if (markers.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppDimensions.spacingSm,
      children: markers,
    );
  }

  Widget _buildReviewStatus() {
    if (card.reviewData.isNew) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        child: const Text(
          '新',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    if (card.reviewData.isDueToday) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.accentLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        child: const Text(
          '待复习',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.accent,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
