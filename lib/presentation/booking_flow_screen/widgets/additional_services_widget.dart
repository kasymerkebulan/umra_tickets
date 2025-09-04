import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdditionalServicesWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onServicesChanged;
  final Map<String, dynamic> initialServices;

  const AdditionalServicesWidget({
    Key? key,
    required this.onServicesChanged,
    this.initialServices = const {},
  }) : super(key: key);

  @override
  State<AdditionalServicesWidget> createState() =>
      _AdditionalServicesWidgetState();
}

class _AdditionalServicesWidgetState extends State<AdditionalServicesWidget> {
  final Map<String, bool> _selectedServices = {};
  final Map<String, String> _specialRequests = {};
  double _totalServicePrice = 0.0;

  final List<Map<String, dynamic>> _services = [
    {
      'id': 'halal_meals',
      'name': 'Халяльное питание',
      'description': 'Специальное халяльное меню на весь период тура',
      'price': 15000.0,
      'icon': 'restaurant',
      'category': 'dining',
      'required': false,
    },
    {
      'id': 'vegetarian_meals',
      'name': 'Вегетарианское питание',
      'description': 'Вегетарианские блюда для всех приемов пищи',
      'price': 12000.0,
      'icon': 'eco',
      'category': 'dining',
      'required': false,
    },
    {
      'id': 'wheelchair_access',
      'name': 'Доступность для инвалидных колясок',
      'description': 'Специальные условия размещения и транспорта',
      'price': 25000.0,
      'icon': 'accessible',
      'category': 'accessibility',
      'required': false,
    },
    {
      'id': 'medical_assistance',
      'name': 'Медицинская поддержка',
      'description': '24/7 медицинская помощь и сопровождение',
      'price': 35000.0,
      'icon': 'medical_services',
      'category': 'medical',
      'required': false,
    },
    {
      'id': 'private_guide',
      'name': 'Персональный гид',
      'description': 'Индивидуальный русскоговорящий гид',
      'price': 50000.0,
      'icon': 'person',
      'category': 'guide',
      'required': false,
    },
    {
      'id': 'airport_transfer',
      'name': 'Трансфер из аэропорта',
      'description': 'Встреча в аэропорту и доставка в отель',
      'price': 8000.0,
      'icon': 'local_taxi',
      'category': 'transport',
      'required': false,
    },
    {
      'id': 'laundry_service',
      'name': 'Услуги прачечной',
      'description': 'Стирка и глажка одежды в отеле',
      'price': 5000.0,
      'icon': 'local_laundry_service',
      'category': 'hotel',
      'required': false,
    },
    {
      'id': 'wifi_upgrade',
      'name': 'Премиум Wi-Fi',
      'description': 'Высокоскоростной интернет в номере',
      'price': 3000.0,
      'icon': 'wifi',
      'category': 'hotel',
      'required': false,
    },
  ];

