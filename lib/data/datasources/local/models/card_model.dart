import 'package:isar/isar.dart';
import 'package:mocard/domain/entities/card.dart';

part 'card_model.g.dart';

@collection
class CardModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  @Index()
  late String deckId;

  String? frontText;
  String? frontImagePath;
  String? backText;
  String? backImagePath;
  String? note;

  @Index(type: IndexType.value)
  late List<String> tags;

  late bool isFavorite;
  late bool isImportant;
  late bool isDifficult;

  // SM-2 复习数据
  late int reviewInterval;
  late int reviewRepetitions;
  late double reviewEaseFactor;
  DateTime? nextReviewDate;
  DateTime? lastReviewDate;

  late DateTime createdAt;
  late DateTime updatedAt;

  CardModel();

  /// 从领域实体转换
  factory CardModel.fromEntity(StudyCard card) {
    return CardModel()
      ..id = card.id
      ..deckId = card.deckId
      ..frontText = card.frontText
      ..frontImagePath = card.frontImagePath
      ..backText = card.backText
      ..backImagePath = card.backImagePath
      ..note = card.note
      ..tags = card.tags.toList()
      ..isFavorite = card.isFavorite
      ..isImportant = card.isImportant
      ..isDifficult = card.isDifficult
      ..reviewInterval = card.reviewData.interval
      ..reviewRepetitions = card.reviewData.repetitions
      ..reviewEaseFactor = card.reviewData.easeFactor
      ..nextReviewDate = card.reviewData.nextReviewDate
      ..lastReviewDate = card.reviewData.lastReviewDate
      ..createdAt = card.createdAt
      ..updatedAt = card.updatedAt;
  }

  /// 转换为领域实体
  StudyCard toEntity() {
    return StudyCard(
      id: id,
      deckId: deckId,
      frontText: frontText,
      frontImagePath: frontImagePath,
      backText: backText,
      backImagePath: backImagePath,
      note: note,
      tags: tags,
      isFavorite: isFavorite,
      isImportant: isImportant,
      isDifficult: isDifficult,
      reviewData: ReviewData(
        interval: reviewInterval,
        repetitions: reviewRepetitions,
        easeFactor: reviewEaseFactor,
        nextReviewDate: nextReviewDate,
        lastReviewDate: lastReviewDate,
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
