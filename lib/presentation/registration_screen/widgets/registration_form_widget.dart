import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatefulWidget {
  final Function(Map<String, String>) onFormSubmit;
  final bool isLoading;

  const RegistrationFormWidget({
    Key? key,
    required this.onFormSubmit,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _acceptTerms = false;
  bool _isFormValid = false;

  // Validation states
  bool _fullNameValid = false;
  bool _emailValid = false;
  bool _phoneValid = false;
  bool _passwordValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.text = '+7';
    _addListeners();
  }

  void _addListeners() {
    _fullNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _fullNameValid = _validateFullName(_fullNameController.text) == null;
      _emailValid = _validateEmail(_emailController.text) == null;
      _phoneValid = _validatePhone(_phoneController.text) == null;
      _passwordValid = _validatePassword(_passwordController.text) == null;

      _isFormValid = _fullNameValid &&
          _emailValid &&
          _phoneValid &&
          _passwordValid &&
          _acceptTerms;
    });
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Толық атыңызды енгізіңіз';
    }
    if (value.trim().length < 2) {
      return 'Атыңыз кемінде 2 әріптен тұруы керек';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Электрондық поштаңызды енгізіңіз';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Дұрыс электрондық пошта енгізіңіз';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Телефон нөміріңізді енгізіңіз';
    }
    final phoneRegex = RegExp(r'^\+7[0-9]{10}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Дұрыс телефон нөмірін енгізіңіз (+7XXXXXXXXXX)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Құпия сөзді енгізіңіз';
    }
    if (value.length < 8) {
      return 'Құпия сөз кемінде 8 таңбадан тұруы керек';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Кіші әріп, үлкен әріп және сан болуы керек';
    }
    return null;
  }

  double _getPasswordStrength(String password) {
    if (password.isEmpty) return 0.0;

    double strength = 0.0;
    if (password.length >= 8) strength += 0.25;
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.25;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.25;

    return strength;
  }

  Color _getPasswordStrengthColor(double strength) {
    if (strength <= 0.25) return AppTheme.lightTheme.colorScheme.error;
    if (strength <= 0.5) return AppTheme.warningLight;
    if (strength <= 0.75) return AppTheme.lightTheme.colorScheme.tertiary;
    return AppTheme.successLight;
  }

  String _getPasswordStrengthText(double strength) {
    if (strength <= 0.25) return 'Әлсіз';
    if (strength <= 0.5) return 'Орташа';
    if (strength <= 0.75) return 'Жақсы';
    return 'Күшті';
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate() && _isFormValid) {
      final formData = {
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
      };
      widget.onFormSubmit(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Field
          _buildInputField(
            controller: _fullNameController,
            label: 'Толық аты',
            hint: 'Атыңыз бен тегіңізді енгізіңіз',
            prefixIcon: 'person',
            validator: _validateFullName,
            isValid: _fullNameValid,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
          ),

          SizedBox(height: 3.h),

          // Email Field
          _buildInputField(
            controller: _emailController,
            label: 'Электрондық пошта',
            hint: 'example@email.com',
            prefixIcon: 'email',
            validator: _validateEmail,
            isValid: _emailValid,
            keyboardType: TextInputType.emailAddress,
          ),

          SizedBox(height: 3.h),

          // Phone Field
          _buildPhoneField(),

          SizedBox(height: 3.h),

          // Password Field
          _buildPasswordField(),

          SizedBox(height: 2.h),

          // Password Strength Indicator
          if (_passwordController.text.isNotEmpty)
            _buildPasswordStrengthIndicator(),

          SizedBox(height: 3.h),

          // Terms and Conditions
          _buildTermsCheckbox(),

          SizedBox(height: 4.h),

          // Submit Button
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String prefixIcon,
    required String? Function(String?) validator,
    required bool isValid,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: prefixIcon,
                color: AppTheme.textMediumEmphasisLight,
                size: 20,
              ),
            ),
            suffixIcon: controller.text.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: isValid ? 'check_circle' : 'error',
                      color: isValid
                          ? AppTheme.successLight
                          : AppTheme.lightTheme.colorScheme.error,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Телефон нөмірі',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _phoneController,
          validator: _validatePhone,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '+7 XXX XXX XX XX',
            prefixIcon: Container(
              width: 15.w,
              padding: EdgeInsets.all(3.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🇰🇿',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: 'phone',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 20,
                  ),
                ],
              ),
            ),
            suffixIcon: _phoneController.text.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: _phoneValid ? 'check_circle' : 'error',
                      color: _phoneValid
                          ? AppTheme.successLight
                          : AppTheme.lightTheme.colorScheme.error,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Құпия сөз',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _passwordController,
          validator: _validatePassword,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Кемінде 8 таңба',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.textMediumEmphasisLight,
                size: 20,
              ),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_passwordController.text.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(right: 1.w),
                    child: CustomIconWidget(
                      iconName: _passwordValid ? 'check_circle' : 'error',
                      color: _passwordValid
                          ? AppTheme.successLight
                          : AppTheme.lightTheme.colorScheme.error,
                      size: 20,
                    ),
                  ),
                IconButton(
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: CustomIconWidget(
                    iconName:
                        _obscurePassword ? 'visibility' : 'visibility_off',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final strength = _getPasswordStrength(_passwordController.text);
    final color = _getPasswordStrengthColor(strength);
    final text = _getPasswordStrengthText(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: strength,
                backgroundColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 0.5.h,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          'Кіші әріп, үлкен әріп және сан қолданыңыз',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
              _validateForm();
            });
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              _acceptTerms = !_acceptTerms;
              _validateForm();
            }),
            child: Padding(
              padding: EdgeInsets.only(top: 2.5.w),
              child: RichText(
                text: TextSpan(
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                  children: [
                    TextSpan(text: 'Мен '),
                    TextSpan(
                      text: 'Қолданушы келісімі',
                      style: TextStyle(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' және '),
                    TextSpan(
                      text: 'Құпиялылық саясатымен',
                      style: TextStyle(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' келісемін'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isFormValid && !widget.isLoading ? _onSubmit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.textDisabledLight,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
        child: widget.isLoading
            ? SizedBox(
                height: 2.5.h,
                width: 2.5.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
                'Тіркелу',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
