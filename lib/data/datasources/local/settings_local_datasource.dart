import 'package:isar/isar.dart';
import 'package:mocard/domain/entities/app_settings.dart';
import 'models/settings_model.dart';

/// 设置本地数据源
class SettingsLocalDatasource {
  final Isar _isar;

  SettingsLocalDatasource(this._isar);

  Future<AppSettings> getSettings() async {
    final model = await _isar.settingsModels.get(1);
    if (model != null) {
      return model.toEntity();
    }
    return const AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    final model = SettingsModel.fromEntity(settings);
    await _isar.writeTxn(() async {
      await _isar.settingsModels.put(model);
    });
  }
}
