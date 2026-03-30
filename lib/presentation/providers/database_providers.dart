import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mocard/data/datasources/local/database.dart';
import 'package:mocard/data/datasources/local/deck_local_datasource.dart';
import 'package:mocard/data/datasources/local/card_local_datasource.dart';
import 'package:mocard/data/datasources/local/review_local_datasource.dart';
import 'package:mocard/data/datasources/local/settings_local_datasource.dart';
import 'package:mocard/data/repositories/deck_repository_impl.dart';
import 'package:mocard/data/repositories/card_repository_impl.dart';
import 'package:mocard/data/repositories/review_repository_impl.dart';
import 'package:mocard/data/repositories/settings_repository_impl.dart';
import 'package:mocard/data/services/local_media_storage_service.dart';
import 'package:mocard/data/services/sm2_review_scheduler.dart';
import 'package:mocard/domain/repositories/deck_repository.dart';
import 'package:mocard/domain/repositories/card_repository.dart';
import 'package:mocard/domain/repositories/review_repository.dart';
import 'package:mocard/domain/repositories/settings_repository.dart';
import 'package:mocard/domain/services/media_storage_service.dart';
import 'package:mocard/domain/services/review_scheduler.dart';

/// Isar 数据库实例
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Must be overridden with actual Isar instance');
});

// ── 数据源 ──

final deckLocalDatasourceProvider = Provider<DeckLocalDatasource>((ref) {
  return DeckLocalDatasource(ref.watch(isarProvider));
});

final cardLocalDatasourceProvider = Provider<CardLocalDatasource>((ref) {
  return CardLocalDatasource(ref.watch(isarProvider));
});

final reviewLocalDatasourceProvider = Provider<ReviewLocalDatasource>((ref) {
  return ReviewLocalDatasource(ref.watch(isarProvider));
});

final settingsLocalDatasourceProvider =
    Provider<SettingsLocalDatasource>((ref) {
  return SettingsLocalDatasource(ref.watch(isarProvider));
});

// ── 仓库 ──

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  return DeckRepositoryImpl(ref.watch(deckLocalDatasourceProvider));
});

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  return CardRepositoryImpl(ref.watch(cardLocalDatasourceProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(
    ref.watch(reviewLocalDatasourceProvider),
    ref.watch(cardRepositoryProvider),
    ref.watch(deckRepositoryProvider),
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(settingsLocalDatasourceProvider));
});

// ── 服务 ──

final mediaStorageServiceProvider = Provider<MediaStorageService>((ref) {
  return LocalMediaStorageService();
});

final reviewSchedulerProvider = Provider<ReviewScheduler>((ref) {
  return Sm2ReviewScheduler();
});

/// 初始化数据库并返回 Isar 实例
Future<Isar> initializeDatabase() async {
  return await LocalDatabase.getInstance();
}
