import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentMethodWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onPaymentMethodChanged;
  final Map<String, dynamic> initialPaymentMethod;

  const PaymentMethodWidget({
    Key? key,
    required this.onPaymentMethodChanged,
    this.initialPaymentMethod = const {},
  }) : super(key: key);

  @override
  State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  String? _selectedPaymentMethod;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'kaspi_pay',
      'name': 'Kaspi Pay',
      'description': 'Оплата через Kaspi QR или приложение',
      'icon': 'qr_code_scanner',
      'color': Color(0xFF00A651),
      'fees': 0.0,
      'processingTime': 'Мгновенно',
      'isPopular': true,
    },
    {
      'id': 'halyk_bank',
      'name': 'Halyk Bank',
      'description': 'Банковская карта Halyk Bank',
      'icon': 'credit_card',
      'color': Color(0xFF1E88E5),
      'fees': 1.5,
      'processingTime': '1-2 минуты',
      'isPopular': false,
    },
    {
      'id': 'jusan_bank',
      'name': 'Jusan Bank',
      'description': 'Банковская карта Jusan Bank',
      'icon': 'credit_card',
      'color': Color(0xFFFF6B35),
      'fees': 1.2,
      'processingTime': '1-2 минуты',
      'isPopular': false,
    },
    {
      'id': 'forte_bank',
      'name': 'ForteBank',
      'description': 'Банковская карта ForteBank',
      'icon': 'credit_card',
      'color': Color(0xFF8E24AA),
      'fees': 1.8,
      'processingTime': '2-3 минуты',
      'isPopular': false,
    },
    {
      'id': 'paypal',
      'name': 'PayPal',
      'description': 'Международная платежная система',
      'icon': 'account_balance_wallet',
      'color': Color(0xFF0070BA),
      'fees': 3.5,
      'processingTime': '3-5 минут',
      'isPopular': false,
    },
    {
      'id': 'stripe',
      'name': 'Банковская карта',
      'description': 'Visa, MasterCard, American Express',
      'icon': 'credit_card',
      'color': Color(0xFF6772E5),
      'fees': 2.9,
      'processingTime': '1-3 минуты',
      'isPopular': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialPaymentMethod();
  }

  void _loadInitialPaymentMethod() {
    if (widget.initialPaymentMethod.isNotEmpty) {
      _selectedPaymentMethod = widget.initialPaymentMethod['method'];
    }
  }

  void _notifyPaymentMethodChanged() {
    final paymentData = {
      'method': _selectedPaymentMethod,
      'methodDetails': _selectedPaymentMethod != null
          ? _paymentMethods
              .firstWhere((method) => method['id'] == _selectedPaymentMethod)
          : null,
      'isProcessing': _isProcessing,
    };
    widget.onPaymentMethodChanged(paymentData);
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
                iconName: 'payment',
                color: AppTheme.primaryLight,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Способ оплаты',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Security Notice
          _buildSecurityNotice(),
          SizedBox(height: 3.h),

          // Payment Methods
          ...(_paymentMethods
              .map((method) => _buildPaymentMethodCard(method))
              .toList()),

          if (_selectedPaymentMethod != null) ...[
            SizedBox(height: 3.h),
            _buildPaymentSummary(),
          ],
        ],
      ),
    );
  }

  Widget _buildSecurityNotice() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.successLight.withValues(alpha: 0.1),
        border: Border.all(color: AppTheme.successLight.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'security',
            color: AppTheme.successLight,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Безопасная оплата',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successLight,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Все платежи защищены SSL-шифрованием и соответствуют стандартам PCI DSS',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == method['id'];
    final isPopular = method['isPopular'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = method['id'];
          });
          _notifyPaymentMethodChanged();
        },
        child: Container(
          padding: EdgeInsets.all(4.w),
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
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: (method['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: method['icon'],
                      color: method['color'],
                      size: 6.w,
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
                                method['name'],
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textHighEmphasisLight,
                                ),
                              ),
                            ),
                            if (isPopular)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Популярно',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
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
                          method['description'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMediumEmphasisLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // Payment Details
              Row(
                children: [
                  Expanded(
                    child: _buildPaymentDetail(
                      'Комиссия',
                      method['fees'] == 0.0
                          ? 'Бесплатно'
                          : '${method['fees']}%',
                      method['fees'] == 0.0
                          ? AppTheme.successLight
                          : AppTheme.textMediumEmphasisLight,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 4.h,
                    color: AppTheme.dividerLight,
                  ),
                  Expanded(
                    child: _buildPaymentDetail(
                      'Время обработки',
                      method['processingTime'],
                      AppTheme.textMediumEmphasisLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentDetail(String label, String value, Color valueColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    final selectedMethod = _paymentMethods
        .firstWhere((method) => method['id'] == _selectedPaymentMethod);

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
            'Выбранный способ оплаты',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryLight,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color:
                      (selectedMethod['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: selectedMethod['icon'],
                  color: selectedMethod['color'],
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedMethod['name'],
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      selectedMethod['description'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (selectedMethod['fees'] > 0) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.warningLight.withValues(alpha: 0.1),
                border: Border.all(
                    color: AppTheme.warningLight.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.warningLight,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'К сумме заказа будет добавлена комиссия ${selectedMethod['fees']}%',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.warningLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool isValid() {
    return _selectedPaymentMethod != null;
  }

  Future<bool> processPayment(double amount) async {
    if (_selectedPaymentMethod == null) return false;

    setState(() {
      _isProcessing = true;
    });
    _notifyPaymentMethodChanged();

    try {
      // Simulate payment processing
      await Future.delayed(Duration(seconds: 3));

      // Mock payment success (in real app, integrate with actual payment gateways)
      final success = true; // This would be the actual payment result

      setState(() {
        _isProcessing = false;
      });
      _notifyPaymentMethodChanged();

      return success;
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _notifyPaymentMethodChanged();
      return false;
    }
  }
}
