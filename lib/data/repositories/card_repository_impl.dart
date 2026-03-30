import 'package:mocard/domain/entities/card.dart';
import 'package:mocard/domain/repositories/card_repository.dart';
import 'package:mocard/data/datasources/local/card_local_datasource.dart';

/// 卡片仓库实现（本地优先）
class CardRepositoryImpl implements CardRepository {
  final CardLocalDatasource _localDatasource;

  CardRepositoryImpl(this._localDatasource);

  @override
  Future<List<StudyCard>> getCardsByDeck(String deckId) =>
      _localDatasource.getByDeck(deckId);

  @override
  Future<StudyCard?> getCardById(String id) => _localDatasource.getById(id);

  @override
  Future<List<StudyCard>> getFilteredCards(CardFilter filter) =>
      _localDatasource.getFiltered(filter);

  @override
  Future<List<StudyCard>> getDueCards({String? deckId, int? limit}) =>
      _localDatasource.getDueCards(deckId: deckId, limit: limit);

  @override
  Future<List<StudyCard>> getNewCards({String? deckId, int? limit}) =>
      _localDatasource.getNewCards(deckId: deckId, limit: limit);

  @override
  Future<List<StudyCard>> searchCards(String query) =>
      _localDatasource.search(query);

  @override
  Future<StudyCard> createCard(StudyCard card) =>
      _localDatasource.create(card);

  @override
  Future<StudyCard> updateCard(StudyCard card) =>
      _localDatasource.update(card);

  @override
  Future<void> deleteCard(String id) => _localDatasource.delete(id);

  @override
  Future<void> deleteCardsByDeck(String deckId) =>
      _localDatasource.deleteByDeck(deckId);

  @override
  Future<int> getCardCountByDeck(String deckId) =>
      _localDatasource.getCountByDeck(deckId);

  @override
  Future<int> getTotalCardCount() => _localDatasource.getTotalCount();

  @override
  Future<List<String>> getAllTags() => _localDatasource.getAllTags();

  @override
  Future<List<String>> getAllImagePaths() =>
      _localDatasource.getAllImagePaths();
}
