/// 默记尺寸规范
/// 基于 4px 网格系统
class AppDimensions {
  AppDimensions._();

  // ── 间距 ──
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingBase = 16;
  static const double spacingLg = 20;
  static const double spacingXl = 24;
  static const double spacingXxl = 32;
  static const double spacingXxxl = 40;

  // ── 圆角 ──
  static const double radiusSm = 4;
  static const double radiusMd = 6;
  static const double radiusBase = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;

  // ── 图标 ──
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconBase = 24;
  static const double iconLg = 28;

  // ── 最小点击区域（Android 推荐 48dp） ──
  static const double minTouchTarget = 48;

  // ── 卡片 ──
  static const double cardElevation = 0;
  static const double cardBorderWidth = 1;

  // ── 列表项 ──
  static const double listItemMinHeight = 64;
  static const double listItemPadding = 16;

  // ── 按钮 ──
  static const double buttonHeight = 48;
  static const double buttonHeightSmall = 36;

  // ── 输入框 ──
  static const double inputHeight = 48;

  // ── 底部导航 ──
  static const double bottomNavHeight = 64;

  // ── 页面边距 ──
  static const double pageHorizontalPadding = 20;
  static const double pageTopPadding = 16;

  // ── 图片 ──
  static const double thumbnailSize = 56;
  static const double imagePreviewMaxHeight = 200;
  static const double imagePickAreaHeight = 120;
}
