import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatInputWidget extends StatefulWidget {
  final TextEditingController messageController;
  final Function(String) onSendMessage;
  final VoidCallback onVoiceInput;
  final bool isRecording;
  final bool isLoading;

  const ChatInputWidget({
    Key? key,
    required this.messageController,
    required this.onSendMessage,
    required this.onVoiceInput,
    this.isRecording = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.messageController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = widget.messageController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(6.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.messageController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.textDisabledLight,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                        ),
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                        maxLines: 4,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: _hasText
                            ? (value) {
                                if (value.trim().isNotEmpty) {
                                  widget.onSendMessage(value.trim());
                                }
                              }
                            : null,
                      ),
                    ),
                    InkWell(
                      onTap: widget.onVoiceInput,
                      borderRadius: BorderRadius.circular(6.w),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        child: CustomIconWidget(
                          iconName: widget.isRecording ? 'stop' : 'mic',
                          color: widget.isRecording
                              ? AppTheme.errorLight
                              : AppTheme.lightTheme.primaryColor,
                          size: 5.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 2.w),
            InkWell(
              onTap: _hasText && !widget.isLoading
                  ? () {
                      final message = widget.messageController.text.trim();
                      if (message.isNotEmpty) {
                        widget.onSendMessage(message);
                      }
                    }
                  : null,
              borderRadius: BorderRadius.circular(6.w),
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: _hasText && !widget.isLoading
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.textDisabledLight,
                  shape: BoxShape.circle,
                  boxShadow: _hasText && !widget.isLoading
                      ? [
                          BoxShadow(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: widget.isLoading
                    ? SizedBox(
                        width: 4.w,
                        height: 4.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'send',
                        color: _hasText
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                        size: 5.w,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
