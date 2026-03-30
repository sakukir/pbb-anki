import 'package:flutter/material.dart';

/// 默记配色系统
/// 设计原则：温和、克制、耐看，纸质笔记感
class AppColors {
  AppColors._();

  // ── 基础背景 ──
  static const Color background = Color(0xFFFAFAF8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F3);

  // ── 主色调：沉稳墨绿 ──
  static const Color primary = Color(0xFF4A6741);
  static const Color primaryLight = Color(0xFFE8EFE6);
  static const Color primaryDark = Color(0xFF3A5233);

  // ── 强调色：温暖琥珀 ──
  static const Color accent = Color(0xFFC17B3A);
  static const Color accentLight = Color(0xFFFAF0E4);

  // ── 文字 ──
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9B9B9B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── 语义色 ──
  static const Color error = Color(0xFFC05746);
  static const Color errorLight = Color(0xFFFDF0EE);
  static const Color success = Color(0xFF5B8A5A);
  static const Color successLight = Color(0xFFEDF5EC);
  static const Color warning = Color(0xFFD4A843);
  static const Color warningLight = Color(0xFFFDF8EC);

  // ── 边框与分割线 ──
  static const Color border = Color(0xFFE8E7E5);
  static const Color divider = Color(0xFFF0EFED);

  // ── 复习评级色 ──
  static const Color ratingForgot = Color(0xFFC05746);
  static const Color ratingVague = Color(0xFFD4A843);
  static const Color ratingRemember = Color(0xFF5B8A5A);

  // ── 标签色板（低饱和） ──
  static const List<Color> tagColors = [
    Color(0xFFE8EFE6), // 绿
    Color(0xFFFAF0E4), // 橙
    Color(0xFFE8EDF5), // 蓝
    Color(0xFFF5E8F0), // 紫
    Color(0xFFFDF8EC), // 黄
    Color(0xFFEDF5F5), // 青
  ];

  static const List<Color> tagTextColors = [
    Color(0xFF4A6741),
    Color(0xFFC17B3A),
    Color(0xFF4A5A8A),
    Color(0xFF7A4A6E),
    Color(0xFF8A7A3A),
    Color(0xFF3A7A7A),
  ];
}
