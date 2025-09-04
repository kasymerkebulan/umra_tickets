import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TravelerInfoForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;

  const TravelerInfoForm({
    Key? key,
    required this.onDataChanged,
    this.initialData = const {},
  }) : super(key: key);

  @override
  State<TravelerInfoForm> createState() => _TravelerInfoFormState();
}

class _TravelerInfoFormState extends State<TravelerInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  DateTime? _selectedBirthDate;
  String? _selectedGender;

  final List<String> _genderOptions = ['Мужской', 'Женский'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadInitialData();
  }

  void _initializeControllers() {
    final fields = [
      'firstName',
      'lastName',
      'middleName',
      'passportNumber',
      'passportIssueDate',
      'passportExpiry',
      'phoneNumber',
      'email'
    ];

    for (String field in fields) {
      _controllers[field] = TextEditingController();
      _focusNodes[field] = FocusNode();
    }
  }

  void _loadInitialData() {
    if (widget.initialData.isNotEmpty) {
      _controllers['firstName']?.text = widget.initialData['firstName'] ?? '';
      _controllers['lastName']?.text = widget.initialData['lastName'] ?? '';
      _controllers['middleName']?.text = widget.initialData['middleName'] ?? '';
      _controllers['passportNumber']?.text =
          widget.initialData['passportNumber'] ?? '';
      _controllers['phoneNumber']?.text =
          widget.initialData['phoneNumber'] ?? '';
      _controllers['email']?.text = widget.initialData['email'] ?? '';
      _selectedGender = widget.initialData['gender'];

      if (widget.initialData['birthDate'] != null) {
        _selectedBirthDate = DateTime.tryParse(widget.initialData['birthDate']);
      }
    }
  }

  void _notifyDataChanged() {
    final data = {
      'firstName': _controllers['firstName']?.text ?? '',
      'lastName': _controllers['lastName']?.text ?? '',
      'middleName': _controllers['middleName']?.text ?? '',
      'passportNumber': _controllers['passportNumber']?.text ?? '',
      'phoneNumber': _controllers['phoneNumber']?.text ?? '',
      'email': _controllers['email']?.text ?? '',
      'gender': _selectedGender,
      'birthDate': _selectedBirthDate?.toIso8601String(),
    };
    widget.onDataChanged(data);
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    _focusNodes.values.forEach((node) => node.dispose());
    super.dispose();
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.primaryLight,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Информация о путешественнике',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Name fields
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _controllers['firstName']!,
                    focusNode: _focusNodes['firstName']!,
                    label: 'Имя *',
                    validator: (value) =>
                        value?.isEmpty == true ? 'Введите имя' : null,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildTextField(
                    controller: _controllers['lastName']!,
                    focusNode: _focusNodes['lastName']!,
                    label: 'Фамилия *',
                    validator: (value) =>
                        value?.isEmpty == true ? 'Введите фамилию' : null,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            _buildTextField(
              controller: _controllers['middleName']!,
              focusNode: _focusNodes['middleName']!,
              label: 'Отчество',
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 2.h),

            // Gender and Birth Date
            Row(
              children: [
                Expanded(
                  child: _buildGenderDropdown(),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildDateField(),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Passport Information
            Text(
              'Паспортные данные',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textHighEmphasisLight,
              ),
            ),
            SizedBox(height: 1.h),

            _buildTextField(
              controller: _controllers['passportNumber']!,
              focusNode: _focusNodes['passportNumber']!,
              label: 'Номер паспорта *',
              validator: (value) {
                if (value?.isEmpty == true) return 'Введите номер паспорта';
                if (!RegExp(r'^N\d{8}$').hasMatch(value!)) {
                  return 'Формат: N12345678';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[N0-9]')),
                LengthLimitingTextInputFormatter(9),
              ],
            ),
            SizedBox(height: 2.h),

            // Contact Information
            Text(
              'Контактная информация',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textHighEmphasisLight,
              ),
            ),
            SizedBox(height: 1.h),

            _buildTextField(
              controller: _controllers['phoneNumber']!,
              focusNode: _focusNodes['phoneNumber']!,
              label: 'Номер телефона *',
              validator: (value) {
                if (value?.isEmpty == true) return 'Введите номер телефона';
                if (!RegExp(r'^\+7\d{10}$').hasMatch(value!)) {
                  return 'Формат: +77771234567';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\+0-9]')),
                LengthLimitingTextInputFormatter(12),
              ],
            ),
            SizedBox(height: 2.h),

            _buildTextField(
              controller: _controllers['email']!,
              focusNode: _focusNodes['email']!,
              label: 'Email *',
              validator: (value) {
                if (value?.isEmpty == true) return 'Введите email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value!)) {
                  return 'Введите корректный email';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      onChanged: (_) => _notifyDataChanged(),
      decoration: InputDecoration(
        labelText: label,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.errorLight),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(
        labelText: 'Пол *',
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
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      ),
      items: _genderOptions.map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedGender = value;
        });
        _notifyDataChanged();
      },
      validator: (value) => value == null ? 'Выберите пол' : null,
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () => _selectBirthDate(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.dividerLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedBirthDate != null
                    ? '${_selectedBirthDate!.day.toString().padLeft(2, '0')}.${_selectedBirthDate!.month.toString().padLeft(2, '0')}.${_selectedBirthDate!.year}'
                    : 'Дата рождения *',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: _selectedBirthDate != null
                      ? AppTheme.textHighEmphasisLight
                      : AppTheme.textMediumEmphasisLight,
                ),
              ),
            ),
            CustomIconWidget(
              iconName: 'calendar_today',
              color: AppTheme.textMediumEmphasisLight,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(1990),
      firstDate: DateTime(1920),
      lastDate: DateTime.now().subtract(Duration(days: 365 * 18)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primaryLight,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
      _notifyDataChanged();
    }
  }

  bool isValid() {
    return _formKey.currentState?.validate() ?? false;
  }
}
