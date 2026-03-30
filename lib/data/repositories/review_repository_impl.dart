import 'package:mocard/core/utils/date_utils.dart';
import 'package:mocard/domain/entities/review_log.dart';
import 'package:mocard/domain/entities/study_stats.dart';
import 'package:mocard/domain/repositories/review_repository.dart';
import 'package:mocard/domain/repositories/card_repository.dart';
import 'package:mocard/domain/repositories/deck_repository.dart';
import 'package:mocard/data/datasources/local/review_local_datasource.dart';

/// 复习记录仓库实现
class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewLocalDatasource _localDatasource;
  final CardRepository _cardRepository;
  final DeckRepository _deckRepository;

  ReviewRepositoryImpl(
    this._localDatasource,
    this._cardRepository,
    this._deckRepository,
  );

  @override
  Future<void> saveReviewLog(ReviewLog log) => _localDatasource.saveLog(log);

  @override
  Future<List<ReviewLog>> getReviewLogsByCard(String cardId) =>
      _localDatasource.getLogsByCard(cardId);

  @override
  Future<List<ReviewLog>> getReviewLogsByDate(String dateStr) =>
      _localDatasource.getLogsByDate(dateStr);

  @override
  Future<DailyStudyRecord> getTodayStudyRecord() =>
      _localDatasource.getTodayRecord();

  @override
  Future<void> saveDailyRecord(DailyStudyRecord record) =>
      _localDatasource.saveDailyRecord(record);

  @override
  Future<List<DailyStudyRecord>> getRecentDailyRecords(int days) =>
      _localDatasource.getRecentRecords(days);

  @override
  Future<List<String>> getAllStudyDates() =>
      _localDatasource.getAllStudyDates();

  @override
  Future<StudyStatsOverview> getStatsOverview() async {
    final todayRecord = await getTodayStudyRecord();
    final recentRecords = await getRecentDailyRecords(7);
    final allDates = await getAllStudyDates();
    final streak = AppDateUtils.calculateStreak(allDates);
    final totalCards = await _cardRepository.getTotalCardCount();
    final decks = await _deckRepository.getAllDecks();

    return StudyStatsOverview(
      todayNewCards: todayRecord.newCardsStudied,
      todayReviewedCards: todayRecord.cardsReviewed,
      totalCards: totalCards,
      totalDecks: decks.length,
      streakDays: streak,
      recentRecords: recentRecords,
    );
  }
}
