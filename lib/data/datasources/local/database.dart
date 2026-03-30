import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mocard/core/constants/app_constants.dart';
import 'models/deck_model.dart';
import 'models/card_model.dart';
import 'models/review_log_model.dart';
import 'models/settings_model.dart';
import 'models/daily_record_model.dart';

/// 本地数据库管理
class LocalDatabase {
  static Isar? _instance;

  static Future<Isar> getInstance() async {
    if (_instance != null && _instance!.isOpen) {
      return _instance!;
    }

    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [
        DeckModelSchema,
        CardModelSchema,
        ReviewLogModelSchema,
        SettingsModelSchema,
        DailyRecordModelSchema,
      ],
      directory: dir.path,
      name: AppConstants.databaseName,
    );

    return _instance!;
  }

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}
