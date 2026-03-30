/// 复习数据（嵌入在卡片中）
class ReviewData {
  final int interval; // 间隔天数
  final int repetitions; // 连续正确次数
  final double easeFactor; // 难度因子
  final DateTime? nextReviewDate; // 下次复习日期
  final DateTime? lastReviewDate; // 最后复习日期

  const ReviewData({
    this.interval = 0,
    this.repetitions = 0,
    this.easeFactor = 2.5,
    this.nextReviewDate,
    this.lastReviewDate,
  });

  ReviewData copyWith({
    int? interval,
    int? repetitions,
    double? easeFactor,
    DateTime? nextReviewDate,
    DateTime? lastReviewDate,
  }) {
    return ReviewData(
      interval: interval ?? this.interval,
      repetitions: repetitions ?? this.repetitions,
      easeFactor: easeFactor ?? this.easeFactor,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
    );
  }

  /// 是否是新卡（从未复习过）
  bool get isNew => repetitions == 0 && lastReviewDate == null;

  /// 是否今天到期需要复习
  bool get isDueToday {
    if (nextReviewDate == null) return isNew;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(
      nextReviewDate!.year,
      nextReviewDate!.month,
      nextReviewDate!.day,
    );
    return !due.isAfter(today);
  }
}

/// 卡片实体
class StudyCard {
  final String id;
  final String deckId;
  final String? frontText;
  final String? frontImagePath; // 相对路径
  final String? backText;
  final String? backImagePath; // 相对路径
  final String? note;
  final List<String> tags;
  final bool isFavorite;
  final bool isImportant;
  final bool isDifficult;
  final ReviewData reviewData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StudyCard({
    required this.id,
    required this.deckId,
    this.frontText,
    this.frontImagePath,
    this.backText,
    this.backImagePath,
    this.note,
    this.tags = const [],
    this.isFavorite = false,
    this.isImportant = false,
    this.isDifficult = false,
    this.reviewData = const ReviewData(),
    required this.createdAt,
    required this.updatedAt,
  });

  /// 卡片是否有效（至少有题目内容）
  bool get isValid =>
      (frontText != null && frontText!.trim().isNotEmpty) ||
      frontImagePath != null;

  /// 是否有图片
  bool get hasFrontImage => frontImagePath != null;
  bool get hasBackImage => backImagePath != null;

  StudyCard copyWith({
    String? id,
    String? deckId,
    String? frontText,
    String? frontImagePath,
    bool clearFrontImage = false,
    String? backText,
    String? backImagePath,
    bool clearBackImage = false,
    String? note,
    List<String>? tags,
    bool? isFavorite,
    bool? isImportant,
    bool? isDifficult,
    ReviewData? reviewData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudyCard(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      frontText: frontText ?? this.frontText,
      frontImagePath:
          clearFrontImage ? null : (frontImagePath ?? this.frontImagePath),
      backText: backText ?? this.backText,
      backImagePath:
          clearBackImage ? null : (backImagePath ?? this.backImagePath),
      note: note ?? this.note,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      isImportant: isImportant ?? this.isImportant,
      isDifficult: isDifficult ?? this.isDifficult,
      reviewData: reviewData ?? this.reviewData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyCard && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
