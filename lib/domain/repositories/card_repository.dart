import 'package:mocard/domain/entities/card.dart';

/// 卡片筛选条件
class CardFilter {
  final String? deckId;
  final String? keyword;
  final String? tag;
  final bool? isFavorite;
  final bool? isImportant;
  final bool? isDifficult;
  final bool? isDueToday;
  final bool? isNew;

  const CardFilter({
    this.deckId,
    this.keyword,
    this.tag,
    this.isFavorite,
    this.isImportant,
    this.isDifficult,
    this.isDueToday,
    this.isNew,
  });

  bool get hasActiveFilters =>
      keyword != null ||
      tag != null ||
      isFavorite == true ||
      isImportant == true ||
      isDifficult == true ||
      isDueToday == true ||
      isNew == true;
}

/// 卡片仓库接口
abstract class CardRepository {
  /// 获取卡组中的所有卡片
  Future<List<StudyCard>> getCardsByDeck(String deckId);

  /// 根据 ID 获取卡片
  Future<StudyCard?> getCardById(String id);

  /// 按条件筛选卡片
  Future<List<StudyCard>> getFilteredCards(CardFilter filter);

  /// 获取今日待复习卡片
  Future<List<StudyCard>> getDueCards({String? deckId, int? limit});

  /// 获取新卡片（从未复习过）
  Future<List<StudyCard>> getNewCards({String? deckId, int? limit});

  /// 搜索卡片
  Future<List<StudyCard>> searchCards(String query);

  /// 创建卡片
  Future<StudyCard> createCard(StudyCard card);

  /// 更新卡片
  Future<StudyCard> updateCard(StudyCard card);

  /// 删除卡片
  Future<void> deleteCard(String id);

  /// 批量删除卡组内的所有卡片
  Future<void> deleteCardsByDeck(String deckId);

  /// 获取卡组中的卡片数量
  Future<int> getCardCountByDeck(String deckId);

  /// 获取所有卡片总数
  Future<int> getTotalCardCount();

  /// 获取所有使用过的标签
  Future<List<String>> getAllTags();

  /// 获取卡片引用的所有图片路径
  Future<List<String>> getAllImagePaths();
}