  final List<Map<String, dynamic>> _specialRequestOptions = [
    {
      'id': 'room_preference',
      'title': 'Предпочтения по номеру',
      'placeholder': 'Например: высокий этаж, вид на Каабу, тихий номер...',
    },
    {
      'id': 'dietary_restrictions',
      'title': 'Диетические ограничения',
      'placeholder': 'Укажите аллергии или особые требования к питанию...',
    },
    {
      'id': 'mobility_needs',
      'title': 'Особые потребности',
      'placeholder': 'Укажите особые потребности или ограничения...',
    },
    {
      'id': 'other_requests',
      'title': 'Другие пожелания',
      'placeholder': 'Любые дополнительные пожелания или комментарии...',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialServices();
  }

  void _loadInitialServices() {
    if (widget.initialServices.isNotEmpty) {
      final services =
          widget.initialServices['services'] as Map<String, dynamic>? ?? {};
      final requests =
          widget.initialServices['specialRequests'] as Map<String, dynamic>? ??
              {};

      services.forEach((key, value) {
        _selectedServices[key] = value as bool;
      });

      requests.forEach((key, value) {
        _specialRequests[key] = value as String;
      });

      _calculateTotalPrice();
    }
  }

  void _calculateTotalPrice() {
    _totalServicePrice = 0.0;
    _selectedServices.forEach((serviceId, isSelected) {
      if (isSelected) {
        final service = _services.firstWhere((s) => s['id'] == serviceId);
        _totalServicePrice += service['price'] as double;
      }
    });
    _notifyServicesChanged();
  }

  void _notifyServicesChanged() {
    final servicesData = {
      'services': Map<String, bool>.from(_selectedServices),
      'specialRequests': Map<String, String>.from(_specialRequests),
      'totalPrice': _totalServicePrice,
      'selectedServiceDetails': _services
          .where((service) => _selectedServices[service['id']] == true)
          .toList(),
    };
    widget.onServicesChanged(servicesData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'add_circle_outline',
                color: AppTheme.primaryLight,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Дополнительные услуги',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Services by Category
          ..._buildServicesByCategory(),

          SizedBox(height: 3.h),

          // Special Requests
          _buildSpecialRequestsSection(),

          if (_totalServicePrice > 0) ...[
            SizedBox(height: 3.h),
            _buildServicesSummary(),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildServicesByCategory() {
    final categories = {
      'dining': 'Питание',
      'accessibility': 'Доступность',
      'medical': 'Медицинские услуги',
      'guide': 'Гид и экскурсии',
      'transport': 'Транспорт',
      'hotel': 'Отель',
    };

    return categories.entries.map((category) {
      final categoryServices = _services
          .where((service) => service['category'] == category.key)
          .toList();

      if (categoryServices.isEmpty) return SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textHighEmphasisLight,
            ),
          ),
          SizedBox(height: 1.h),
          ...categoryServices.map((service) => _buildServiceCard(service)),
          SizedBox(height: 2.h),
        ],
      );
    }).toList();
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final isSelected = _selectedServices[service['id']] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedServices[service['id']] = !isSelected;
          });
          _calculateTotalPrice();
        },
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryLight.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            border: Border.all(
              color: isSelected ? AppTheme.primaryLight : AppTheme.dividerLight,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryLight
                      : AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryLight
                        : AppTheme.dividerLight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: service['icon'],
                  color: isSelected
                      ? AppTheme.onPrimaryLight
                      : AppTheme.textMediumEmphasisLight,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            service['name'],
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textHighEmphasisLight,
                            ),
                          ),
                        ),
                        if (isSelected)
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.primaryLight,
                            size: 5.w,
                          ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      service['description'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '+${(service['price'] as double).toStringAsFixed(0)} ₸',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Особые пожелания',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textHighEmphasisLight,
          ),
        ),
        SizedBox(height: 2.h),
        ..._specialRequestOptions
            .map((option) => _buildSpecialRequestField(option)),
      ],
    );
  }

  Widget _buildSpecialRequestField(Map<String, dynamic> option) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            option['title'],
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            initialValue: _specialRequests[option['id']] ?? '',
            maxLines: 3,
            onChanged: (value) {
              _specialRequests[option['id']] = value;
              _notifyServicesChanged();
            },
            decoration: InputDecoration(
              hintText: option['placeholder'],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.dividerLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.dividerLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.primaryLight, width: 2),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSummary() {
    final selectedServices = _services
        .where((service) => _selectedServices[service['id']] == true)
        .toList();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight.withValues(alpha: 0.05),
        border: Border.all(color: AppTheme.primaryLight.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Выбранные услуги',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryLight,
            ),
          ),
          SizedBox(height: 2.h),
          ...selectedServices.map((service) => Container(
                margin: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        service['name'],
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      '+${(service['price'] as double).toStringAsFixed(0)} ₸',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),
          Divider(color: AppTheme.dividerLight, height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Итого за услуги',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryLight,
                ),
              ),
              Text(
                '+${_totalServicePrice.toStringAsFixed(0)} ₸',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
