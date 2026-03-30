import 'dart:io';

/// 媒体存储服务接口
/// 当前实现：本地文件存储
/// 未来实现：云端存储（如 S3、Firebase Storage）
abstract class MediaStorageService {
  /// 保存图片文件，返回相对路径（用于存入数据库）
  /// [sourceFile] 原始文件（例如相册选取的）
  /// 返回值是相对于应用目录的路径
  Future<String> saveImage(File sourceFile);

  /// 根据相对路径获取完整的本地文件路径
  /// 本地实现直接拼接目录
  /// 云端实现可返回 URL 或本地缓存路径
  Future<String> getFullPath(String relativePath);

  /// 删除图片
  Future<void> deleteImage(String relativePath);

  /// 检查图片是否存在
  Future<bool> imageExists(String relativePath);

  /// 清理孤儿图片（不被任何卡片引用的图片）
  /// [activeImagePaths] 当前所有卡片使用的图片路径列表
  Future<int> cleanOrphanImages(List<String> activeImagePaths);

  /// 获取图片存储目录大小（字节）
  Future<int> getStorageSize();
}
