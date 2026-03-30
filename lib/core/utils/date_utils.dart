import 'package:intl/intl.dart';

/// 日期工具类
class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _displayFormat = DateFormat('MM月dd日');
  static final DateFormat _fullDisplayFormat = DateFormat('yyyy年MM月dd日');
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  /// 获取今天的日期字符串 yyyy-MM-dd
  static String todayString() => _dateFormat.format(DateTime.now());

  /// DateTime 转日期字符串
  static String toDateString(DateTime date) => _dateFormat.format(date);

  /// 日期字符串转 DateTime
  static DateTime fromDateString(String dateStr) => _dateFormat.parse(dateStr);

  /// 显示格式：MM月dd日
  static String toDisplayDate(DateTime date) => _displayFormat.format(date);

  /// 完整显示格式：yyyy年MM月dd日
  static String toFullDisplayDate(DateTime date) =>
      _fullDisplayFormat.format(date);

  /// 时间格式：HH:mm
  static String toTimeString(DateTime date) => _timeFormat.format(date);

  /// 友好的相对时间
  static String toRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
    if (diff.inHours < 24) return '${diff.inHours}小时前';
    if (diff.inDays == 1) return '昨天';
    if (diff.inDays == 2) return '前天';
    if (diff.inDays < 7) return '${diff.inDays}天前';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}周前';

    return toDisplayDate(date);
  }

  /// 判断两个日期是否是同一天
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// 今天的开始时间
  static DateTime todayStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// 今天的结束时间
  static DateTime todayEnd() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  /// 计算连续天数（从日期字符串列表）
  static int calculateStreak(List<String> sortedDates) {
    if (sortedDates.isEmpty) return 0;

    final today = todayString();
    final yesterday = toDateString(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    // 必须包含今天或昨天才算有效连续
    if (!sortedDates.contains(today) && !sortedDates.contains(yesterday)) {
      return 0;
    }

    int streak = 0;
    DateTime checkDate = DateTime.now();

    // 如果今天没有学习记录，从昨天开始算
    if (!sortedDates.contains(today)) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    while (sortedDates.contains(toDateString(checkDate))) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }
}
