/// 全局常量
class AppConstants {
  AppConstants._();

  // ── 应用信息 ──
  static const String appName = '默记';
  static const String appVersion = '1.0.0';

  // ── 默认设置 ──
  static const int defaultDailyNewCardLimit = 20;
  static const int defaultDailyReviewLimit = 100;

  // ── 卡组分类 ──
  static const List<String> deckCategories = [
    '英语',
    '政治',
    '数学',
    '专业课',
    '其他',
  ];

  // ── 复习评级 ──
  static const int ratingForgot = 1;
  static const int ratingVague = 2;
  static const int ratingRemember = 3;

  static const Map<int, String> ratingLabels = {
    ratingForgot: '忘了',
    ratingVague: '模糊',
    ratingRemember: '记得',
  };

  // ── SM-2 算法参数 ──
  static const double sm2DefaultEaseFactor = 2.5;
  static const double sm2MinEaseFactor = 1.3;
  static const int sm2FirstInterval = 1; // 天
  static const int sm2SecondInterval = 6; // 天

  // ── 图片 ──
  static const String imageDirectoryName = 'mocard_images';
  static const int imageMaxWidth = 1920;
  static const int imageMaxHeight = 1920;
  static const int imageQuality = 85;

  // ── 数据库 ──
  static const String databaseName = 'mocard_db';
}
