import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TourServicesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> includedServices;
  final List<Map<String, dynamic>> excludedServices;

  const TourServicesWidget({
    Key? key,
    required this.includedServices,
    required this.excludedServices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Что включено в тур',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Included services
          ...includedServices
              .map((service) => _buildServiceItem(service, true))
              .toList(),

          SizedBox(height: 2.h),

          // Excluded services header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'cancel',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Не включено в стоимость',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Excluded services
          ...excludedServices
              .map((service) => _buildServiceItem(service, false))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> service, bool isIncluded) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isIncluded
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05)
            : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: isIncluded
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2)
              : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: isIncluded
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(1.w),
            ),
            child: CustomIconWidget(
              iconName: service['icon'] as String,
              color: isIncluded
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.error,
              size: 16,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['title'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isIncluded
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.textMediumEmphasisLight,
                  ),
                ),
                if (service['description'] != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    service['description'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          CustomIconWidget(
            iconName: isIncluded ? 'check' : 'close',
            color: isIncluded
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.error,
            size: 16,
          ),
        ],
      ),
    );
  }
}
