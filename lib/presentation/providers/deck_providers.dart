import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:mocard/domain/entities/deck.dart';
import 'package:mocard/domain/repositories/deck_repository.dart';
import 'package:mocard/domain/repositories/card_repository.dart';
import 'package:mocard/domain/services/media_storage_service.dart';
import 'database_providers.dart';

const _uuid = Uuid();

/// 所有卡组列表
final deckListProvider =
    AsyncNotifierProvider<DeckListNotifier, List<Deck>>(DeckListNotifier.new);

class DeckListNotifier extends AsyncNotifier<List<Deck>> {
  DeckRepository get _repo => ref.read(deckRepositoryProvider);

  @override
  Future<List<Deck>> build() async {
    return await _repo.getAllDecks();
  }

  Future<Deck> createDeck({
    required String name,
    String? description,
    String? category,
  }) async {
    final now = DateTime.now();
    final deck = Deck(
      id: _uuid.v4(),
      name: name,
      description: description,
      category: category,
      cardCount: 0,
      createdAt: now,
      updatedAt: now,
    );
    await _repo.createDeck(deck);
    ref.invalidateSelf();
    return deck;
  }

  Future<void> updateDeck(Deck deck) async {
    await _repo.updateDeck(deck.copyWith(updatedAt: DateTime.now()));
    ref.invalidateSelf();
  }

  Future<void> deleteDeck(String id) async {
    // 删除卡组内所有卡片
    final cardRepo = ref.read(cardRepositoryProvider);
    final mediaService = ref.read(mediaStorageServiceProvider);

    // 先获取卡片中的图片路径
    final cards = await cardRepo.getCardsByDeck(id);
    for (final card in cards) {
      if (card.frontImagePath != null) {
        await mediaService.deleteImage(card.frontImagePath!);
      }
      if (card.backImagePath != null) {
        await mediaService.deleteImage(card.backImagePath!);
      }
    }

    await cardRepo.deleteCardsByDeck(id);
    await _repo.deleteDeck(id);
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// 单个卡组详情
final deckDetailProvider =
    FutureProvider.family<Deck?, String>((ref, deckId) async {
  final repo = ref.watch(deckRepositoryProvider);
  return await repo.getDeckById(deckId);
});

/// 卡组搜索
final deckSearchProvider =
    FutureProvider.family<List<Deck>, String>((ref, query) async {
  if (query.isEmpty) {
    return ref.watch(deckRepositoryProvider).getAllDecks();
  }
  return ref.watch(deckRepositoryProvider).searchDecks(query);
});
