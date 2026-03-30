import 'package:mocard/core/constants/app_constants.dart';

/// 应用设置实体
class AppSettings {
  final int dailyNewCardLimit;
  final int dailyReviewLimit;
  final String themeMode; // 'light', 'dark', 'system'
  final String reviewFlipMode; // 'tap', 'button'

  const AppSettings({
    this.dailyNewCardLimit = AppConstants.defaultDailyNewCardLimit,
    this.dailyReviewLimit = AppConstants.defaultDailyReviewLimit,
    this.themeMode = 'light',
    this.reviewFlipMode = 'tap',
  });

  AppSettings copyWith({
    int? dailyNewCardLimit,
    int? dailyReviewLimit,
    String? themeMode,
    String? reviewFlipMode,
  }) {
    return AppSettings(
      dailyNewCardLimit: dailyNewCardLimit ?? this.dailyNewCardLimit,
      dailyReviewLimit: dailyReviewLimit ?? this.dailyReviewLimit,
      themeMode: themeMode ?? this.themeMode,
      reviewFlipMode: reviewFlipMode ?? this.reviewFlipMode,
    );
  }
}
