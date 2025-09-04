import 'package:flutter/material.dart';
import '../presentation/booking_flow_screen/booking_flow_screen.dart';
import '../presentation/tour_browse_screen/tour_browse_screen.dart';
import '../presentation/tour_detail_screen/tour_detail_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/ai_chat_support_screen/ai_chat_support_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String bookingFlow = '/booking-flow-screen';
  static const String tourBrowse = '/tour-browse-screen';
  static const String tourDetail = '/tour-detail-screen';
  static const String login = '/login-screen';
  static const String registration = '/registration-screen';
  static const String aiChatSupport = '/ai-chat-support-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    bookingFlow: (context) => const BookingFlowScreen(),
    tourBrowse: (context) => const TourBrowseScreen(),
    tourDetail: (context) => const TourDetailScreen(),
    login: (context) => const LoginScreen(),
    registration: (context) => const RegistrationScreen(),
    aiChatSupport: (context) => const AiChatSupportScreen(),
    // TODO: Add your other routes here
  };
}
