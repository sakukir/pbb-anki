import 'package:isar/isar.dart';
import 'package:mocard/core/utils/date_utils.dart';
import 'package:mocard/domain/entities/review_log.dart';
import 'package:mocard/domain/entities/study_stats.dart';
import 'models/review_log_model.dart';
import 'models/daily_record_model.dart';

/// 复习记录本地数据源
class ReviewLocalDatasource {
  final Isar _isar;

  ReviewLocalDatasource(this._isar);

  Future<void> saveLog(ReviewLog log) async {
    final model = ReviewLogModel.fromEntity(log);
    await _isar.writeTxn(() async {
      await _isar.reviewLogModels.put(model);
    });
  }

  Future<List<ReviewLog>> getLogsByCard(String cardId) async {
    final models = await _isar.reviewLogModels
        .where()
        .cardIdEqualTo(cardId)
        .sortByReviewedAtDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  Future<List<ReviewLog>> getLogsByDate(String dateStr) async {
    final date = AppDateUtils.fromDateString(dateStr);
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final models = await _isar.reviewLogModels
        .where()
        .reviewedAtBetween(start, end)
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  Future<DailyStudyRecord> getTodayRecord() async {
    final today = AppDateUtils.todayString();
    final model = await _isar.dailyRecordModels
        .where()
        .dateEqualTo(today)
        .findFirst();

    if (model != null) {
      return model.toEntity();
    }
    return DailyStudyRecord(date: today);
  }

  Future<void> saveDailyRecord(DailyStudyRecord record) async {
    final existing = await _isar.dailyRecordModels
        .where()
        .dateEqualTo(record.date)
        .findFirst();

    final model = DailyRecordModel.fromEntity(record);
    if (existing != null) {
      model.isarId = existing.isarId;
    }

    await _isar.writeTxn(() async {
      await _isar.dailyRecordModels.put(model);
    });
  }

  Future<List<DailyStudyRecord>> getRecentRecords(int days) async {
    final now = DateTime.now();
    final records = <DailyStudyRecord>[];

    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final dateStr = AppDateUtils.toDateString(date);
      final model = await _isar.dailyRecordModels
          .where()
          .dateEqualTo(dateStr)
          .findFirst();

      records.add(model?.toEntity() ?? DailyStudyRecord(date: dateStr));
    }

    return records.reversed.toList();
  }

  Future<List<String>> getAllStudyDates() async {
    final models = await _isar.dailyRecordModels
        .where()
        .findAll();
    return models
        .where((m) => m.newCardsStudied > 0 || m.cardsReviewed > 0)
        .map((m) => m.date)
        .toList()
      ..sort();
  }
}
