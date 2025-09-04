import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RegisterLinkWidget extends StatelessWidget {
  final VoidCallback onRegisterTap;
  final bool isLoading;

  const RegisterLinkWidget({
    Key? key,
    required this.onRegisterTap,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Жаңа пайдаланушы? ',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          GestureDetector(
            onTap: isLoading ? null : onRegisterTap,
            child: Text(
              'Тіркелу',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isLoading
                    ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5)
                    : AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: isLoading
                    ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5)
                    : AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
