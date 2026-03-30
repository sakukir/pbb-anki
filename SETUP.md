# 默记 MoCard - 项目搭建指南

## 环境要求
- Flutter >= 3.24.0
- Dart >= 3.5.0
- Android Studio / VS Code

## 搭建步骤

### 1. 创建 Flutter 项目
```bash
flutter create mocard --org com.mocard --project-name mocard
```

### 2. 替换文件
将本项目的 `lib/` 目录和 `pubspec.yaml` 复制到你创建的 Flutter 项目中。

### 3. 安装依赖
```bash
cd mocard
flutter pub get
```

### 4. 生成 Isar 代码
```bash
dart run build_runner build --delete-conflicting-outputs
```
这一步会为所有 Isar 模型生成 `.g.dart` 文件。

### 5. 字体文件（可选）
如果要使用 Noto Sans SC 中文字体：
1. 下载 Noto Sans SC 字体
2. 放到 `assets/fonts/` 目录
3. 确保 pubspec.yaml 中的字体配置正确

如果暂时不需要自定义字体，可以先注释掉 pubspec.yaml 中的 fonts 部分，
应用会使用系统默认字体。

### 6. 运行
```bash
flutter run
```

## 常见问题

### build_runner 报错
确保所有 Isar 模型文件中的 `part 'xxx.g.dart';` 声明正确。

### 图片选择不工作
在 Android 上需要确保 AndroidManifest.xml 中有正确的权限声明。
image_picker 插件通常会自动处理。

### 如果不想用自定义字体
修改 pubspec.yaml，删除 fonts 部分。
修改 app_typography.dart，将 _fontFamily 改为系统字体：
```dart
static const String _fontFamily = '';  // 使用系统字体
```
