import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/google_signin_widget.dart';
import './widgets/registration_form_widget.dart';
import './widgets/registration_header_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  // Mock user data for demonstration
  final List<Map<String, dynamic>> _existingUsers = [
    {
      "id": 1,
      "email": "admin@umratickets.kz",
      "fullName": "Администратор",
      "phone": "+77771234567",
      "isVerified": true,
    },
    {
      "id": 2,
      "email": "user@example.com",
      "fullName": "Тест Пайдаланушы",
      "phone": "+77779876543",
      "isVerified": false,
    },
  ];

  Future<void> _handleRegistration(Map<String, String> formData) async {
    setState(() => _isLoading = true);

    try {
      // Simulate network delay
      await Future.delayed(Duration(seconds: 2));

      // Check if email already exists
      final existingUser = _existingUsers.firstWhere(
        (user) =>
            user['email'].toLowerCase() == formData['email']!.toLowerCase(),
        orElse: () => {},
      );

      if (existingUser.isNotEmpty) {
        _showErrorToast('Бұл электрондық пошта тіркелген');
        return;
      }

      // Check if phone already exists
      final existingPhone = _existingUsers.firstWhere(
        (user) => user['phone'] == formData['phone'],
        orElse: () => {},
      );

      if (existingPhone.isNotEmpty) {
        _showErrorToast('Бұл телефон нөмірі тіркелген');
        return;
      }

      // Simulate successful registration
      _showSuccessDialog(formData);
    } catch (e) {
      _showErrorToast('Тіркелу кезінде қате орын алды. Қайталап көріңіз.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);

    try {
      // Simulate Google Sign-In process
      await Future.delayed(Duration(seconds: 2));

      // Simulate successful Google authentication
      _showSuccessToast('Google арқылы сәтті тіркелдіңіз!');

      // Navigate to tour browse screen
      Navigator.pushReplacementNamed(context, '/tour-browse-screen');
    } catch (e) {
      _showErrorToast('Google арқылы тіркелу сәтсіз аяқталды');
    } finally {
      setState(() => _isGoogleLoading = false);
    }
  }

  void _showSuccessDialog(Map<String, String> formData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.w),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successLight,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Тіркелу сәтті!',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textHighEmphasisLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Сәлеметсіз бе, ${formData['fullName']}!',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textHighEmphasisLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Аккаунтыңыз сәтті құрылды. Электрондық поштаңызға растау хаты жіберілді.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Электрондық поштаңызды тексеріп, аккаунтты растаңыз.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login-screen');
              },
              child: Text(
                'Кіру бетіне өту',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successLight,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.error,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: [
                // Header with progress indicator
                RegistrationHeaderWidget(
                  currentStep: 1,
                  totalSteps: 3,
                ),

                // Main content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    children: [
                      // Registration Form
                      RegistrationFormWidget(
                        onFormSubmit: _handleRegistration,
                        isLoading: _isLoading,
                      ),

                      SizedBox(height: 4.h),

                      // Google Sign-In Section
                      GoogleSignInWidget(
                        onGoogleSignIn: _handleGoogleSignIn,
                        isLoading: _isGoogleLoading,
                      ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
