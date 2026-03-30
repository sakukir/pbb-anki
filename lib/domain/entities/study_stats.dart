/// 每日学习记录
class DailyStudyRecord {
  final String date; // yyyy-MM-dd
  final int newCardsStudied;
  final int cardsReviewed;

  const DailyStudyRecord({
    required this.date,
    this.newCardsStudied = 0,
    this.cardsReviewed = 0,
  });

  int get totalStudied => newCardsStudied + cardsReviewed;

  DailyStudyRecord copyWith({
    String? date,
    int? newCardsStudied,
    int? cardsReviewed,
  }) {
    return DailyStudyRecord(
      date: date ?? this.date,
      newCardsStudied: newCardsStudied ?? this.newCardsStudied,
      cardsReviewed: cardsReviewed ?? this.cardsReviewed,
    );
  }
}

/// 学习统计汇总
class StudyStatsOverview {
  final int todayNewCards;
  final int todayReviewedCards;
  final int totalCards;
  final int totalDecks;
  final int streakDays;
  final List<DailyStudyRecord> recentRecords; // 最近 7 天

  const StudyStatsOverview({
    this.todayNewCards = 0,
    this.todayReviewedCards = 0,
    this.totalCards = 0,
    this.totalDecks = 0,
    this.streakDays = 0,
    this.recentRecords = const [],
  });
}

/// 卡组进度
class DeckProgress {
  final String deckId;
  final String deckName;
  final int totalCards;
  final int masteredCards; // repetitions >= 3
  final int learningCards; // 0 < repetitions < 3
  final int newCards; // repetitions == 0
  final int dueCards; // 今日到期

  const DeckProgress({
    required this.deckId,
    required this.deckName,
    this.totalCards = 0,
    this.masteredCards = 0,
    this.learningCards = 0,
    this.newCards = 0,
    this.dueCards = 0,
  });

  double get progress {
    if (totalCards == 0) return 0;
    return masteredCards / totalCards;
  }
}
