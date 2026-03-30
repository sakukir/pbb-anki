import 'package:flutter/material.dart';
import 'package:mocard/core/theme/app_colors.dart';
import 'package:mocard/core/theme/app_dimensions.dart';
import 'package:mocard/core/constants/app_constants.dart';

/// 复习评级按钮栏
/// 三个大按钮，底部放置，方便单手操作
class ReviewRatingBar extends StatelessWidget {
  final ValueChanged<int> onRate;

  const ReviewRatingBar({super.key, required this.onRate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingBase,
      ),
      child: Row(
        children: [
          Expanded(
            child: _RatingButton(
              label: '忘了',
              color: AppColors.ratingForgot,
              onTap: () => onRate(AppConstants.ratingForgot),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: _RatingButton(
              label: '模糊',
              color: AppColors.ratingVague,
              onTap: () => onRate(AppConstants.ratingVague),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: _RatingButton(
              label: '记得',
              color: AppColors.ratingRemember,
              onTap: () => onRate(AppConstants.ratingRemember),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _RatingButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusBase),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusBase),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
