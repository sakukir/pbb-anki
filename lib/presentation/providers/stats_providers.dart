import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocard/domain/entities/study_stats.dart';
import 'database_providers.dart';

/// 学习统计概览
final statsOverviewProvider = FutureProvider<StudyStatsOverview>((ref) async {
  return await ref.watch(reviewRepositoryProvider).getStatsOverview();
});

/// 各卡组进度
final deckProgressListProvider =
    FutureProvider<List<DeckProgress>>((ref) async {
  final deckRepo = ref.watch(deckRepositoryProvider);
  final cardRepo = ref.watch(cardRepositoryProvider);
  final decks = await deckRepo.getAllDecks();
  final progressList = <DeckProgress>[];

  for (final deck in decks) {
    final cards = await cardRepo.getCardsByDeck(deck.id);
    int mastered = 0;
    int learning = 0;
    int newCount = 0;
    int due = 0;

    for (final card in cards) {
      if (card.reviewData.isNew) {
        newCount++;
      } else if (card.reviewData.repetitions >= 3) {
        mastered++;
      } else {
        learning++;
      }
      if (card.reviewData.isDueToday) {
        due++;
      }
    }

    progressList.add(DeckProgress(
      deckId: deck.id,
      deckName: deck.name,
      totalCards: cards.length,
      masteredCards: mastered,
      learningCards: learning,
      newCards: newCount,
      dueCards: due,
    ));
  }

  return progressList;
});
