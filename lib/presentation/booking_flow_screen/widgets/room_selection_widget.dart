import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoomSelectionWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onSelectionChanged;
  final Map<String, dynamic> initialSelection;

  const RoomSelectionWidget({
    Key? key,
    required this.onSelectionChanged,
    this.initialSelection = const {},
  }) : super(key: key);

  @override
  State<RoomSelectionWidget> createState() => _RoomSelectionWidgetState();
}

class _RoomSelectionWidgetState extends State<RoomSelectionWidget> {
  String? _selectedRoomType;
  int _adultsCount = 1;
  int _childrenCount = 0;
  double _totalPrice = 0.0;

  final List<Map<String, dynamic>> _roomTypes = [
    {
      'id': 'single',
      'name': 'Одноместный номер',
      'description': 'Комфортный номер для одного человека',
      'basePrice': 45000.0,
      'maxOccupancy': 1,
      'amenities': ['Wi-Fi', 'Кондиционер', 'Мини-бар', 'Сейф'],
      'image':
          'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?fm=jpg&q=60&w=3000',
      'available': 5,
    },
    {
      'id': 'double',
      'name': 'Двухместный номер',
      'description': 'Просторный номер с двумя кроватями',
      'basePrice': 75000.0,
      'maxOccupancy': 2,
      'amenities': ['Wi-Fi', 'Кондиционер', 'Мини-бар', 'Сейф', 'Балкон'],
      'image':
          'https://images.unsplash.com/photo-1566665797739-1674de7a421a?fm=jpg&q=60&w=3000',
      'available': 8,
    },
    {
      'id': 'triple',
      'name': 'Трехместный номер',
      'description': 'Семейный номер для троих человек',
      'basePrice': 95000.0,
      'maxOccupancy': 3,
      'amenities': [
        'Wi-Fi',
        'Кондиционер',
        'Мини-бар',
        'Сейф',
        'Балкон',
        'Диван'
      ],
      'image':
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?fm=jpg&q=60&w=3000',
      'available': 3,
    },
    {
      'id': 'family',
      'name': 'Семейный номер',
      'description': 'Большой номер для семьи до 4 человек',
      'basePrice': 120000.0,
      'maxOccupancy': 4,
      'amenities': [
        'Wi-Fi',
        'Кондиционер',
        'Мини-бар',
        'Сейф',
        'Балкон',
        'Диван',
        'Кухонный уголок'
      ],
      'image':
          'https://images.unsplash.com/photo-1590490360182-c33d57733427?fm=jpg&q=60&w=3000',
      'available': 2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialSelection();
  }

  void _loadInitialSelection() {
    if (widget.initialSelection.isNotEmpty) {
      _selectedRoomType = widget.initialSelection['roomType'];
      _adultsCount = widget.initialSelection['adults'] ?? 1;
      _childrenCount = widget.initialSelection['children'] ?? 0;
      _calculatePrice();
    }
  }

  void _calculatePrice() {
    if (_selectedRoomType != null) {
      final room =
          _roomTypes.firstWhere((room) => room['id'] == _selectedRoomType);
      _totalPrice = (room['basePrice'] as double) *
          (_adultsCount + (_childrenCount * 0.5));
    } else {
      _totalPrice = 0.0;
    }
    _notifySelectionChanged();
  }

  void _notifySelectionChanged() {
    final selection = {
      'roomType': _selectedRoomType,
      'adults': _adultsCount,
      'children': _childrenCount,
      'totalPrice': _totalPrice,
      'roomDetails': _selectedRoomType != null
          ? _roomTypes.firstWhere((room) => room['id'] == _selectedRoomType)
          : null,
    };
    widget.onSelectionChanged(selection);
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
                iconName: 'hotel',
                color: AppTheme.primaryLight,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Выбор номера',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Occupancy Selection
          _buildOccupancySelector(),
          SizedBox(height: 3.h),

          // Room Types
          Text(
            'Доступные номера',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textHighEmphasisLight,
            ),
          ),
          SizedBox(height: 2.h),

          ...(_roomTypes
              .where((room) =>
                  room['maxOccupancy'] >= _adultsCount + _childrenCount)
              .map((room) => _buildRoomCard(room))
              .toList()),

          if (_selectedRoomType != null) ...[
            SizedBox(height: 3.h),
            _buildPriceSummary(),
          ],
        ],
      ),
    );
  }

  Widget _buildOccupancySelector() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border.all(color: AppTheme.dividerLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Количество гостей',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildCounterWidget(
                  label: 'Взрослые',
                  count: _adultsCount,
                  onIncrement: () {
                    if (_adultsCount < 4) {
                      setState(() => _adultsCount++);
                      _calculatePrice();
                    }
                  },
                  onDecrement: () {
                    if (_adultsCount > 1) {
                      setState(() => _adultsCount--);
                      _calculatePrice();
                    }
                  },
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildCounterWidget(
                  label: 'Дети',
                  count: _childrenCount,
                  onIncrement: () {
                    if (_childrenCount < 2) {
                      setState(() => _childrenCount++);
                      _calculatePrice();
                    }
                  },
                  onDecrement: () {
                    if (_childrenCount > 0) {
                      setState(() => _childrenCount--);
                      _calculatePrice();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterWidget({
    required String label,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: onDecrement,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(color: AppTheme.primaryLight),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomIconWidget(
                  iconName: 'remove',
                  color: AppTheme.primaryLight,
                  size: 4.w,
                ),
              ),
            ),
            Text(
              count.toString(),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            InkWell(
              onTap: onIncrement,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.onPrimaryLight,
                  size: 4.w,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    final isSelected = _selectedRoomType == room['id'];
    final isAvailable = (room['available'] as int) > 0;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: isAvailable
            ? () {
                setState(() {
                  _selectedRoomType = room['id'];
                });
                _calculatePrice();
              }
            : null,
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryLight.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryLight
                  : isAvailable
                      ? AppTheme.dividerLight
                      : AppTheme.textDisabledLight,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: room['image'],
                      width: 20.w,
                      height: 15.w,
                      fit: BoxFit.cover,
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
                                room['name'],
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isAvailable
                                      ? AppTheme.textHighEmphasisLight
                                      : AppTheme.textDisabledLight,
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
                          room['description'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isAvailable
                                ? AppTheme.textMediumEmphasisLight
                                : AppTheme.textDisabledLight,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Text(
                              '${(room['basePrice'] as double).toStringAsFixed(0)} ₸',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isAvailable
                                    ? AppTheme.primaryLight
                                    : AppTheme.textDisabledLight,
                              ),
                            ),
                            Text(
                              ' / ночь',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textMediumEmphasisLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // Amenities
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: (room['amenities'] as List<String>).map((amenity) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      amenity,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.primaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),

              if (!isAvailable) ...[
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.errorLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info',
                        color: AppTheme.errorLight,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Номера закончились',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.errorLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                SizedBox(height: 1.h),
                Text(
                  'Осталось: ${room['available']} номеров',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSummary() {
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
            'Итого за проживание',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryLight,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Взрослые ($_adultsCount чел.) × 7 ночей',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              Text(
                '${(_totalPrice * 0.8).toStringAsFixed(0)} ₸',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (_childrenCount > 0) ...[
            SizedBox(height: 0.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Дети ($_childrenCount чел.) × 7 ночей',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                Text(
                  '${(_totalPrice * 0.2).toStringAsFixed(0)} ₸',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          Divider(color: AppTheme.dividerLight, height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Общая стоимость',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryLight,
                ),
              ),
              Text(
                '${(_totalPrice * 7).toStringAsFixed(0)} ₸',
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

  bool isValid() {
    return _selectedRoomType != null;
  }
}
