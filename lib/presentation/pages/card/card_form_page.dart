import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_typography.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/domain/entities/card.dart';
import 'package:mocard/presentation/providers/card_providers.dart';
import 'package:mocard/presentation/providers/deck_providers.dart';
import 'package:mocard/presentation/providers/database_providers.dart';
import 'package:mocard/presentation/widgets/common/app_text_field.dart';
import 'package:mocard/presentation/widgets/common/app_button.dart';
import 'package:mocard/presentation/widgets/common/app_tag.dart';
import 'package:mocard/presentation/widgets/card/image_pick_area.dart';

class CardFormPage extends ConsumerStatefulWidget {
  final String deckId;
  final String? cardId;

  const CardFormPage({super.key, required this.deckId, this.cardId});

  @override
  ConsumerState<CardFormPage> createState() => _CardFormPageState();
}

class _CardFormPageState extends ConsumerState<CardFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _frontTextController = TextEditingController();
  final _backTextController = TextEditingController();
  final _noteController = TextEditingController();
  final _tagController = TextEditingController();

  File? _frontImage;
  File? _backImage;
  String? _existingFrontImagePath;
  String? _existingBackImagePath;
  bool _removeFrontImage = false;
  bool _removeBackImage = false;

  List<String> _tags = [];
  bool _isFavorite = false;
  bool _isImportant = false;
  bool _isDifficult = false;
  bool _isLoading = false;

  StudyCard? _existingCard;

  bool get isEditing => widget.cardId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadCard();
    }
  }

  Future<void> _loadCard() async {
    final card = await ref
        .read(cardRepositoryProvider)
        .getCardById(widget.cardId!);
    if (card != null && mounted) {
      _existingCard = card;
      _frontTextController.text = card.frontText ?? '';
      _backTextController.text = card.backText ?? '';
      _noteController.text = card.note ?? '';
      _tags = List.from(card.tags);
      _isFavorite = card.isFavorite;
      _isImportant = card.isImportant;
      _isDifficult = card.isDifficult;

      // 加载现有图片路径
      final media = ref.read(mediaStorageServiceProvider);
      if (card.frontImagePath != null) {
        _existingFrontImagePath =
            await media.getFullPath(card.frontImagePath!);
      }
      if (card.backImagePath != null) {
        _existingBackImagePath =
            await media.getFullPath(card.backImagePath!);
      }

      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _frontTextController.dispose();
    _backTextController.dispose();
    _noteController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑卡片' : '新建卡片'),
        actions: [
          if (isEditing)
            IconButton(
              onPressed: _confirmDelete,
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              tooltip: '删除卡片',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.pageHorizontalPadding),
          children: [
            // ── 题目 ──
            Text('题目', style: AppTypography.headlineSmall),
            const SizedBox(height: AppDimensions.spacingMd),

            AppTextField(
              hint: '输入题目内容...',
              controller: _frontTextController,
              maxLines: 5,
              minLines: 2,
              autofocus: !isEditing,
            ),
            const SizedBox(height: AppDimensions.spacingMd),

            ImagePickArea(
              label: '题目图片（可选）',
              selectedFile: _frontImage,
              existingImagePath:
                  _removeFrontImage ? null : _existingFrontImagePath,
              onImageChanged: (file) {
                setState(() {
                  _frontImage = file;
                  if (file == null) {
                    _removeFrontImage = true;
                  } else {
                    _removeFrontImage = false;
                  }
                });
              },
            ),

            const SizedBox(height: AppDimensions.spacingXl),
            const Divider(),
            const SizedBox(height: AppDimensions.spacingXl),

            // ── 答案 ──
            Text('答案', style: AppTypography.headlineSmall),
            const SizedBox(height: AppDimensions.spacingMd),

            AppTextField(
              hint: '输入答案内容...',
              controller: _backTextController,
              maxLines: 8,
              minLines: 3,
            ),
            const SizedBox(height: AppDimensions.spacingMd),

            ImagePickArea(
              label: '答案图片（可选）',
              selectedFile: _backImage,
              existingImagePath:
                  _removeBackImage ? null : _existingBackImagePath,
              onImageChanged: (file) {
                setState(() {
                  _backImage = file;
                  if (file == null) {
                    _removeBackImage = true;
                  } else {
                    _removeBackImage = false;
                  }
                });
              },
            ),

            const SizedBox(height: AppDimensions.spacingXl),
            const Divider(),
            const SizedBox(height: AppDimensions.spacingXl),

            // ── 备注 ──
            AppTextField(
              label: '备注 / 解析（可选）',
              hint: '补充说明、记忆技巧等...',
              controller: _noteController,
              maxLines: 4,
              minLines: 2,
            ),

            const SizedBox(height: AppDimensions.spacingXl),

            // ── 标签 ──
            Text('标签', style: AppTypography.labelLarge),
            const SizedBox(height: AppDimensions.spacingSm),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    style: AppTypography.bodyMedium,
                    decoration: InputDecoration(
                      hintText: '输入标签后按回车添加',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacingMd,
                        vertical: AppDimensions.spacingSm,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusBase,
                        ),
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: _addTag,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                IconButton(
                  onPressed: () => _addTag(_tagController.text),
                  icon: const Icon(Icons.add, color: AppColors.primary),
                ),
              ],
            ),

            if (_tags.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              AppTagList(
                tags: _tags,
                removable: true,
                onRemove: (tag) {
                  setState(() => _tags.remove(tag));
                },
              ),
            ],

            const SizedBox(height: AppDimensions.spacingXl),

            // ── 标记开关 ──
            _buildToggle(
              icon: Icons.star_outline,
              activeIcon: Icons.star,
              label: '收藏',
              value: _isFavorite,
              activeColor: AppColors.accent,
              onChanged: (v) => setState(() => _isFavorite = v),
            ),
            _buildToggle(
              icon: Icons.flag_outlined,
              activeIcon: Icons.flag,
              label: '重点',
              value: _isImportant,
              activeColor: AppColors.error,
              onChanged: (v) => setState(() => _isImportant = v),
            ),
            _buildToggle(
              icon: Icons.warning_amber_outlined,
              activeIcon: Icons.warning_amber,
              label: '易错',
              value: _isDifficult,
              activeColor: AppColors.warning,
              onChanged: (v) => setState(() => _isDifficult = v),
            ),

            const SizedBox(height: AppDimensions.spacingXxl),

            // ── 保存按钮 ──
            AppPrimaryButton(
              label: isEditing ? '保存修改' : '保存卡片',
              isLoading: _isLoading,
              onPressed: _save,
            ),

            // 保存并继续（仅新建时）
            if (!isEditing) ...[
              const SizedBox(height: AppDimensions.spacingMd),
              AppOutlineButton(
                label: '保存并继续添加',
                onPressed: () => _save(continueAdding: true),
              ),
            ],

            const SizedBox(height: AppDimensions.spacingXxl),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool value,
    required Color activeColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(AppDimensions.radiusBase),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spacingMd,
          ),
          child: Row(
            children: [
              Icon(
                value ? activeIcon : icon,
                size: 22,
                color: value ? activeColor : AppColors.textTertiary,
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Text(
                label,
                style: AppTypography.bodyLarge.copyWith(
                  color: value ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: activeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addTag(String text) {
    final tag = text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  Future<void> _save({bool continueAdding = false}) async {
    // 验证至少有题目内容
    final hasFrontText = _frontTextController.text.trim().isNotEmpty;
    final hasFrontImage = _frontImage != null ||
        (!_removeFrontImage && _existingFrontImagePath != null);

    if (!hasFrontText && !hasFrontImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少输入题目文字或添加题目图片')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final notifier =
          ref.read(cardListByDeckProvider(widget.deckId).notifier);

      if (isEditing && _existingCard != null) {
        await notifier.updateCard(
          _existingCard!.copyWith(
            frontText: _frontTextController.text.trim().isNotEmpty
                ? _frontTextController.text.trim()
                : null,
            backText: _backTextController.text.trim().isNotEmpty
                ? _backTextController.text.trim()
                : null,
            note: _noteController.text.trim().isNotEmpty
                ? _noteController.text.trim()
                : null,
            tags: _tags,
            isFavorite: _isFavorite,
            isImportant: _isImportant,
            isDifficult: _isDifficult,
          ),
          newFrontImage: _frontImage,
          removeFrontImage: _removeFrontImage,
          newBackImage: _backImage,
          removeBackImage: _removeBackImage,
        );
      } else {
        await notifier.createCard(
          frontText: _frontTextController.text.trim(),
          backText: _backTextController.text.trim(),
          frontImage: _frontImage,
          backImage: _backImage,
          note: _noteController.text.trim(),
          tags: _tags,
          isFavorite: _isFavorite,
          isImportant: _isImportant,
          isDifficult: _isDifficult,
        );
      }

      // 刷新卡组
      ref.invalidate(deckListProvider);
      ref.invalidate(deckDetailProvider(widget.deckId));

      if (mounted) {
        if (continueAdding) {
          // 清空表单继续添加
          _frontTextController.clear();
          _backTextController.clear();
          _noteController.clear();
          setState(() {
            _frontImage = null;
            _backImage = null;
            _existingFrontImagePath = null;
            _existingBackImagePath = null;
            _removeFrontImage = false;
            _removeBackImage = false;
            _tags = [];
            _isFavorite = false;
            _isImportant = false;
            _isDifficult = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('卡片已保存，继续添加')),
          );
        } else {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isEditing ? '卡片已更新' : '卡片已保存')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('确认删除'),
          content: const Text('删除后不可恢复，确定删除这张卡片吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await ref
                    .read(cardListByDeckProvider(widget.deckId).notifier)
                    .deleteCard(widget.cardId!);
                ref.invalidate(deckListProvider);
                ref.invalidate(deckDetailProvider(widget.deckId));
                if (mounted) {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('卡片已删除')),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
  }
}
