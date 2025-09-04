import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingSummaryWidget extends StatelessWidget {
  final Map<String, dynamic> travelerInfo;
  final Map<String, dynamic> roomSelection;
  final Map<String, dynamic> additionalServices;
  final Map<String, dynamic> paymentMethod;
  final double totalAmount;

  const BookingSummaryWidget({
    Key? key,
    required this.travelerInfo,
    required this.roomSelection,
    required this.additionalServices,
    required this.paymentMethod,
    required this.totalAmount,
  }) : super(key: key);

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
                iconName: 'receipt_long',
                color: AppTheme.primaryLight,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Итоговая информация',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Tour Information
          _buildTourInfo(),
          SizedBox(height: 3.h),

          // Traveler Information
          if (travelerInfo.isNotEmpty) ...[
            _buildTravelerInfo(),
            SizedBox(height: 3.h),
          ],

          // Room Selection
          if (roomSelection.isNotEmpty) ...[
            _buildRoomInfo(),
            SizedBox(height: 3.h),
          ],

          // Additional Services
          if (additionalServices.isNotEmpty &&
              (additionalServices['selectedServiceDetails'] as List?)
                      ?.isNotEmpty ==
                  true) ...[
            _buildServicesInfo(),
            SizedBox(height: 3.h),
          ],

          // Payment Method
          if (paymentMethod.isNotEmpty) ...[
            _buildPaymentInfo(),
            SizedBox(height: 3.h),
          ],

          // Price Breakdown
          _buildPriceBreakdown(),
        ],
      ),
    );
  }

  Widget _buildTourInfo() {
    return _buildSection(
      title: 'Тур',
      icon: 'flight_takeoff',
      children: [
        _buildInfoRow('Название', 'Умра - Священное путешествие'),
        _buildInfoRow('Даты', '15 марта - 22 марта 2025'),
        _buildInfoRow('Продолжительность', '7 дней / 6 ночей'),
        _buildInfoRow('Город отправления', 'Алматы'),
        _buildInfoRow('Отель', 'Hilton Suites Makkah 5★'),
      ],
    );
  }

  Widget _buildTravelerInfo() {
    return _buildSection(
      title: 'Путешественник',
      icon: 'person',
      children: [
        if (travelerInfo['firstName'] != null &&
            travelerInfo['firstName'].isNotEmpty)
          _buildInfoRow('Имя',
              '${travelerInfo['firstName']} ${travelerInfo['lastName']}'),
        if (travelerInfo['passportNumber'] != null &&
            travelerInfo['passportNumber'].isNotEmpty)
          _buildInfoRow('Паспорт', travelerInfo['passportNumber']),
        if (travelerInfo['phoneNumber'] != null &&
            travelerInfo['phoneNumber'].isNotEmpty)
          _buildInfoRow('Телефон', travelerInfo['phoneNumber']),
        if (travelerInfo['email'] != null && travelerInfo['email'].isNotEmpty)
          _buildInfoRow('Email', travelerInfo['email']),
      ],
    );
  }

  Widget _buildRoomInfo() {
    final roomDetails = roomSelection['roomDetails'] as Map<String, dynamic>?;
    if (roomDetails == null) return SizedBox.shrink();

    return _buildSection(
      title: 'Размещение',
      icon: 'hotel',
      children: [
        _buildInfoRow('Тип номера', roomDetails['name']),
        _buildInfoRow('Взрослые', '${roomSelection['adults']} чел.'),
        if (roomSelection['children'] > 0)
          _buildInfoRow('Дети', '${roomSelection['children']} чел.'),
        _buildInfoRow('Стоимость за ночь',
            '${(roomDetails['basePrice'] as double).toStringAsFixed(0)} ₸'),
      ],
    );
  }

  Widget _buildServicesInfo() {
    final services =
        additionalServices['selectedServiceDetails'] as List<dynamic>? ?? [];
    if (services.isEmpty) return SizedBox.shrink();

    return _buildSection(
      title: 'Дополнительные услуги',
      icon: 'add_circle_outline',
      children: services.map<Widget>((service) {
        final serviceMap = service as Map<String, dynamic>;
        return _buildInfoRow(
          serviceMap['name'],
          '+${(serviceMap['price'] as double).toStringAsFixed(0)} ₸',
        );
      }).toList(),
    );
  }

  Widget _buildPaymentInfo() {
    final methodDetails =
        paymentMethod['methodDetails'] as Map<String, dynamic>?;
    if (methodDetails == null) return SizedBox.shrink();

    return _buildSection(
      title: 'Способ оплаты',
      icon: 'payment',
      children: [
        _buildInfoRow('Метод', methodDetails['name']),
        if (methodDetails['fees'] > 0)
          _buildInfoRow('Комиссия', '${methodDetails['fees']}%'),
        _buildInfoRow('Время обработки', methodDetails['processingTime']),
      ],
    );
  }

  Widget _buildPriceBreakdown() {
    final roomPrice = roomSelection['totalPrice'] as double? ?? 0.0;
    final servicesPrice = additionalServices['totalPrice'] as double? ?? 0.0;
    final methodDetails =
        paymentMethod['methodDetails'] as Map<String, dynamic>?;
    final fees = methodDetails?['fees'] as double? ?? 0.0;
    final feeAmount = (roomPrice + servicesPrice) * (fees / 100);

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
            'Детализация стоимости',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryLight,
            ),
          ),
          SizedBox(height: 2.h),

          if (roomPrice > 0) ...[
            _buildPriceRow('Проживание (7 ночей)',
                '${(roomPrice * 7).toStringAsFixed(0)} ₸'),
            SizedBox(height: 1.h),
          ],

          if (servicesPrice > 0) ...[
            _buildPriceRow('Дополнительные услуги',
                '${servicesPrice.toStringAsFixed(0)} ₸'),
            SizedBox(height: 1.h),
          ],

          if (feeAmount > 0) ...[
            _buildPriceRow(
                'Комиссия за оплату', '${feeAmount.toStringAsFixed(0)} ₸'),
            SizedBox(height: 1.h),
          ],

          Divider(color: AppTheme.dividerLight, height: 2.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Итого к оплате',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryLight,
                ),
              ),
              Text(
                '${totalAmount.toStringAsFixed(0)} ₸',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryLight,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Important Notes
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.infoLight.withValues(alpha: 0.1),
              border:
                  Border.all(color: AppTheme.infoLight.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.infoLight,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Важная информация',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.infoLight,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Цены указаны в тенге и включают все налоги\n'
                  '• Бронирование действительно в течение 24 часов\n'
                  '• Отмена возможна за 72 часа до вылета\n'
                  '• Требуется действующий загранпаспорт',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.textMediumEmphasisLight,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textHighEmphasisLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            border: Border.all(color: AppTheme.dividerLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.textHighEmphasisLight,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        Text(
          amount,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
