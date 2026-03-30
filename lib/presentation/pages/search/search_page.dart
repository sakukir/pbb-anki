import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_typography.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/domain/entities/card.dart';
import 'package:mocard/domain/repositories/card_repository.dart';
import 'package:mocard/presentation/providers/database_providers.dart';
import 'package:mocard/presentation/providers/card_providers.dart';
import 'package:mocard/presentation/widgets/card/card_list_item.dart';
import 'package:mocard/presentation/widgets/common/app_text_field.dart';
import 'package:mocard/presentation/widgets/common/app_tag.dart';
import 'package:mocard/presentation/widgets/common/empty_state.dart';

/// 搜索查询状态
final _searchQueryProvider = StateProvider<String>((ref) => '');
final _searchFilterProvider = StateProvider<CardFilter>(
  (ref) => const CardFilter(),
);

/// 搜索结果
final _searchResultsProvider =
    FutureProvider<List<StudyCard>>((ref) async {
  final query = ref.watch(_searchQueryProvider);
  final filter = ref.watch(_searchFilterProvider);

  final combinedFilter = CardFilter(
    keyword: query.isNotEmpty ? query : null,
    tag: filter.tag,
    isFavorite: filter.isFavorite,
    isImportant: filter.isImportant,
    isDifficult: filter.isDifficult,
    isDueToday: filter.isDueToday,
  );

  if (!combinedFilter.hasActiveFilters && query.isEmpty) {
    return [];
  }

  return ref.watch(cardRepositoryProvider).getFilteredCards(combinedFilter);
});

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(_searchResultsProvider);
    final filter = ref.watch(_searchFilterProvider);
    final query = ref.watch(_searchQueryProvider);
    final tagsAsync = ref.watch(allTagsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索'),
      ),
      body: Column(
        children: [
          // 搜索栏
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.pageHorizontalPadding,
              vertical: AppDimensions.spacingSm,
            ),
            child: AppSearchField(
              controller: _searchController,
              hint: '搜索卡片内容...',
              autofocus: true,
              onChanged: (value) {
                ref.read(_searchQueryProvider.notifier).state = value;
              },
              onClear: () {
                ref.read(_searchQueryProvider.notifier).state = '';
              },
            ),
          ),

          // 筛选标签
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.pageHorizontalPadding,
            ),
            child: Row(
              children: [
                _FilterChip(
                  label: '收藏',
                  icon: Icons.star_outline,
                  isActive: filter.isFavorite == true,
                  onTap: () {
                    ref.read(_searchFilterProvider.notifier).state = CardFilter(
                      tag: filter.tag,
                      isFavorite: filter.isFavorite == true ? null : true,
                      isImportant: filter.isImportant,
                      isDifficult: filter.isDifficult,
                      isDueToday: filter.isDueToday,
                    );
                  },
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                _FilterChip(
                  label: '重点',
                  icon: Icons.flag_outlined,
                  isActive: filter.isImportant == true,
                  onTap: () {
                    ref.read(_searchFilterProvider.notifier).state = CardFilter(
                      tag: filter.tag,
                      isFavorite: filter.isFavorite,
                      isImportant: filter.isImportant == true ? null : true,
                      isDifficult: filter.isDifficult,
                      isDueToday: filter.isDueToday,
                    );
                  },
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                _FilterChip(
                  label: '易错',
                  icon: Icons.warning_amber_outlined,
                  isActive: filter.isDifficult == true,
                  onTap: () {
                    ref.read(_searchFilterProvider.notifier).state = CardFilter(
                      tag: filter.tag,
                      isFavorite: filter.isFavorite,
                      isImportant: filter.isImportant,
                      isDifficult: filter.isDifficult == true ? null : true,
                      isDueToday: filter.isDueToday,
                    );
                  },
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                _FilterChip(
                  label: '待复习',
                  icon: Icons.replay,
                  isActive: filter.isDueToday == true,
                  onTap: () {
                    ref.read(_searchFilterProvider.notifier).state = CardFilter(
                      tag: filter.tag,
                      isFavorite: filter.isFavorite,
                      isImportant: filter.isImportant,
                      isDifficult: filter.isDifficult,
                      isDueToday: filter.isDueToday == true ? null : true,
                    );
                  },
                ),
              ],
            ),
          ),

          // 标签选择
          tagsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (tags) {
              if (tags.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(
                  left: AppDimensions.pageHorizontalPadding,
                  right: AppDimensions.pageHorizontalPadding,
                  top: AppDimensions.spacingSm,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: tags.map((tag) {
                      final isActive = filter.tag == tag;
                      return Padding(
                        padding: const EdgeInsets.only(
                          right: AppDimensions.spacingSm,
                        ),
                        child: AppTag(
                          label: tag,
                          backgroundColor: isActive
                              ? AppColors.primary
                              : null,
                          textColor: isActive
                              ? AppColors.textOnPrimary
                              : null,
                          onTap: () {
                            ref.read(_searchFilterProvider.notifier).state =
                                CardFilter(
                              tag: isActive ? null : tag,
                              isFavorite: filter.isFavorite,
                              isImportant: filter.isImportant,
                              isDifficult: filter.isDifficult,
                              isDueToday: filter.isDueToday,
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppDimensions.spacingSm),
          const Divider(),

          // 搜索结果
          Expanded(
            child: results.when(
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (e, _) => Center(child: Text('搜索失败: $e')),
              data: (cards) {
                if (query.isEmpty && !filter.hasActiveFilters) {
                  return const EmptyState(
                    icon: Icons.search,
                    title: '搜索卡片',
                    subtitle: '输入关键字或选择筛选条件',
                  );
                }

                if (cards.isEmpty) {
                  return const EmptyState(
                    icon: Icons.search_off,
                    title: '没有找到匹配的卡片',
                    subtitle: '试试其他关键字或筛选条件',
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.pageHorizontalPadding,
                        vertical: AppDimensions.spacingSm,
                      ),
                      child: Text(
                        '${cards.length} 条结果',
                        style: AppTypography.labelSmall,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          return CardListItem(
                            card: card,
                            onTap: () => context.push(
                              '/decks/${card.deckId}/cards/${card.id}/edit',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMd,
          vertical: AppDimensions.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? AppColors.textOnPrimary : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isActive
                    ? AppColors.textOnPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
