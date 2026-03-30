import 'package:isar/isar.dart';
import 'package:mocard/domain/entities/deck.dart';
import 'models/deck_model.dart';

/// 卡组本地数据源
class DeckLocalDatasource {
  final Isar _isar;

  DeckLocalDatasource(this._isar);

  Future<List<Deck>> getAll() async {
    final models = await _isar.deckModels
        .where()
        .sortByUpdatedAtDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  Future<Deck?> getById(String id) async {
    final model = await _isar.deckModels
        .where()
        .idEqualTo(id)
        .findFirst();
    return model?.toEntity();
  }

  Future<List<Deck>> search(String query) async {
    final lowerQuery = query.toLowerCase();
    final models = await _isar.deckModels
        .where()
        .findAll();
    return models
        .where((m) =>
            m.name.toLowerCase().contains(lowerQuery) ||
            (m.description?.toLowerCase().contains(lowerQuery) ?? false))
        .map((m) => m.toEntity())
        .toList();
  }

  Future<List<Deck>> getByCategory(String category) async {
    final models = await _isar.deckModels
        .where()
        .categoryEqualTo(category)
        .sortByUpdatedAtDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  Future<Deck> create(Deck deck) async {
    final model = DeckModel.fromEntity(deck);
    await _isar.writeTxn(() async {
      await _isar.deckModels.put(model);
    });
    return deck;
  }

  Future<Deck> update(Deck deck) async {
    final existing = await _isar.deckModels
        .where()
        .idEqualTo(deck.id)
        .findFirst();
    if (existing == null) {
      throw Exception('Deck not found: ${deck.id}');
    }
    final model = DeckModel.fromEntity(deck)..isarId = existing.isarId;
    await _isar.writeTxn(() async {
      await _isar.deckModels.put(model);
    });
    return deck;
  }

  Future<void> delete(String id) async {
    await _isar.writeTxn(() async {
      await _isar.deckModels.where().idEqualTo(id).deleteAll();
    });
  }

  Future<void> updateCardCount(String deckId, int count) async {
    final model = await _isar.deckModels
        .where()
        .idEqualTo(deckId)
        .findFirst();
    if (model != null) {
      model.cardCount = count;
      model.updatedAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.deckModels.put(model);
      });
    }
  }
}
