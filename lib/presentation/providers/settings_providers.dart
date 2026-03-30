import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocard/domain/entities/app_settings.dart';
import 'database_providers.dart';

/// 应用设置
final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    return await ref.read(settingsRepositoryProvider).getSettings();
  }

  Future<void> updateSettings(AppSettings settings) async {
    await ref.read(settingsRepositoryProvider).saveSettings(settings);
    ref.invalidateSelf();
  }

  Future<void> setDailyNewCardLimit(int limit) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(dailyNewCardLimit: limit));
  }

  Future<void> setDailyReviewLimit(int limit) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(dailyReviewLimit: limit));
  }

  Future<void> setReviewFlipMode(String mode) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(reviewFlipMode: mode));
  }
}
