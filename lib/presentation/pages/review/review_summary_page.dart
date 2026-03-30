import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_typography.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/presentation/providers/review_providers.dart';
import 'package:mocard/presentation/providers/card_providers.dart';
import 'package:mocard/presentation/widgets/common/app_card.dart';
import 'package:mocard/presentation/widgets/common/app_button.dart';

class ReviewSummaryPage extends ConsumerWidget {
  const ReviewSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(reviewSessionProvider);

    if (session == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('没有复习数据'),
              const SizedBox(height: AppDimensions.spacingBase),
              AppPrimaryButton(
                label: '返回首页',
                width: 200,
                onPressed: () => context.go('/'),
              ),
            ],
          ),
        ),
      );
    }

    final duration = DateTime.now().difference(session.startedAt);
    final minutes = duration.inMinutes;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        title: const Text('复习完成'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.pageHorizontalPadding),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // 完成图标
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: AppColors.success.withOpacity(0.7),
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              Text(
                '本次复习完成',
                style: AppTypography.headlineMedium,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                minutes > 0 ? '用时 $minutes 分钟' : '用时不到 1 分钟',
                style: AppTypography.labelMedium,
              ),

              const SizedBox(height: AppDimensions.spacingXxl),

              // 统计卡片
              AppCard(
                padding: const EdgeInsets.all(AppDimensions.spacingLg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SummaryStat(
                      label: '总计',
                      value: '${session.reviewedCount}',
                      color: AppColors.textPrimary,
                    ),
                    Container(
                      width: 0.5,
                      height: 40,
                      color: AppColors.divider,
                    ),
                    _SummaryStat(
                      label: '记得',
                      value: '${session.rememberCount}',
                      color: AppColors.ratingRemember,
                    ),
                    Container(
                      width: 0.5,
                      height: 40,
                      color: AppColors.divider,
                    ),
                    _SummaryStat(
                      label: '模糊',
                      value: '${session.vagueCount}',
                      color: AppColors.ratingVague,
                    ),
                    Container(
                      width: 0.5,
                      height: 40,
                      color: AppColors.divider,
                    ),
                    _SummaryStat(
                      label: '忘了',
                      value: '${session.forgotCount}',
                      color: AppColors.ratingForgot,
                    ),
                  ],
                ),
              ),

              // 正确率
              if (session.reviewedCount > 0) ...[
                const SizedBox(height: AppDimensions.spacingBase),
                AppCard(
                  child: Row(
                    children: [
                      Text('掌握率', style: AppTypography.bodyLarge),
                      const Spacer(),
                      Text(
                        '${(session.rememberCount / session.reviewedCount * 100).round()}%',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(flex: 2),

              // 操作按钮
              AppPrimaryButton(
                label: '返回首页',
                onPressed: () {
                  ref.read(reviewSessionProvider.notifier).endSession();
                  ref.invalidate(totalDueCountProvider);
                  ref.invalidate(totalNewCountProvider);
                  context.go('/');
                },
              ),
              const SizedBox(height: AppDimensions.spacingXxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.statNumber.copyWith(
            color: color,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}
