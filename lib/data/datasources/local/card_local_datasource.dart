import 'package:isar/isar.dart';
import 'package:mocard/domain/entities/card.dart';
import 'package:mocard/domain/repositories/card_repository.dart';
import 'models/card_model.dart';

/// 卡片本地数据源
class CardLocalDatasource {
  final Isar _isar;

  CardLocalDatasource(this._isar);

  Future<List<StudyCard>> getByDeck(String deckId) async {
    final models = await _isar.cardModels
        .where()
        .deckIdEqualTo(deckId)
        .sortByCreatedAtDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  Future<StudyCard?> getById(String id) async {
    final model = await _isar.cardModels
        .where()
        .idEqualTo(id)
        .findFirst();
    return model?.toEntity();
  }

  Future<List<StudyCard>> getFiltered(CardFilter filter) async {
    // 基础查询
    List<CardModel> models;

    if (filter.deckId != null) {
      models = await _isar.cardModels
          .where()
          .deckIdEqualTo(filter.deckId!)
          .findAll();
    } else {
      models = await _isar.cardModels.where().findAll();
    }

    // 在内存中应用筛选
    var result = models.map((m) => m.toEntity()).toList();

    if (filter.keyword != null && filter.keyword!.isNotEmpty) {
      final kw = filter.keyword!.toLowerCase();
      result = result.where((c) {
        return (c.frontText?.toLowerCase().contains(kw) ?? false) ||
            (c.backText?.toLowerCase().contains(kw) ?? false) ||
            (c.note?.toLowerCase().contains(kw) ?? false) ||
            c.tags.any((t) => t.toLowerCase().contains(kw));
      }).toList();
    }

    if (filter.tag != null) {
      result = result.where((c) => c.tags.contains(filter.tag)).toList();
    }

    if (filter.isFavorite == true) {
      result = result.where((c) => c.isFavorite).toList();
    }

    if (filter.isImportant == true) {
      result = result.where((c) => c.isImportant).toList();
    }

    if (filter.isDifficult == true) {
      result = result.where((c) => c.isDifficult).toList();
    }

    if (filter.isDueToday == true) {
      result = result.where((c) => c.reviewData.isDueToday).toList();
    }

    if (filter.isNew == true) {
      result = result.where((c) => c.reviewData.isNew).toList();
    }

    return result;
  }

  Future<List<StudyCard>> getDueCards({String? deckId, int? limit}) async {
    List<CardModel> models;

    if (deckId != null) {
      models = await _isar.cardModels
          .where()
          .deckIdEqualTo(deckId)
          .findAll();
    } else {
      models = await _isar.cardModels.where().findAll();
    }

    var cards = models
        .map((m) => m.toEntity())
        .where((c) => !c.reviewData.isNew && c.reviewData.isDueToday)
        .toList();

    // 按 nextReviewDate 排序，越早到期的越先复习
    cards.sort((a, b) {
      final aDate = a.reviewData.nextReviewDate ?? DateTime(2000);
      final bDate = b.reviewData.nextReviewDate ?? DateTime(2000);
      return aDate.compareTo(bDate);
    });

    if (limit != null && cards.length > limit) {
      cards = cards.sublist(0, limit);
    }

    return cards;
  }

  Future<List<StudyCard>> getNewCards({String? deckId, int? limit}) async {
    List<CardModel> models;

    if (deckId != null) {
      models = await _isar.cardModels
          .where()
          .deckIdEqualTo(deckId)
          .findAll();
    } else {
      models = await _isar.cardModels.where().findAll();
    }

    var cards = models
        .map((m) => m.toEntity())
        .where((c) => c.reviewData.isNew)
        .toList();

    // 新卡按创建时间排序
    cards.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    if (limit != null && cards.length > limit) {
      cards = cards.sublist(0, limit);
    }

    return cards;
  }

  Future<List<StudyCard>> search(String query) async {
    final lowerQuery = query.toLowerCase();
    final models = await _isar.cardModels.where().findAll();
    return models
        .where((m) {
          final entity = m.toEntity();
          return (entity.frontText?.toLowerCase().contains(lowerQuery) ??
                  false) ||
              (entity.backText?.toLowerCase().contains(lowerQuery) ?? false) ||
              (entity.note?.toLowerCase().contains(lowerQuery) ?? false);
        })
        .map((m) => m.toEntity())
        .toList();
  }

  Future<StudyCard> create(StudyCard card) async {
    final model = CardModel.fromEntity(card);
    await _isar.writeTxn(() async {
      await _isar.cardModels.put(model);
    });
    return card;
  }

  Future<StudyCard> update(StudyCard card) async {
    final existing = await _isar.cardModels
        .where()
        .idEqualTo(card.id)
        .findFirst();
    if (existing == null) {
      throw Exception('Card not found: ${card.id}');
    }
    final model = CardModel.fromEntity(card)..isarId = existing.isarId;
    await _isar.writeTxn(() async {
      await _isar.cardModels.put(model);
    });
    return card;
  }

  Future<void> delete(String id) async {
    await _isar.writeTxn(() async {
      await _isar.cardModels.where().idEqualTo(id).deleteAll();
    });
  }

  Future<void> deleteByDeck(String deckId) async {
    await _isar.writeTxn(() async {
      await _isar.cardModels.where().deckIdEqualTo(deckId).deleteAll();
    });
  }

  Future<int> getCountByDeck(String deckId) async {
    return await _isar.cardModels
        .where()
        .deckIdEqualTo(deckId)
        .count();
  }

  Future<int> getTotalCount() async {
    return await _isar.cardModels.count();
  }

  Future<List<String>> getAllTags() async {
    final models = await _isar.cardModels.where().findAll();
    final tags = <String>{};
    for (final m in models) {
      tags.addAll(m.tags);
    }
    return tags.toList()..sort();
  }

  Future<List<String>> getAllImagePaths() async {
    final models = await _isar.cardModels.where().findAll();
    final paths = <String>[];
    for (final m in models) {
      if (m.frontImagePath != null) paths.add(m.frontImagePath!);
      if (m.backImagePath != null) paths.add(m.backImagePath!);
    }
    return paths;
  }
}
