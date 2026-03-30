import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:mocard/core/constants/app_constants.dart';
import 'package:mocard/core/utils/image_utils.dart';
import 'package:mocard/domain/services/media_storage_service.dart';

/// 本地媒体存储服务实现
class LocalMediaStorageService implements MediaStorageService {
  static const _uuid = Uuid();
  String? _baseDirCache;

  /// 获取图片存储基础目录
  Future<String> _getBaseDir() async {
    if (_baseDirCache != null) return _baseDirCache!;
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory(
      p.join(appDir.path, AppConstants.imageDirectoryName),
    );
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    _baseDirCache = appDir.path;
    return _baseDirCache!;
  }

  @override
  Future<String> saveImage(File sourceFile) async {
    final baseDir = await _getBaseDir();
    final ext = ImageUtils.getExtension(sourceFile.path);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${_uuid.v4()}_$timestamp.$ext';
    final relativePath = p.join(AppConstants.imageDirectoryName, fileName);
    final targetPath = p.join(baseDir, relativePath);

    await sourceFile.copy(targetPath);

    return relativePath;
  }

  @override
  Future<String> getFullPath(String relativePath) async {
    final baseDir = await _getBaseDir();
    return p.join(baseDir, relativePath);
  }

  @override
  Future<void> deleteImage(String relativePath) async {
    final fullPath = await getFullPath(relativePath);
    final file = File(fullPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<bool> imageExists(String relativePath) async {
    final fullPath = await getFullPath(relativePath);
    return File(fullPath).exists();
  }

  @override
  Future<int> cleanOrphanImages(List<String> activeImagePaths) async {
    final baseDir = await _getBaseDir();
    final imageDir = Directory(
      p.join(baseDir, AppConstants.imageDirectoryName),
    );

    if (!await imageDir.exists()) return 0;

    final activeSet = activeImagePaths.toSet();
    int cleaned = 0;

    await for (final entity in imageDir.list()) {
      if (entity is File) {
        final relativePath = p.join(
          AppConstants.imageDirectoryName,
          p.basename(entity.path),
        );
        if (!activeSet.contains(relativePath)) {
          await entity.delete();
          cleaned++;
        }
      }
    }

    return cleaned;
  }

  @override
  Future<int> getStorageSize() async {
    final baseDir = await _getBaseDir();
    final imageDir = Directory(
      p.join(baseDir, AppConstants.imageDirectoryName),
    );

    if (!await imageDir.exists()) return 0;

    int totalSize = 0;
    await for (final entity in imageDir.list()) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }

    return totalSize;
  }
}
