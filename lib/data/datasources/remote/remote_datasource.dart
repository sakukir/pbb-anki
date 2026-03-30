/// 远程数据源接口（第一阶段仅定义，不实现）
/// 未来对接云端数据库时实现此接口
abstract class RemoteDatasource {
  // ── 卡组 ──
  Future<List<Map<String, dynamic>>> fetchDecks();
  Future<Map<String, dynamic>> fetchDeck(String id);
  Future<void> pushDeck(Map<String, dynamic> data);
  Future<void> deleteDeck(String id);

  // ── 卡片 ──
  Future<List<Map<String, dynamic>>> fetchCards({String? deckId});
  Future<Map<String, dynamic>> fetchCard(String id);
  Future<void> pushCard(Map<String, dynamic> data);
  Future<void> deleteCard(String id);

  // ── 复习记录 ──
  Future<void> pushReviewLog(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> fetchReviewLogs({
    String? cardId,
    String? since,
  });

  // ── 媒体 ──
  Future<String> uploadImage(String localPath);
  Future<String> downloadImage(String remoteId, String localPath);

  // ── 连接 ──
  Future<bool> isConnected();
  Future<DateTime?> getLastSyncTime();
}
