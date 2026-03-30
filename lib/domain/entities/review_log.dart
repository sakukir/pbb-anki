/// 复习记录实体
class ReviewLog {
  final String id;
  final String cardId;
  final String deckId;
  final int rating; // 1=忘了, 2=模糊, 3=记得
  final DateTime reviewedAt;
  final int? responseTimeMs; // 响应时间，毫秒

  const ReviewLog({
    required this.id,
    required this.cardId,
    required this.deckId,
    required this.rating,
    required this.reviewedAt,
    this.responseTimeMs,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewLog &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
