import 'package:mocard/domain/entities/card.dart';

/// 复习调度结果
class ScheduleResult {
  final int newInterval;
  final int newRepetitions;
  final double newEaseFactor;
  final DateTime nextReviewDate;

  const ScheduleResult({
    required this.newInterval,
    required this.newRepetitions,
    required this.newEaseFactor,
    required this.nextReviewDate,
  });
}

/// 复习调度服务接口
/// 当前实现：简化 SM-2 算法
/// 未来实现：FSRS 等更先进的算法
abstract class ReviewScheduler {
  /// 根据评级计算下次复习时间
  /// [card] 当前卡片
  /// [rating] 用户评级 (1=忘了, 2=模糊, 3=记得)
  ScheduleResult schedule(StudyCard card, int rating);

  /// 获取算法名称（用于日志/调试）
  String get algorithmName;
}
