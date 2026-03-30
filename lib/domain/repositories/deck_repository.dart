import 'package:mocard/domain/entities/deck.dart';

/// 卡组仓库接口
/// 当前由本地数据源实现，未来可接入远程数据源
abstract class DeckRepository {
  /// 获取所有卡组
  Future<List<Deck>> getAllDecks();

  /// 根据 ID 获取卡组
  Future<Deck?> getDeckById(String id);

  /// 搜索卡组
  Future<List<Deck>> searchDecks(String query);

  /// 按分类获取卡组
  Future<List<Deck>> getDecksByCategory(String category);

  /// 创建卡组
  Future<Deck> createDeck(Deck deck);

  /// 更新卡组
  Future<Deck> updateDeck(Deck deck);

  /// 删除卡组
  Future<void> deleteDeck(String id);

  /// 更新卡组的卡片数量（冗余字段同步）
  Future<void> updateCardCount(String deckId, int count);
}
