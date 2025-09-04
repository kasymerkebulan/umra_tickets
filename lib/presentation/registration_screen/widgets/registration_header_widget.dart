import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationHeaderWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const RegistrationHeaderWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.textHighEmphasisLight,
                    size: 20,
                  ),
                ),
              ),
              Spacer(),
              // Progress Steps
              _buildProgressSteps(),
            ],
          ),

          SizedBox(height: 4.h),

          // Title and Subtitle
          Text(
            'Жаңа аккаунт құру',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textHighEmphasisLight,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'Умра сапарларын іздеу және брондау үшін тіркеліңіз',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSteps() {
    return Row(
      children: List.generate(totalSteps, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber <= currentStep;
        final isCompleted = stepNumber < currentStep;

        return Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: isActive
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Center(
                child: isCompleted
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 16,
                      )
                    : Text(
                        stepNumber.toString(),
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: isActive
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.textMediumEmphasisLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            if (index < totalSteps - 1)
              Container(
                width: 4.w,
                height: 0.2.h,
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                color: stepNumber < currentStep
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
              ),
          ],
        );
      }),
    );
  }
}
