import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:mocard/core/utils/date_utils.dart';
import 'package:mocard/domain/entities/card.dart';
import 'package:mocard/domain/entities/review_log.dart';
import 'package:mocard/domain/entities/study_stats.dart';
import 'database_providers.dart';

const _uuid = Uuid();

/// 复习会话状态
class ReviewSession {
  final List<StudyCard> cards;
  final int currentIndex;
  final bool isFlipped;
  final bool isComplete;
  final int totalCards;
  final int reviewedCount;
  final int forgotCount;
  final int vagueCount;
  final int rememberCount;
  final DateTime startedAt;

  const ReviewSession({
    required this.cards,
    this.currentIndex = 0,
    this.isFlipped = false,
    this.isComplete = false,
    required this.totalCards,
    this.reviewedCount = 0,
    this.forgotCount = 0,
    this.vagueCount = 0,
    this.rememberCount = 0,
    required this.startedAt,
  });

  StudyCard? get currentCard {
    if (currentIndex >= cards.length) return null;
    return cards[currentIndex];
  }

  double get progress {
    if (totalCards == 0) return 0;
    return reviewedCount / totalCards;
  }

  ReviewSession copyWith({
    List<StudyCard>? cards,
    int? currentIndex,
    bool? isFlipped,
    bool? isComplete,
    int? totalCards,
    int? reviewedCount,
    int? forgotCount,
    int? vagueCount,
    int? rememberCount,
    DateTime? startedAt,
  }) {
    return ReviewSession(
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      isComplete: isComplete ?? this.isComplete,
      totalCards: totalCards ?? this.totalCards,
      reviewedCount: reviewedCount ?? this.reviewedCount,
      forgotCount: forgotCount ?? this.forgotCount,
      vagueCount: vagueCount ?? this.vagueCount,
      rememberCount: rememberCount ?? this.rememberCount,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}

/// 复习会话 Notifier
final reviewSessionProvider =
    StateNotifierProvider<ReviewSessionNotifier, ReviewSession?>((ref) {
  return ReviewSessionNotifier(ref);
});

class ReviewSessionNotifier extends StateNotifier<ReviewSession?> {
  final Ref _ref;

  ReviewSessionNotifier(this._ref) : super(null);

  /// 开始复习会话
  void startSession(List<StudyCard> cards) {
    if (cards.isEmpty) return;

    // 打乱顺序
    final shuffled = List<StudyCard>.from(cards)..shuffle();

    state = ReviewSession(
      cards: shuffled,
      totalCards: shuffled.length,
      startedAt: DateTime.now(),
    );
  }

  /// 翻面
  void flipCard() {
    if (state == null || state!.isComplete) return;
    state = state!.copyWith(isFlipped: true);
  }

  /// 提交评级并进入下一张
  Future<void> rateCard(int rating) async {
    if (state == null || state!.currentCard == null) return;

    final session = state!;
    final card = session.currentCard!;

    // 计算新的复习数据
    final scheduler = _ref.read(reviewSchedulerProvider);
    final result = scheduler.schedule(card, rating);

    // 更新卡片复习数据
    final updatedCard = card.copyWith(
      reviewData: ReviewData(
        interval: result.newInterval,
        repetitions: result.newRepetitions,
        easeFactor: result.newEaseFactor,
        nextReviewDate: result.nextReviewDate,
        lastReviewDate: DateTime.now(),
      ),
      // 如果忘了，标记为易错
      isDifficult: rating == 1 ? true : card.isDifficult,
      updatedAt: DateTime.now(),
    );

    await _ref.read(cardRepositoryProvider).updateCard(updatedCard);

    // 保存复习记录
    final log = ReviewLog(
      id: _uuid.v4(),
      cardId: card.id,
      deckId: card.deckId,
      rating: rating,
      reviewedAt: DateTime.now(),
    );
    await _ref.read(reviewRepositoryProvider).saveReviewLog(log);

    // 更新每日记录
    final todayRecord = await _ref
        .read(reviewRepositoryProvider)
        .getTodayStudyRecord();
    final isNewCard = card.reviewData.isNew;
    await _ref.read(reviewRepositoryProvider).saveDailyRecord(
          DailyStudyRecord(
            date: AppDateUtils.todayString(),
            newCardsStudied:
                todayRecord.newCardsStudied + (isNewCard ? 1 : 0),
            cardsReviewed:
                todayRecord.cardsReviewed + (isNewCard ? 0 : 1),
          ),
        );

    // 更新会话状态
    final newReviewed = session.reviewedCount + 1;
    final nextIndex = session.currentIndex + 1;
    final isComplete = nextIndex >= session.cards.length;

    state = session.copyWith(
      currentIndex: nextIndex,
      isFlipped: false,
      isComplete: isComplete,
      reviewedCount: newReviewed,
      forgotCount: session.forgotCount + (rating == 1 ? 1 : 0),
      vagueCount: session.vagueCount + (rating == 2 ? 1 : 0),
      rememberCount: session.rememberCount + (rating == 3 ? 1 : 0),
    );
  }

  /// 结束会话
  void endSession() {
    state = null;
  }
}
