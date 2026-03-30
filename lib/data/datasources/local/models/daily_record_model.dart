import 'package:isar/isar.dart';
import 'package:mocard/domain/entities/study_stats.dart';

part 'daily_record_model.g.dart';

@collection
class DailyRecordModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String date; // yyyy-MM-dd

  late int newCardsStudied;
  late int cardsReviewed;

  DailyRecordModel();

  factory DailyRecordModel.fromEntity(DailyStudyRecord record) {
    return DailyRecordModel()
      ..date = record.date
      ..newCardsStudied = record.newCardsStudied
      ..cardsReviewed = record.cardsReviewed;
  }

  DailyStudyRecord toEntity() {
    return DailyStudyRecord(
      date: date,
      newCardsStudied: newCardsStudied,
      cardsReviewed: cardsReviewed,
    );
  }
}
