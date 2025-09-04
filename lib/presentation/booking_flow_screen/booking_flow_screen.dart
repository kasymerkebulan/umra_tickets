import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/additional_services_widget.dart';
import './widgets/booking_progress_indicator.dart';
import './widgets/booking_summary_widget.dart';
import './widgets/payment_method_widget.dart';
import './widgets/room_selection_widget.dart';
import './widgets/traveler_info_form.dart';

class BookingFlowScreen extends StatefulWidget {
  const BookingFlowScreen({Key? key}) : super(key: key);

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _currentStep = 0;
  bool _isLoading = false;
  bool _isBookingComplete = false;

  final List<String> _stepTitles = [
    'Информация',
    'Номер',
    'Услуги',
    'Оплата',
    'Подтверждение'
  ];

  // Form data storage
  Map<String, dynamic> _travelerInfo = {};
  Map<String, dynamic> _roomSelection = {};
  Map<String, dynamic> _additionalServices = {};
  Map<String, dynamic> _paymentMethod = {};
  double _totalAmount = 0.0;

  // Form keys for validation
  final GlobalKey<FormState> _travelerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculateTotalAmount() {
    double roomPrice =
        (_roomSelection['totalPrice'] as double? ?? 0.0) * 7; // 7 nights
    double servicesPrice = _additionalServices['totalPrice'] as double? ?? 0.0;
    double subtotal = roomPrice + servicesPrice;

    // Add payment method fees
    final methodDetails =
        _paymentMethod['methodDetails'] as Map<String, dynamic>?;
    double fees = 0.0;
    if (methodDetails != null) {
      fees = subtotal * ((methodDetails['fees'] as double? ?? 0.0) / 100);
    }

    setState(() {
      _totalAmount = subtotal + fees;
    });
  }

  void _onTravelerInfoChanged(Map<String, dynamic> data) {
    setState(() {
      _travelerInfo = data;
    });
  }

  void _onRoomSelectionChanged(Map<String, dynamic> data) {
    setState(() {
      _roomSelection = data;
    });
    _calculateTotalAmount();
  }

  void _onAdditionalServicesChanged(Map<String, dynamic> data) {
    setState(() {
      _additionalServices = data;
    });
    _calculateTotalAmount();
  }

  void _onPaymentMethodChanged(Map<String, dynamic> data) {
    setState(() {
      _paymentMethod = data;
    });
    _calculateTotalAmount();
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0: // Traveler Info
        return _travelerInfo.isNotEmpty &&
            _travelerInfo['firstName']?.isNotEmpty == true &&
            _travelerInfo['lastName']?.isNotEmpty == true &&
            _travelerInfo['passportNumber']?.isNotEmpty == true &&
            _travelerInfo['phoneNumber']?.isNotEmpty == true &&
            _travelerInfo['email']?.isNotEmpty == true &&
            _travelerInfo['gender'] != null &&
            _travelerInfo['birthDate'] != null;
      case 1: // Room Selection
        return _roomSelection.isNotEmpty && _roomSelection['roomType'] != null;
      case 2: // Additional Services
        return true; // Optional step
      case 3: // Payment Method
        return _paymentMethod.isNotEmpty && _paymentMethod['method'] != null;
      case 4: // Summary
        return true;
      default:
        return false;
    }
  }

  Future<void> _nextStep() async {
    if (!_canProceedToNextStep()) {
      _showErrorMessage('Пожалуйста, заполните все обязательные поля');
      return;
    }

    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
      await _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _completeBooking();
    }
  }

  Future<void> _previousStep() async {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      await _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeBooking() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate booking process
      await Future.delayed(Duration(seconds: 2));

      // Process payment (mock implementation)
      final paymentWidget =
          _paymentMethod['methodDetails'] as Map<String, dynamic>?;
      if (paymentWidget != null) {
        // In real implementation, process actual payment here
        await Future.delayed(Duration(seconds: 1));
      }

      setState(() {
        _isBookingComplete = true;
        _isLoading = false;
      });

      _showBookingConfirmation();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage(
          'Произошла ошибка при оформлении бронирования. Попробуйте еще раз.');
    }
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.successLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successLight,
                size: 10.w,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Бронирование подтверждено!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.successLight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Ваше бронирование успешно оформлено. Номер бронирования: UMR${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Детали бронирования отправлены на ваш email.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/tour-browse-screen');
                    },
                    child: Text('К турам'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/ai-chat-support-screen');
                    },
                    child: Text('Поддержка'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Оформление бронирования'),
        leading: _currentStep > 0
            ? IconButton(
                onPressed: _previousStep,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.onPrimaryLight,
                  size: 6.w,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.onPrimaryLight,
                  size: 6.w,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/ai-chat-support-screen'),
            icon: CustomIconWidget(
              iconName: 'support_agent',
              color: AppTheme.onPrimaryLight,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Progress Indicator
            BookingProgressIndicator(
              currentStep: _currentStep,
              totalSteps: _stepTitles.length,
              stepTitles: _stepTitles,
            ),

            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // Step 1: Traveler Information
                  _buildStepContent(
                    child: TravelerInfoForm(
                      key: _travelerFormKey,
                      onDataChanged: _onTravelerInfoChanged,
                      initialData: _travelerInfo,
                    ),
                  ),

                  // Step 2: Room Selection
                  _buildStepContent(
                    child: RoomSelectionWidget(
                      onSelectionChanged: _onRoomSelectionChanged,
                      initialSelection: _roomSelection,
                    ),
                  ),

                  // Step 3: Additional Services
                  _buildStepContent(
                    child: AdditionalServicesWidget(
                      onServicesChanged: _onAdditionalServicesChanged,
                      initialServices: _additionalServices,
                    ),
                  ),

                  // Step 4: Payment Method
                  _buildStepContent(
                    child: PaymentMethodWidget(
                      onPaymentMethodChanged: _onPaymentMethodChanged,
                      initialPaymentMethod: _paymentMethod,
                    ),
                  ),

                  // Step 5: Booking Summary
                  _buildStepContent(
                    child: BookingSummaryWidget(
                      travelerInfo: _travelerInfo,
                      roomSelection: _roomSelection,
                      additionalServices: _additionalServices,
                      paymentMethod: _paymentMethod,
                      totalAmount: _totalAmount,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Action Bar
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent({required Widget child}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: child,
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price Summary
            if (_totalAmount > 0) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Итого к оплате:',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${_totalAmount.toStringAsFixed(0)} ₸',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
            ],

            // Action Buttons
            Row(
              children: [
                if (_currentStep > 0) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _previousStep,
                      child: Text('Назад'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                ],
                Expanded(
                  flex: _currentStep > 0 ? 1 : 2,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _nextStep,
                    child: _isLoading
                        ? SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.onPrimaryLight,
                              ),
                            ),
                          )
                        : Text(
                            _currentStep == _stepTitles.length - 1
                                ? 'Подтвердить бронирование'
                                : 'Продолжить',
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
