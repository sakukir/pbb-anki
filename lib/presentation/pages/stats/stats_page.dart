import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_typography.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/domain/entities/study_stats.dart';
import 'package:mocard/presentation/providers/stats_providers.dart';
import 'package:mocard/presentation/widgets/common/app_card.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsOverviewProvider);
    final progressAsync = ref.watch(deckProgressListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('学习统计'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(statsOverviewProvider);
          ref.invalidate(deckProgressListProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.pageHorizontalPadding),
          children: [
            // ── 今日概览 ──
            statsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.spacingXl),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (e, _) => Text('加载失败: $e'),
              data: (stats) => _buildOverview(stats),
            ),

            const SizedBox(height: AppDimensions.spacingXl),

            // ── 最近7天 ──
            statsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (stats) => _buildWeekChart(stats),
            ),

            const SizedBox(height: AppDimensions.spacingXl),

            // ── 卡组进度 ──
            Text('卡组进度', style: AppTypography.headlineSmall),
            const SizedBox(height: AppDimensions.spacingMd),
            progressAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (e, _) => Text('加载失败: $e'),
              data: (list) {
                if (list.isEmpty) {
                  return AppCard(
                    child: Center(
                      child: Text(
                        '还没有卡组',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  children: list
                      .map((p) => _buildDeckProgressItem(p))
                      .toList(),
                );
              },
            ),

            const SizedBox(height: AppDimensions.spacingXxl),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview(StudyStatsOverview stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('今日', style: AppTypography.headlineSmall),
        const SizedBox(height: AppDimensions.spacingMd),
        Row(
          children: [
            Expanded(
              child: _OverviewItem(
                label: '新学',
                value: '${stats.todayNewCards}',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: _OverviewItem(
                label: '复习',
                value: '${stats.todayReviewedCards}',
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: _OverviewItem(
                label: '连续',
                value: '${stats.streakDays}天',
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        AppCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('总卡片数', style: AppTypography.bodyMedium),
              Text('${stats.totalCards}', style: AppTypography.titleMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekChart(StudyStatsOverview stats) {
    if (stats.recentRecords.isEmpty) return const SizedBox.shrink();

    // 找出最大值用于缩放
    int maxVal = 1;
    for (final r in stats.recentRecords) {
      if (r.totalStudied > maxVal) maxVal = r.totalStudied;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('最近 7 天', style: AppTypography.headlineSmall),
        const SizedBox(height: AppDimensions.spacingMd),
        AppCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingBase,
            vertical: AppDimensions.spacingLg,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: stats.recentRecords.map((record) {
              final height = maxVal > 0
                  ? (record.totalStudied / maxVal * 80).clamp(0.0, 80.0)
                  : 0.0;
              // 提取日期中的日
              final day = record.date.substring(8);

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      record.totalStudied > 0
                          ? '${record.totalStudied}'
                          : '',
                      style: AppTypography.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: height == 0 ? 2 : height,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: record.totalStudied > 0
                            ? AppColors.primary.withOpacity(0.6)
                            : AppColors.divider,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      day,
                      style: AppTypography.labelSmall.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDeckProgressItem(DeckProgress progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    progress.deckName,
                    style: AppTypography.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${(progress.progress * 100).round()}%',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingSm),

            // 进度条
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress.progress,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),

            // 详情
            Row(
              children: [
                _ProgressLabel(
                  label: '已掌握',
                  count: progress.masteredCards,
                  color: AppColors.success,
                ),
                const SizedBox(width: AppDimensions.spacingBase),
                _ProgressLabel(
                  label: '学习中',
                  count: progress.learningCards,
                  color: AppColors.accent,
                ),
                const SizedBox(width: AppDimensions.spacingBase),
                _ProgressLabel(
                  label: '未学习',
                  count: progress.newCards,
                  color: AppColors.textTertiary,
                ),
                if (progress.dueCards > 0) ...[
                  const SizedBox(width: AppDimensions.spacingBase),
                  _ProgressLabel(
                    label: '待复习',
                    count: progress.dueCards,
                    color: AppColors.error,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _OverviewItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.statNumber.copyWith(color: color),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}

class _ProgressLabel extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _ProgressLabel({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label $count',
          style: AppTypography.labelSmall,
        ),
      ],
    );
  }
}
