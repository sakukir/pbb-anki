import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_typography.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/presentation/providers/deck_providers.dart';
import 'package:mocard/presentation/providers/card_providers.dart';
import 'package:mocard/presentation/widgets/card/card_list_item.dart';
import 'package:mocard/presentation/widgets/common/empty_state.dart';

class DeckDetailPage extends ConsumerWidget {
  final String deckId;

  const DeckDetailPage({super.key, required this.deckId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deckAsync = ref.watch(deckDetailProvider(deckId));
    final cardsAsync = ref.watch(cardListByDeckProvider(deckId));
    final dueCardsAsync = ref.watch(dueCardsProvider(deckId));
    final newCardsAsync = ref.watch(newCardsProvider(deckId));

    return deckAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('加载失败: $e')),
      ),
      data: (deck) {
        if (deck == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('卡组不存在')),
          );
        }

        final dueCount = dueCardsAsync.valueOrNull?.length ?? 0;
        final newCount = newCardsAsync.valueOrNull?.length ?? 0;

        return Scaffold(
          appBar: AppBar(
            title: Text(deck.name),
            actions: [
              IconButton(
                onPressed: () => context.push('/decks/$deckId/edit'),
                icon: const Icon(Icons.edit_outlined),
                tooltip: '编辑卡组',
              ),
            ],
          ),
          body: Column(
            children: [
              // ── 卡组信息头 ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.pageHorizontalPadding,
                  vertical: AppDimensions.spacingBase,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (deck.description != null &&
                        deck.description!.isNotEmpty) ...[
                      Text(
                        deck.description!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                    ],

                    // 统计行
                    Row(
                      children: [
                        _InfoChip(
                          label: '${deck.cardCount} 张',
                          icon: Icons.layers_outlined,
                        ),
                        if (dueCount > 0) ...[
                          const SizedBox(width: AppDimensions.spacingMd),
                          _InfoChip(
                            label: '$dueCount 待复习',
                            icon: Icons.replay,
                            color: AppColors.accent,
                          ),
                        ],
                        if (newCount > 0) ...[
                          const SizedBox(width: AppDimensions.spacingMd),
                          _InfoChip(
                            label: '$newCount 新',
                            icon: Icons.fiber_new_outlined,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),

                    // 开始复习按钮
                    if (dueCount > 0 || newCount > 0) ...[
                      const SizedBox(height: AppDimensions.spacingBase),
                      SizedBox(
                        width: double.infinity,
                        height: AppDimensions.buttonHeight,
                        child: ElevatedButton(
                          onPressed: () =>
                              context.push('/review?deckId=$deckId'),
                          child: Text(
                            dueCount > 0
                                ? '开始复习 ($dueCount)'
                                : '学习新卡片 ($newCount)',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const Divider(),

              // ── 卡片列表 ──
              Expanded(
                child: cardsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (e, _) => Center(child: Text('加载失败: $e')),
                  data: (cards) {
                    if (cards.isEmpty) {
                      return EmptyState(
                        icon: Icons.note_add_outlined,
                        title: '还没有卡片',
                        subtitle: '添加卡片开始学习',
                        actionLabel: '添加卡片',
                        onAction: () =>
                            context.push('/decks/$deckId/cards/new'),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(cardListByDeckProvider(deckId));
                        ref.invalidate(deckDetailProvider(deckId));
                      },
                      child: ListView.builder(
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          return CardListItem(
                            card: card,
                            onTap: () => context.push(
                              '/decks/$deckId/cards/${card.id}/edit',
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push('/decks/$deckId/cards/new'),
            tooltip: '添加卡片',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;

  const _InfoChip({
    required this.label,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: c),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: c),
        ),
      ],
    );
  }
}
