
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chat_header_widget.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/quick_reply_widget.dart';

class AiChatSupportScreen extends StatefulWidget {
  const AiChatSupportScreen({Key? key}) : super(key: key);

  @override
  State<AiChatSupportScreen> createState() => _AiChatSupportScreenState();
}

class _AiChatSupportScreenState extends State<AiChatSupportScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final Dio _dio = Dio();

  bool _isLoading = false;
  bool _isRecording = false;
  bool _isOnline = true;
  bool _showScrollToBottom = false;
  bool _isTyping = false;

  // Mock conversation data
  final List<Map<String, dynamic>> _mockConversation = [
    {
      "id": 1,
      "message":
          "Assalamu Alaikum! Welcome to Umra Tickets AI Support. I'm here to help you with your pilgrimage journey. How can I assist you today?",
      "isUser": false,
      "timestamp": DateTime.now().subtract(Duration(minutes: 2)),
      "quickReplies": [
        "Check booking status",
        "Payment issues",
        "Tour information",
        "Contact agency"
      ]
    }
  ];

  final List<String> _commonQuickReplies = [
    "Check booking status",
    "Payment issues",
    "Tour information",
    "Contact agency",
    "Visa requirements",
    "Hotel details",
    "Flight information",
    "Refund policy"
  ];

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    setState(() {
      _messages.addAll(_mockConversation);
    });

    // Simulate initial connection
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isOnline = true;
        });
      }
    });
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final showButton = _scrollController.offset > 200;
      if (showButton != _showScrollToBottom) {
        setState(() {
          _showScrollToBottom = showButton;
        });
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    setState(() {
      _messages.add({
        "id": _messages.length + 1,
        "message": message,
        "isUser": true,
        "timestamp": DateTime.now(),
      });
      _isLoading = true;
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Simulate AI processing time
      await Future.delayed(Duration(seconds: 2));

      // Generate AI response based on message content
      final aiResponse = _generateAIResponse(message);

      setState(() {
        _messages.add({
          "id": _messages.length + 1,
          "message": aiResponse["message"],
          "isUser": false,
          "timestamp": DateTime.now(),
          "quickReplies": aiResponse["quickReplies"] ?? [],
        });
        _isLoading = false;
        _isTyping = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add({
          "id": _messages.length + 1,
          "message":
              "I apologize, but I'm experiencing technical difficulties. Please try again in a moment or contact our human support team during business hours (9 AM - 6 PM Kazakhstan time).",
          "isUser": false,
          "timestamp": DateTime.now(),
          "quickReplies": ["Try again", "Contact human support"],
        });
        _isLoading = false;
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  Map<String, dynamic> _generateAIResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    if (message.contains('booking') || message.contains('status')) {
      return {
        "message":
            "I can help you check your booking status. To access your booking information, please provide your booking reference number or the email address used for booking. You can also log into your account to view all your bookings.",
        "quickReplies": [
          "Login to account",
          "Enter booking reference",
          "Contact agency"
        ]
      };
    } else if (message.contains('payment') || message.contains('pay')) {
      return {
        "message":
            "For payment-related queries, I can assist with: checking payment status, understanding payment methods (Kaspi Pay, Halyk Bank, Jusan Bank, ForteBank), or resolving payment issues. What specific payment help do you need?",
        "quickReplies": [
          "Payment methods",
          "Payment failed",
          "Refund request",
          "Receipt copy"
        ]
      };
    } else if (message.contains('tour') ||
        message.contains('umra') ||
        message.contains('package')) {
      return {
        "message":
            "I'd be happy to help you with tour information! Our Umra packages include accommodation, transportation, guided tours, and spiritual guidance. Prices range from 450,000₸ to 1,200,000₸ depending on hotel category and duration. What specific tour details would you like to know?",
        "quickReplies": [
          "View packages",
          "Hotel categories",
          "Departure dates",
          "Inclusions"
        ]
      };
    } else if (message.contains('visa') || message.contains('document')) {
      return {
        "message":
            "For Umra visa requirements from Kazakhstan, you'll need: valid passport (6+ months), completed visa application, passport photos, vaccination certificates, and confirmed booking. Our partner agencies assist with visa processing. Processing time is typically 7-14 days.",
        "quickReplies": [
          "Document checklist",
          "Visa processing",
          "Vaccination info",
          "Agency contact"
        ]
      };
    } else if (message.contains('hotel') || message.contains('accommodation')) {
      return {
        "message":
            "Our Umra packages offer various hotel categories:\n• Economy: 3-star hotels, shared rooms (450,000₸ - 600,000₸)\n• Standard: 4-star hotels, private rooms (700,000₸ - 900,000₸)\n• Premium: 5-star hotels near Haram (1,000,000₸ - 1,200,000₸)\n\nAll include daily breakfast and proximity to holy sites.",
        "quickReplies": [
          "View hotels",
          "Room types",
          "Amenities",
          "Location map"
        ]
      };
    } else if (message.contains('cancel') || message.contains('refund')) {
      return {
        "message":
            "Cancellation and refund policies vary by package and timing:\n• 45+ days before departure: 90% refund\n• 30-44 days: 75% refund\n• 15-29 days: 50% refund\n• Less than 15 days: 25% refund\n\nVisa fees and processing charges are non-refundable. Would you like to proceed with cancellation?",
        "quickReplies": [
          "Cancel booking",
          "Refund calculator",
          "Policy details",
          "Speak to agent"
        ]
      };
    } else if (message.contains('contact') ||
        message.contains('agency') ||
        message.contains('phone')) {
      return {
        "message":
            "You can contact our verified agencies directly:\n• Al-Haramain Tours: +7 727 123 4567\n• Makkah Travel: +7 717 234 5678\n• Blessed Journey: +7 702 345 6789\n\nOr use our in-app messaging to connect with your booked agency. Business hours: 9 AM - 6 PM (Almaty time).",
        "quickReplies": [
          "Call agency",
          "Send message",
          "Business hours",
          "Emergency contact"
        ]
      };
    } else if (message.contains('hello') ||
        message.contains('hi') ||
        message.contains('assalam')) {
      return {
        "message":
            "Wa alaykumu s-salāmu wa-raḥmatu -llāhi wa-barakātuh! Welcome to Umra Tickets support. I'm here to help you with all aspects of your pilgrimage journey. How may I assist you today?",
        "quickReplies": [
          "Browse tours",
          "Check booking",
          "Payment help",
          "Visa info"
        ]
      };
    } else {
      return {
        "message":
            "Thank you for your message. I understand you need assistance, and I'm here to help with all aspects of your Umra journey including bookings, payments, tour information, and travel requirements. Could you please specify what you'd like help with?",
        "quickReplies": _commonQuickReplies.take(4).toList()
      };
    }
  }

  void _handleQuickReply(String reply) {
    _sendMessage(reply);
  }

  void _handleVoiceInput() {
    setState(() {
      _isRecording = !_isRecording;
    });

    // Simulate voice recording
    if (_isRecording) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted && _isRecording) {
          setState(() {
            _isRecording = false;
          });
          _sendMessage("I need help with my booking status");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          ChatHeaderWidget(
            onClose: () => Navigator.pop(context),
            isOnline: _isOnline,
          ),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isTyping) {
                      return ChatMessageWidget(
                        message: "",
                        isUser: false,
                        timestamp: DateTime.now(),
                        isTyping: true,
                      );
                    }

                    final message = _messages[index];
                    return Column(
                      children: [
                        ChatMessageWidget(
                          message: message["message"] as String,
                          isUser: message["isUser"] as bool,
                          timestamp: message["timestamp"] as DateTime,
                        ),
                        if (!message["isUser"] &&
                            message["quickReplies"] != null &&
                            (message["quickReplies"] as List).isNotEmpty &&
                            index == _messages.length - 1)
                          QuickReplyWidget(
                            quickReplies:
                                List<String>.from(message["quickReplies"]),
                            onQuickReplyTap: _handleQuickReply,
                          ),
                      ],
                    );
                  },
                ),
                if (_showScrollToBottom)
                  Positioned(
                    right: 4.w,
                    bottom: 2.h,
                    child: FloatingActionButton.small(
                      onPressed: _scrollToBottom,
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      child: CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 5.w,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ChatInputWidget(
            messageController: _messageController,
            onSendMessage: _sendMessage,
            onVoiceInput: _handleVoiceInput,
            isRecording: _isRecording,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
