import 'package:flutter/material.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_typography.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/core/utils/date_utils.dart';
import 'package:mocard/domain/entities/deck.dart';

/// 卡组列表项
class DeckListItem extends StatelessWidget {
  final Deck deck;
  final int? dueCount;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const DeckListItem({
    super.key,
    required this.deck,
    this.dueCount,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
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
            children: [
              // 左侧分类色条
              Container(
                width: 3,
                height: 40,
                decoration: BoxDecoration(
                  color: _getCategoryColor(deck.category),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMd),

              // 中间内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deck.name,
                      style: AppTypography.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    Row(
                      children: [
                        Text(
                          '${deck.cardCount} 张卡片',
                          style: AppTypography.labelSmall,
                        ),
                        if (deck.category != null) ...[
                          const SizedBox(width: AppDimensions.spacingSm),
                          Text('·', style: AppTypography.labelSmall),
                          const SizedBox(width: AppDimensions.spacingSm),
                          Text(deck.category!, style: AppTypography.labelSmall),
                        ],
                        const SizedBox(width: AppDimensions.spacingSm),
                        Text('·', style: AppTypography.labelSmall),
                        const SizedBox(width: AppDimensions.spacingSm),
                        Text(
                          AppDateUtils.toRelativeTime(deck.updatedAt),
                          style: AppTypography.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 右侧待复习数
              if (dueCount != null && dueCount! > 0) ...[
                const SizedBox(width: AppDimensions.spacingSm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingSm,
                    vertical: AppDimensions.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMd,
                    ),
                  ),
                  child: Text(
                    '$dueCount',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],

              const SizedBox(width: AppDimensions.spacingSm),
              const Icon(
                Icons.chevron_right,
                size: AppDimensions.iconMd,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case '英语':
        return const Color(0xFF4A6A8A);
      case '政治':
        return const Color(0xFFC05746);
      case '数学':
        return const Color(0xFF4A6741);
      case '专业课':
        return const Color(0xFFC17B3A);
      default:
        return AppColors.textTertiary;
    }
  }
}
