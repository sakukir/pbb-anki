import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_typography.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/domain/entities/card.dart';
import 'package:mocard/presentation/providers/database_providers.dart';
import 'package:mocard/presentation/providers/card_providers.dart';
import 'package:mocard/presentation/providers/review_providers.dart';
import 'package:mocard/presentation/providers/settings_providers.dart';
import 'package:mocard/presentation/widgets/review/review_card_widget.dart';
import 'package:mocard/presentation/widgets/review/review_rating_bar.dart';
import 'package:mocard/presentation/widgets/common/empty_state.dart';

class ReviewPage extends ConsumerStatefulWidget {
  final String? deckId;

  const ReviewPage({super.key, this.deckId});

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initReview();
    });
  }

  Future<void> _initReview() async {
    final settings = await ref.read(settingsProvider.future);
    final cardRepo = ref.read(cardRepositoryProvider);

    // 获取待复习卡片
    final dueCards = await cardRepo.getDueCards(
      deckId: widget.deckId,
      limit: settings.dailyReviewLimit,
    );

    // 获取新卡片
    final newCards = await cardRepo.getNewCards(
      deckId: widget.deckId,
      limit: settings.dailyNewCardLimit,
    );

    // 合并：先复习再新学
    final allCards = <StudyCard>[...dueCards, ...newCards];

    if (allCards.isNotEmpty) {
      ref.read(reviewSessionProvider.notifier).startSession(allCards);
    }

    if (mounted) {
      setState(() => _initialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(reviewSessionProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _confirmExit();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          leading: IconButton(
            onPressed: _confirmExit,
            icon: const Icon(Icons.close),
          ),
          title: session != null
              ? Text(
                  '${session.reviewedCount} / ${session.totalCards}',
                  style: AppTypography.titleMedium,
                )
              : null,
          centerTitle: true,
        ),
        body: _buildBody(session),
      ),
    );
  }

  Widget _buildBody(ReviewSession? session) {
    if (!_initialized) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (session == null) {
      return EmptyState(
        icon: Icons.check_circle_outline,
        title: '暂无复习任务',
        subtitle: '今天的任务已完成，或还没有可复习的卡片',
        actionLabel: '返回',
        onAction: () => context.pop(),
      );
    }

    if (session.isComplete) {
      // 跳转到总结页
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/review/summary');
      });
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final card = session.currentCard;
    if (card == null) {
      return const Center(child: Text('数据异常'));
    }

    return SafeArea(
      child: Column(
        children: [
          // 进度条
          LinearProgressIndicator(
            value: session.progress,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 2,
          ),

          // 卡片内容
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.pageHorizontalPadding,
                vertical: AppDimensions.spacingBase,
              ),
              child: ReviewCardWidget(
                card: card,
                isFlipped: session.isFlipped,
                onFlip: () {
                  ref.read(reviewSessionProvider.notifier).flipCard();
                },
              ),
            ),
          ),

          // 评级按钮（翻面后显示）
          if (session.isFlipped)
            Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimensions.spacingXl,
              ),
              child: ReviewRatingBar(
                onRate: (rating) async {
                  await ref
                      .read(reviewSessionProvider.notifier)
                      .rateCard(rating);
                },
              ),
            )
          else
            // 翻面按钮（大按钮，方便单手操作）
            Padding(
              padding: const EdgeInsets.only(
                left: AppDimensions.pageHorizontalPadding,
                right: AppDimensions.pageHorizontalPadding,
                bottom: AppDimensions.spacingXl,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(reviewSessionProvider.notifier).flipCard();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusBase,
                      ),
                    ),
                  ),
                  child: const Text(
                    '显示答案',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _confirmExit() {
    final session = ref.read(reviewSessionProvider);
    if (session == null || session.reviewedCount == 0) {
      ref.read(reviewSessionProvider.notifier).endSession();
      context.pop();
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('退出复习？'),
          content: Text(
            '已完成 ${session.reviewedCount}/${session.totalCards} 张卡片的复习，'
            '退出后进度会保留。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('继续复习'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(reviewSessionProvider.notifier).endSession();
                context.pop();
              },
              child: const Text('退出'),
            ),
          ],
        );
      },
    );
  }
}
