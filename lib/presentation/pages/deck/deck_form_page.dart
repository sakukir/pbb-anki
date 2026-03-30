import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_typography.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/core/constants/app_constants.dart';
import 'package:mocard/presentation/providers/database_providers.dart';
import 'package:mocard/presentation/providers/deck_providers.dart';
import 'package:mocard/presentation/widgets/common/app_text_field.dart';
import 'package:mocard/presentation/widgets/common/app_button.dart';

class DeckFormPage extends ConsumerStatefulWidget {
  final String? deckId;

  const DeckFormPage({super.key, this.deckId});

  @override
  ConsumerState<DeckFormPage> createState() => _DeckFormPageState();
}

class _DeckFormPageState extends ConsumerState<DeckFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedCategory;
  bool _isLoading = false;

  bool get isEditing => widget.deckId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadDeck();
    }
  }

  Future<void> _loadDeck() async {
    final deck = await ref
        .read(deckRepositoryProvider)
        .getDeckById(widget.deckId!);
    if (deck != null && mounted) {
      setState(() {
        _nameController.text = deck.name;
        _descController.text = deck.description ?? '';
        _selectedCategory = deck.category;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑卡组' : '新建卡组'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.pageHorizontalPadding),
          children: [
            // 卡组名称
            AppTextField(
              label: '卡组名称',
              hint: '例如：考研英语核心词汇',
              controller: _nameController,
              autofocus: !isEditing,
              maxLength: 50,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入卡组名称';
                }
                return null;
              },
            ),

            const SizedBox(height: AppDimensions.spacingLg),

            // 描述
            AppTextField(
              label: '描述（可选）',
              hint: '卡组的简单说明',
              controller: _descController,
              maxLines: 3,
              minLines: 2,
              maxLength: 200,
            ),

            const SizedBox(height: AppDimensions.spacingLg),

            // 分类
            Text('分类（可选）', style: AppTypography.labelLarge),
            const SizedBox(height: AppDimensions.spacingSm),
            Wrap(
              spacing: AppDimensions.spacingSm,
              runSpacing: AppDimensions.spacingSm,
              children: AppConstants.deckCategories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? cat : null;
                    });
                  },
                  selectedColor: AppColors.primaryLight,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppDimensions.spacingXxl),

            // 保存按钮
            AppPrimaryButton(
              label: isEditing ? '保存修改' : '创建卡组',
              isLoading: _isLoading,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (isEditing) {
        final deck = await ref
            .read(deckRepositoryProvider)
            .getDeckById(widget.deckId!);
        if (deck != null) {
          await ref.read(deckListProvider.notifier).updateDeck(
                deck.copyWith(
                  name: _nameController.text.trim(),
                  description: _descController.text.trim().isNotEmpty
                      ? _descController.text.trim()
                      : null,
                  category: _selectedCategory,
                ),
              );
        }
      } else {
        await ref.read(deckListProvider.notifier).createDeck(
              name: _nameController.text.trim(),
              description: _descController.text.trim().isNotEmpty
                  ? _descController.text.trim()
                  : null,
              category: _selectedCategory,
            );
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? '卡组已更新' : '卡组已创建'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
