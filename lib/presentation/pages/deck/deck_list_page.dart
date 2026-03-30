import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_typography.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/presentation/providers/deck_providers.dart';
import 'package:mocard/presentation/providers/card_providers.dart';
import 'package:mocard/presentation/widgets/deck/deck_list_item.dart';
import 'package:mocard/presentation/widgets/common/empty_state.dart';

class DeckListPage extends ConsumerWidget {
  const DeckListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsync = ref.watch(deckListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('卡组'),
        actions: [
          IconButton(
            onPressed: () => context.push('/search'),
            icon: const Icon(Icons.search),
            tooltip: '搜索',
          ),
        ],
      ),
      body: decksAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (decks) {
          if (decks.isEmpty) {
            return EmptyState(
              icon: Icons.folder_outlined,
              title: '还没有卡组',
              subtitle: '创建一个卡组开始整理你的知识点',
              actionLabel: '创建卡组',
              onAction: () => context.push('/decks/new'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(deckListProvider);
            },
            child: ListView.builder(
              itemCount: decks.length,
              itemBuilder: (context, index) {
                final deck = decks[index];
                return DeckListItem(
                  deck: deck,
                  onTap: () => context.push('/decks/${deck.id}'),
                  onLongPress: () =>
                      _showDeckOptions(context, ref, deck.id, deck.name),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/decks/new'),
        tooltip: '新建卡组',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeckOptions(
    BuildContext context,
    WidgetRef ref,
    String deckId,
    String deckName,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(
                  top: AppDimensions.spacingMd,
                  bottom: AppDimensions.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.pageHorizontalPadding,
                  vertical: AppDimensions.spacingSm,
                ),
                child: Text(deckName, style: AppTypography.titleMedium),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('编辑卡组'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/decks/$deckId/edit');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                ),
                title: Text(
                  '删除卡组',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, ref, deckId, deckName);
                },
              ),
              const SizedBox(height: AppDimensions.spacingBase),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String deckId,
    String deckName,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('确认删除'),
          content: Text('删除「$deckName」后，卡组内所有卡片也会被删除。此操作不可撤回。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await ref.read(deckListProvider.notifier).deleteDeck(deckId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已删除')),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
  }
}
