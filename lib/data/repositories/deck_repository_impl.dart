import 'package:mocard/domain/entities/deck.dart';
import 'package:mocard/domain/repositories/deck_repository.dart';
import 'package:mocard/data/datasources/local/deck_local_datasource.dart';

/// 卡组仓库实现（本地优先）
class DeckRepositoryImpl implements DeckRepository {
  final DeckLocalDatasource _localDatasource;

  DeckRepositoryImpl(this._localDatasource);

  @override
  Future<List<Deck>> getAllDecks() => _localDatasource.getAll();

  @override
  Future<Deck?> getDeckById(String id) => _localDatasource.getById(id);

  @override
  Future<List<Deck>> searchDecks(String query) =>
      _localDatasource.search(query);

  @override
  Future<List<Deck>> getDecksByCategory(String category) =>
      _localDatasource.getByCategory(category);

  @override
  Future<Deck> createDeck(Deck deck) => _localDatasource.create(deck);

  @override
  Future<Deck> updateDeck(Deck deck) => _localDatasource.update(deck);

  @override
  Future<void> deleteDeck(String id) => _localDatasource.delete(id);

  @override
  Future<void> updateCardCount(String deckId, int count) =>
      _localDatasource.updateCardCount(deckId, count);
}
