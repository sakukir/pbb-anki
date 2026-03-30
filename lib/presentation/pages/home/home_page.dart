import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_typography.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/core/constants/app_constants.dart';
import 'package:mocard/core/router/app_router.dart';
import 'package:mocard/domain/entities/deck.dart';
import 'package:mocard/domain/entities/study_stats.dart';
import 'package:mocard/presentation/providers/deck_providers.dart';
import 'package:mocard/presentation/providers/card_providers.dart';
import 'package:mocard/presentation/providers/stats_providers.dart';
import 'package:mocard/presentation/widgets/common/app_card.dart';
import 'package:mocard/presentation/widgets/common/empty_state.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(deckListProvider);
    final stats = ref.watch(statsOverviewProvider);
    final dueCount = ref.watch(totalDueCountProvider);
    final newCount = ref.watch(totalNewCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            onPressed: () => context.push('/search'),
            icon: const Icon(Icons.search, size: AppDimensions.iconBase),
            tooltip: '搜索',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(deckListProvider);
          ref.invalidate(statsOverviewProvider);
          ref.invalidate(totalDueCountProvider);
          ref.invalidate(totalNewCountProvider);
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.pageHorizontalPadding,
            vertical: AppDimensions.pageTopPadding,
          ),
          children: [
            // ── 今日概览 ──
            _buildTodayOverview(context, dueCount, newCount, stats),

            const SizedBox(height: AppDimensions.spacingXl),

            // ── 快速开始 ──
            _buildQuickStart(context, ref, dueCount, newCount),

            const SizedBox(height: AppDimensions.spacingXl),

            // ── 最近卡组 ──
            _buildRecentDecks(context, decks),

            const SizedBox(height: AppDimensions.spacingXl),

            // ── 学习简报 ──
            _buildStudyBrief(stats),

            const SizedBox(height: AppDimensions.spacingXxl),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayOverview(
    BuildContext context,
    AsyncValue<int> dueCount,
    AsyncValue<int> newCount,
    AsyncValue<StudyStatsOverview> asyncStats,
  ) {
    final due = dueCount.valueOrNull ?? 0;
    final newC = newCount.valueOrNull ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('今日学习', style: AppTypography.headlineSmall),
        const SizedBox(height: AppDimensions.spacingMd),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: '待复习',
                value: '$due',
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: _StatCard(
                label: '新卡片',
                value: '$newC',
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStart(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<int> dueCount,
    AsyncValue<int> newCount,
  ) {
    final due = dueCount.valueOrNull ?? 0;
    final newC = newCount.valueOrNull ?? 0;
    final hasCards = due > 0 || newC > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasCards)
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight,
            child: ElevatedButton(
              onPressed: () => context.push('/review'),
              child: Text(
                due > 0 ? '开始复习 ($due)' : '学习新卡片 ($newC)',
              ),
            ),
          )
        else
          AppCard(
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: Text(
                    '今日暂无复习任务',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRecentDecks(
    BuildContext context,
    AsyncValue<List<Deck>> asyncDecks,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('我的卡组', style: AppTypography.headlineSmall),
            TextButton(
              onPressed: () => context.go(AppRoutes.decks),
              child: const Text('查看全部'),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        asyncDecks.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacingXl),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (e, _) => AppCard(
            child: Text('加载失败: $e', style: AppTypography.bodyMedium),
          ),
          data: (decks) {
            if (decks.isEmpty) {
              return AppCard(
                onTap: () => context.push('/decks/new'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Text(
                      '创建第一个卡组',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }

            // 显示最近 5 个卡组
            final recent = decks.take(5).toList();
            return Column(
              children: recent.map((deck) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.spacingSm,
                  ),
                  child: AppCard(
                    onTap: () => context.push('/decks/${deck.id}'),
                    child: Row(
                      children: [
                        // 分类色条
                        Container(
                          width: 3,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(deck.category),
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingMd),
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
                              Text(
                                '${deck.cardCount} 张卡片',
                                style: AppTypography.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: AppDimensions.iconMd,
                          color: AppColors.textTertiary,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStudyBrief(AsyncValue<StudyStatsOverview> asyncStats) {
    return asyncStats.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (stats) {
        if (stats.streakDays == 0 &&
            stats.todayNewCards == 0 &&
            stats.todayReviewedCards == 0) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('学习概况', style: AppTypography.headlineSmall),
            const SizedBox(height: AppDimensions.spacingMd),
            AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MiniStat(
                    label: '连续学习',
                    value: '${stats.streakDays}天',
                  ),
                  Container(
                    width: 0.5,
                    height: 32,
                    color: AppColors.divider,
                  ),
                  _MiniStat(
                    label: '今日新学',
                    value: '${stats.todayNewCards}',
                  ),
                  Container(
                    width: 0.5,
                    height: 32,
                    color: AppColors.divider,
                  ),
                  _MiniStat(
                    label: '今日复习',
                    value: '${stats.todayReviewedCards}',
                  ),
                ],
              ),
            ),
          ],
        );
      },
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelMedium),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            value,
            style: AppTypography.statNumber.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTypography.titleMedium),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}
