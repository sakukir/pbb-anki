import 'package:mocard/domain/entities/app_settings.dart';

/// 设置仓库接口
abstract class SettingsRepository {
  /// 获取当前设置
  Future<AppSettings> getSettings();

  /// 保存设置
  Future<void> saveSettings(AppSettings settings);
}
