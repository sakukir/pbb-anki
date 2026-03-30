import 'package:mocard/domain/entities/review_log.dart';
import 'package:mocard/domain/entities/study_stats.dart';

/// 复习记录仓库接口
abstract class ReviewRepository {
  /// 保存复习记录
  Future<void> saveReviewLog(ReviewLog log);

  /// 获取某张卡片的复习历史
  Future<List<ReviewLog>> getReviewLogsByCard(String cardId);

  /// 获取某天的复习记录
  Future<List<ReviewLog>> getReviewLogsByDate(String dateStr);

  /// 获取今日学习记录
  Future<DailyStudyRecord> getTodayStudyRecord();

  /// 保存/更新每日学习记录
  Future<void> saveDailyRecord(DailyStudyRecord record);

  /// 获取最近 N 天的学习记录
  Future<List<DailyStudyRecord>> getRecentDailyRecords(int days);

  /// 获取所有有学习记录的日期
  Future<List<String>> getAllStudyDates();

  /// 获取学习统计概览
  Future<StudyStatsOverview> getStatsOverview();
}
