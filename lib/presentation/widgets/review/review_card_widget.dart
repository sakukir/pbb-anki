import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_typography.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/domain/entities/card.dart';
import 'package:mocard/presentation/providers/database_providers.dart';
import 'package:mocard/presentation/widgets/common/image_viewer.dart';

/// 复习卡片展示组件
class ReviewCardWidget extends ConsumerWidget {
  final StudyCard card;
  final bool isFlipped;
  final VoidCallback onFlip;

  const ReviewCardWidget({
    super.key,
    required this.card,
    required this.isFlipped,
    required this.onFlip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaService = ref.watch(mediaStorageServiceProvider);

    return GestureDetector(
      onTap: isFlipped ? null : onFlip,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标记
              _buildMarkers(),

              // ── 题目（正面） ──
              if (card.frontText != null && card.frontText!.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.spacingSm),
                SelectableText(
                  card.frontText!,
                  style: AppTypography.cardFront,
                ),
              ],

              if (card.frontImagePath != null) ...[
                const SizedBox(height: AppDimensions.spacingBase),
                FutureBuilder<String>(
                  future: mediaService.getFullPath(card.frontImagePath!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return LocalImageView(
                        fullPath: snapshot.data!,
                        maxHeight: 240,
                        fit: BoxFit.contain,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],

              // ── 分隔线和答案（背面） ──
              if (isFlipped) ...[
                const SizedBox(height: AppDimensions.spacingLg),
                Container(
                  height: 1,
                  color: AppColors.divider,
                ),
                const SizedBox(height: AppDimensions.spacingLg),

                Text(
                  '答案',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSm),

                if (card.backText != null && card.backText!.isNotEmpty)
                  SelectableText(
                    card.backText!,
                    style: AppTypography.cardBack,
                  ),

                if (card.backImagePath != null) ...[
                  const SizedBox(height: AppDimensions.spacingBase),
                  FutureBuilder<String>(
                    future: mediaService.getFullPath(card.backImagePath!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return LocalImageView(
                          fullPath: snapshot.data!,
                          maxHeight: 240,
                          fit: BoxFit.contain,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],

                // 备注
                if (card.note != null && card.note!.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.spacingBase),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.spacingMd),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '备注',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        SelectableText(
                          card.note!,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],

              // ── 翻面提示 ──
              if (!isFlipped) ...[
                const SizedBox(height: AppDimensions.spacingXxl),
                Center(
                  child: Text(
                    '点击卡片查看答案',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkers() {
    final markers = <Widget>[];

    if (card.isFavorite) {
      markers.add(const Icon(Icons.star, size: 16, color: AppColors.accent));
    }
    if (card.isImportant) {
      markers.add(const Icon(Icons.flag, size: 16, color: AppColors.error));
    }
    if (card.isDifficult) {
      markers.add(
        const Icon(Icons.warning_amber, size: 16, color: AppColors.warning),
      );
    }

    if (markers.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: Row(
        children: [
          ...markers.map(
            (m) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: m,
            ),
          ),
        ],
      ),
    );
  }
}
