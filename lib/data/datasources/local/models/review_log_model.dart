import 'package:isar/isar.dart';
import 'package:mocard/domain/entities/review_log.dart';

part 'review_log_model.g.dart';

@collection
class ReviewLogModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  @Index()
  late String cardId;

  @Index()
  late String deckId;

  late int rating;

  @Index()
  late DateTime reviewedAt;

  int? responseTimeMs;

  ReviewLogModel();

  factory ReviewLogModel.fromEntity(ReviewLog log) {
    return ReviewLogModel()
      ..id = log.id
      ..cardId = log.cardId
      ..deckId = log.deckId
      ..rating = log.rating
      ..reviewedAt = log.reviewedAt
      ..responseTimeMs = log.responseTimeMs;
  }

  ReviewLog toEntity() {
    return ReviewLog(
      id: id,
      cardId: cardId,
      deckId: deckId,
      rating: rating,
      reviewedAt: reviewedAt,
      responseTimeMs: responseTimeMs,
    );
  }
}
