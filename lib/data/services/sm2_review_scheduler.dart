import 'package:mocard/core/constants/app_constants.dart';
import 'package:mocard/domain/entities/card.dart';
import 'package:mocard/domain/services/review_scheduler.dart';

/// SM-2 间隔复习算法实现
///
/// 三级评分映射：
/// - 1（忘了）→ SM-2 quality 1：重置，明天重来
/// - 2（模糊）→ SM-2 quality 3：短间隔复习
/// - 3（记得）→ SM-2 quality 5：正常推进
///
/// 未来可替换为 FSRS 等更先进的算法
class Sm2ReviewScheduler implements ReviewScheduler {
  @override
  String get algorithmName => 'SM-2 (Simplified)';

  @override
  ScheduleResult schedule(StudyCard card, int rating) {
    final data = card.reviewData;

    int newInterval;
    int newRepetitions;
    double newEaseFactor = data.easeFactor;

    if (rating == AppConstants.ratingForgot) {
      // ── 忘了：重置进度 ──
      newRepetitions = 0;
      newInterval = AppConstants.sm2FirstInterval;
      // 降低难度因子
      newEaseFactor = (newEaseFactor - 0.3).clamp(
        AppConstants.sm2MinEaseFactor,
        double.infinity,
      );
    } else if (rating == AppConstants.ratingVague) {
      // ── 模糊：不重置，但缩短间隔 ──
      newRepetitions = data.repetitions + 1;
      if (newRepetitions == 1) {
        newInterval = AppConstants.sm2FirstInterval;
      } else if (newRepetitions == 2) {
        newInterval = 3; // 比正常的 6 天短
      } else {
        // 间隔增长，但用较低倍率
        newInterval = (data.interval * (newEaseFactor * 0.7)).round();
        newInterval = newInterval.clamp(1, 365);
      }
      // 微降难度因子
      newEaseFactor = (newEaseFactor - 0.1).clamp(
        AppConstants.sm2MinEaseFactor,
        double.infinity,
      );
    } else {
      // ── 记得：正常推进 ──
      newRepetitions = data.repetitions + 1;
      if (newRepetitions == 1) {
        newInterval = AppConstants.sm2FirstInterval;
      } else if (newRepetitions == 2) {
        newInterval = AppConstants.sm2SecondInterval;
      } else {
        newInterval = (data.interval * newEaseFactor).round();
        newInterval = newInterval.clamp(1, 365);
      }
      // 提升难度因子
      newEaseFactor = newEaseFactor + 0.1;
    }

    final now = DateTime.now();
    final nextDate = DateTime(
      now.year,
      now.month,
      now.day + newInterval,
    );

    return ScheduleResult(
      newInterval: newInterval,
      newRepetitions: newRepetitions,
      newEaseFactor: newEaseFactor,
      nextReviewDate: nextDate,
    );
  }
}
