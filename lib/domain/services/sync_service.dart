/// 同步服务接口（第一阶段仅定义，不实现）
/// 未来用于手机与桌面端、本地与云端的数据同步
abstract class SyncService {
  /// 同步状态
  Future<SyncStatus> getSyncStatus();

  /// 执行全量同步
  Future<SyncResult> syncAll();

  /// 增量同步（仅同步变更）
  Future<SyncResult> syncChanges();

  /// 上传本地变更
  Future<void> pushChanges();

  /// 拉取远程变更
  Future<void> pullChanges();
}

/// 同步状态
enum SyncStatus {
  idle,
  syncing,
  success,
  error,
  offline,
}

/// 同步结果
class SyncResult {
  final bool success;
  final int uploadedCount;
  final int downloadedCount;
  final String? errorMessage;

  const SyncResult({
    required this.success,
    this.uploadedCount = 0,
    this.downloadedCount = 0,
    this.errorMessage,
  });
}
