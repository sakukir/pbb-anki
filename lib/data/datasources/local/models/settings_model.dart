import 'package:isar/isar.dart';
import 'package:mocard/domain/entities/app_settings.dart';

part 'settings_model.g.dart';

@collection
class SettingsModel {
  Id isarId = 1; // 单例，只有一条记录

  late int dailyNewCardLimit;
  late int dailyReviewLimit;
  late String themeMode;
  late String reviewFlipMode;

  SettingsModel();

  factory SettingsModel.fromEntity(AppSettings settings) {
    return SettingsModel()
      ..dailyNewCardLimit = settings.dailyNewCardLimit
      ..dailyReviewLimit = settings.dailyReviewLimit
      ..themeMode = settings.themeMode
      ..reviewFlipMode = settings.reviewFlipMode;
  }

  AppSettings toEntity() {
    return AppSettings(
      dailyNewCardLimit: dailyNewCardLimit,
      dailyReviewLimit: dailyReviewLimit,
      themeMode: themeMode,
      reviewFlipMode: reviewFlipMode,
    );
  }
}
