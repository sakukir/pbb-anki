import 'package:mocard/domain/entities/app_settings.dart';
import 'package:mocard/domain/repositories/settings_repository.dart';
import 'package:mocard/data/datasources/local/settings_local_datasource.dart';

/// 设置仓库实现
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDatasource _localDatasource;

  SettingsRepositoryImpl(this._localDatasource);

  @override
  Future<AppSettings> getSettings() => _localDatasource.getSettings();

  @override
  Future<void> saveSettings(AppSettings settings) =>
      _localDatasource.saveSettings(settings);
}
