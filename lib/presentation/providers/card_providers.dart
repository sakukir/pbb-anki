import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:mocard/domain/entities/card.dart';
import 'package:mocard/domain/repositories/card_repository.dart';
import 'package:mocard/domain/repositories/deck_repository.dart';
import 'package:mocard/domain/services/media_storage_service.dart';
import 'database_providers.dart';

const _uuid = Uuid();

/// 某卡组内的卡片列表
final cardListByDeckProvider =
    AsyncNotifierProvider.family<CardListByDeckNotifier, List<StudyCard>, String>(
  CardListByDeckNotifier.new,
);

class CardListByDeckNotifier
    extends FamilyAsyncNotifier<List<StudyCard>, String> {
  CardRepository get _repo => ref.read(cardRepositoryProvider);

  @override
  Future<List<StudyCard>> build(String arg) async {
    return await _repo.getCardsByDeck(arg);
  }

  Future<StudyCard> createCard({
    required String frontText,
    String? backText,
    File? frontImage,
    File? backImage,
    String? note,
    List<String> tags = const [],
    bool isFavorite = false,
    bool isImportant = false,
    bool isDifficult = false,
  }) async {
    final mediaService = ref.read(mediaStorageServiceProvider);

    String? frontImagePath;
    String? backImagePath;

    if (frontImage != null) {
      frontImagePath = await mediaService.saveImage(frontImage);
    }
    if (backImage != null) {
      backImagePath = await mediaService.saveImage(backImage);
    }

    final now = DateTime.now();
    final card = StudyCard(
      id: _uuid.v4(),
      deckId: arg,
      frontText: frontText.isNotEmpty ? frontText : null,
      frontImagePath: frontImagePath,
      backText: backText?.isNotEmpty == true ? backText : null,
      backImagePath: backImagePath,
      note: note?.isNotEmpty == true ? note : null,
      tags: tags,
      isFavorite: isFavorite,
      isImportant: isImportant,
      isDifficult: isDifficult,
      createdAt: now,
      updatedAt: now,
    );

    await _repo.createCard(card);

    // 更新卡组计数
    final count = await _repo.getCardCountByDeck(arg);
    await ref.read(deckRepositoryProvider).updateCardCount(arg, count);

    ref.invalidateSelf();
    return card;
  }

  Future<void> updateCard(
    StudyCard card, {
    File? newFrontImage,
    bool removeFrontImage = false,
    File? newBackImage,
    bool removeBackImage = false,
  }) async {
    final mediaService = ref.read(mediaStorageServiceProvider);
    var updated = card;

    // 处理正面图片变更
    if (removeFrontImage && card.frontImagePath != null) {
      await mediaService.deleteImage(card.frontImagePath!);
      updated = updated.copyWith(clearFrontImage: true);
    } else if (newFrontImage != null) {
      if (card.frontImagePath != null) {
        await mediaService.deleteImage(card.frontImagePath!);
      }
      final path = await mediaService.saveImage(newFrontImage);
      updated = updated.copyWith(frontImagePath: path);
    }

    // 处理背面图片变更
    if (removeBackImage && card.backImagePath != null) {
      await mediaService.deleteImage(card.backImagePath!);
      updated = updated.copyWith(clearBackImage: true);
    } else if (newBackImage != null) {
      if (card.backImagePath != null) {
        await mediaService.deleteImage(card.backImagePath!);
      }
      final path = await mediaService.saveImage(newBackImage);
      updated = updated.copyWith(backImagePath: path);
    }

    updated = updated.copyWith(updatedAt: DateTime.now());
    await _repo.updateCard(updated);
    ref.invalidateSelf();
  }

  Future<void> deleteCard(String cardId) async {
    final card = await _repo.getCardById(cardId);
    if (card != null) {
      final mediaService = ref.read(mediaStorageServiceProvider);
      if (card.frontImagePath != null) {
        await mediaService.deleteImage(card.frontImagePath!);
      }
      if (card.backImagePath != null) {
        await mediaService.deleteImage(card.backImagePath!);
      }
    }

    await _repo.deleteCard(cardId);

    // 更新卡组计数
    final count = await _repo.getCardCountByDeck(arg);
    await ref.read(deckRepositoryProvider).updateCardCount(arg, count);

    ref.invalidateSelf();
  }
}

/// 今日待复习卡片
final dueCardsProvider =
    FutureProvider.family<List<StudyCard>, String?>((ref, deckId) async {
  final repo = ref.watch(cardRepositoryProvider);
  return await repo.getDueCards(deckId: deckId);
});

/// 新卡片
final newCardsProvider =
    FutureProvider.family<List<StudyCard>, String?>((ref, deckId) async {
  final repo = ref.watch(cardRepositoryProvider);
  return await repo.getNewCards(deckId: deckId);
});

/// 全局今日待复习数
final totalDueCountProvider = FutureProvider<int>((ref) async {
  final cards = await ref.watch(cardRepositoryProvider).getDueCards();
  return cards.length;
});

/// 全局新卡数
final totalNewCountProvider = FutureProvider<int>((ref) async {
  final cards = await ref.watch(cardRepositoryProvider).getNewCards();
  return cards.length;
});

/// 搜索卡片
final cardSearchProvider =
    FutureProvider.family<List<StudyCard>, CardFilter>((ref, filter) async {
  return await ref.watch(cardRepositoryProvider).getFilteredCards(filter);
});

/// 所有标签
final allTagsProvider = FutureProvider<List<String>>((ref) async {
  return await ref.watch(cardRepositoryProvider).getAllTags();
});
