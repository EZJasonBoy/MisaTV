import 'package:flutter/material.dart';

/// 沉浸观影模式的响应式尺寸。
///
/// 这套 UI 原本按电视 / 桌面宽屏设计：左右各 56 留白、150 宽竖版海报卡片、
/// 单行排 6 个导航 tab、Hero 描述框固定 760 宽。手机竖屏下这些数值会
/// 横向溢出，或把内容挤成一条窄柱。
///
/// 统一从这里取值：宽屏完全保持原样，窄屏（宽度 < 720）收紧留白、
/// 缩小卡片、顶栏改成两行。所有页面共用同一套数值，便于以后统一调整。
class ImmersiveMetrics {
  ImmersiveMetrics._(this.size, this.topPadding);

  factory ImmersiveMetrics.of(BuildContext context) {
    final media = MediaQuery.of(context);
    return ImmersiveMetrics._(media.size, media.padding.top);
  }

  final Size size;
  final double topPadding;

  /// 手机 / 窄屏（含竖屏平板）。
  bool get compact => size.width < 720;

  /// 常规左右留白：宽屏 56，手机 14。
  double get gutter => compact ? 14.0 : 56.0;

  /// 分类页等更宽松的留白：宽屏 64，手机 14。
  double get wideGutter => compact ? 14.0 : 64.0;

  /// 外壳顶栏总高度。手机为「状态栏 + 品牌行 44 + 导航行 48」两行。
  double get topBarHeight => compact ? topPadding + 44.0 + 48.0 : 72.0;

  /// 内容页顶部为顶栏预留的空间。
  double get contentTop => compact ? topBarHeight + 8.0 : 92.0;

  /// Hero 文字区左右 / 底部留白。
  double get heroInset => compact ? 14.0 : 64.0;
  double get heroBottom => compact ? 20.0 : 64.0;

  /// Hero 高度：宽屏铺满整屏，手机约半屏（下面还能看到分类与货架）。
  double get heroHeight => compact ? size.height * 0.48 : size.height;

  /// 竖版海报货架的卡片尺寸（2:3 封面 + 标题）。
  double get shelfHeight => compact ? 240.0 : 300.0;
  double get shelfCardWidth => compact ? 112.0 : 150.0;

  /// 网格里的竖版海报卡片：宽度上限与整格高度（含片名）。
  double get posterMaxExtent => compact ? 110.0 : 190.0;
  double get cardExtent => compact ? 270.0 : 380.0;
  double get categoryCardExtent => compact ? 280.0 : 390.0;

  /// 直播频道卡片宽度：手机占满一行，宽屏保持 232。
  double get liveTileWidth => compact ? size.width - gutter * 2 : 232.0;

  /// Hero 标题字号。
  double get heroTitleSize => compact ? 30.0 : 58.0;

  /// 详情页标题字号（null 表示沿用主题默认）。
  double? get detailTitleSize => compact ? 28.0 : null;
}
