import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_typography.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/core/constants/app_constants.dart';
import 'package:mocard/presentation/providers/settings_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: settingsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (settings) {
          return ListView(
            children: [
              const SizedBox(height: AppDimensions.spacingBase),

              // ── 学习设置 ──
              _buildSectionHeader('学习设置'),
              _buildSettingItem(
                context: context,
                icon: Icons.add_circle_outline,
                title: '每日新卡上限',
                subtitle: '${settings.dailyNewCardLimit} 张',
                onTap: () => _showNumberPicker(
                  context: context,
                  title: '每日新卡上限',
                  currentValue: settings.dailyNewCardLimit,
                  min: 5,
                  max: 100,
                  step: 5,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .setDailyNewCardLimit(value);
                  },
                ),
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.replay,
                title: '每日复习上限',
                subtitle: '${settings.dailyReviewLimit} 张',
                onTap: () => _showNumberPicker(
                  context: context,
                  title: '每日复习上限',
                  currentValue: settings.dailyReviewLimit,
                  min: 20,
                  max: 500,
                  step: 10,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .setDailyReviewLimit(value);
                  },
                ),
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.touch_app_outlined,
                title: '复习翻面方式',
                subtitle: settings.reviewFlipMode == 'tap' ? '点击翻面' : '按钮翻面',
                onTap: () {
                  final newMode =
                      settings.reviewFlipMode == 'tap' ? 'button' : 'tap';
                  ref
                      .read(settingsProvider.notifier)
                      .setReviewFlipMode(newMode);
                },
              ),

              const SizedBox(height: AppDimensions.spacingLg),

              // ── 外观 ──
              _buildSectionHeader('外观'),
              _buildSettingItem(
                context: context,
                icon: Icons.palette_outlined,
                title: '主题',
                subtitle: '浅色模式',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingSm,
                    vertical: AppDimensions.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Text(
                    '即将支持',
                    style: AppTypography.labelSmall,
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingLg),

              // ── 数据管理 ──
              _buildSectionHeader('数据管理'),
              _buildSettingItem(
                context: context,
                icon: Icons.upload_outlined,
                title: '导出数据',
                subtitle: '将卡组和卡片导出为文件',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingSm,
                    vertical: AppDimensions.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Text(
                    '即将支持',
                    style: AppTypography.labelSmall,
                  ),
                ),
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.download_outlined,
                title: '导入数据',
                subtitle: '从文件导入卡组和卡片',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingSm,
                    vertical: AppDimensions.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Text(
                    '即将支持',
                    style: AppTypography.labelSmall,
                  ),
                ),
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.cleaning_services_outlined,
                title: '清理图片缓存',
                subtitle: '删除不再被引用的图片文件',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingSm,
                    vertical: AppDimensions.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Text(
                    '即将支持',
                    style: AppTypography.labelSmall,
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingLg),

              // ── 关于 ──
              _buildSectionHeader('关于'),
              _buildSettingItem(
                context: context,
                icon: Icons.info_outline,
                title: AppConstants.appName,
                subtitle: '版本 ${AppConstants.appVersion}',
              ),

              const SizedBox(height: AppDimensions.spacingXxl),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.pageHorizontalPadding,
        vertical: AppDimensions.spacingSm,
      ),
      child: Text(
        title,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Material(
      color: AppColors.surface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.pageHorizontalPadding,
            vertical: AppDimensions.spacingMd,
          ),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.divider, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppColors.textSecondary),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.bodyLarge),
                    if (subtitle != null)
                      Text(subtitle, style: AppTypography.labelSmall),
                  ],
                ),
              ),
              if (trailing != null) trailing,
              if (onTap != null && trailing == null)
                const Icon(
                  Icons.chevron_right,
                  size: AppDimensions.iconMd,
                  color: AppColors.textTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNumberPicker({
    required BuildContext context,
    required String title,
    required int currentValue,
    required int min,
    required int max,
    required int step,
    required ValueChanged<int> onChanged,
  }) {
    int selected = currentValue;
    final options = <int>[];
    for (int i = min; i <= max; i += step) {
      options.add(i);
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(
                      top: AppDimensions.spacingMd,
                      bottom: AppDimensions.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingBase),
                    child: Text(title, style: AppTypography.titleMedium),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final value = options[index];
                        final isSelected = value == selected;
                        return ListTile(
                          title: Text(
                            '$value',
                            style: isSelected
                                ? AppTypography.bodyLarge.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  )
                                : AppTypography.bodyLarge,
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: AppColors.primary,
                                )
                              : null,
                          onTap: () {
                            onChanged(value);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
