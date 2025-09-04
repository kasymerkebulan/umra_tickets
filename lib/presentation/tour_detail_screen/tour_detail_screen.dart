import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/tour_agency_widget.dart';
import './widgets/tour_booking_bar_widget.dart';
import './widgets/tour_hotel_widget.dart';
import './widgets/tour_image_carousel_widget.dart';
import './widgets/tour_itinerary_widget.dart';
import './widgets/tour_pricing_widget.dart';
import './widgets/tour_reviews_widget.dart';
import './widgets/tour_services_widget.dart';
import './widgets/tour_sticky_header_widget.dart';

class TourDetailScreen extends StatefulWidget {
  const TourDetailScreen({Key? key}) : super(key: key);

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showStickyHeader = false;
  bool _isFavorite = false;

  // Mock tour data
  final Map<String, dynamic> tourData = {
    "id": 1,
    "name": "Умра Премиум - Мекка и Медина",
    "description":
        "Священное паломничество в святые города Мекка и Медина с комфортным размещением и полным сопровождением опытных гидов.",
    "price": "850 000",
    "originalPrice": "950 000",
    "currency": "₸",
    "duration": "14 дней",
    "departureCity": "Алматы",
    "images": [
      "https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1564769625392-651b2c0b8b1b?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1580418827493-f2b22c0a76cb?w=800&h=600&fit=crop",
    ],
    "paymentPlans": [
      {
        "icon": "payment",
        "title": "Полная оплата",
        "description": "Единовременная оплата со скидкой 5%",
        "amount": "₸ 807 500"
      },
      {
        "icon": "schedule",
        "title": "Рассрочка 3 месяца",
        "description": "Без переплат и процентов",
        "amount": "₸ 283 333/мес"
      },
      {
        "icon": "credit_card",
        "title": "Рассрочка 6 месяцев",
        "description": "Минимальная переплата 2%",
        "amount": "₸ 144 500/мес"
      }
    ],
    "itinerary": [
      {
        "day": 1,
        "title": "Прибытие в Джедду - Мекка",
        "description":
            "Встреча в аэропорту Джедды, трансфер в Мекку, размещение в отеле, первое знакомство со святыми местами.",
        "islamicSites": ["Масджид аль-Харам", "Кааба"]
      },
      {
        "day": 2,
        "title": "Умра и посещение святых мест Мекки",
        "description":
            "Совершение Умры под руководством опытного гида, посещение исторических мест, связанных с пророком Мухаммадом (мир ему).",
        "islamicSites": ["Сафа и Марва", "Замзам", "Мультазам"]
      },
      {
        "day": 3,
        "title": "Исторические места Мекки",
        "description":
            "Посещение пещеры Хира, горы Нур, музея двух святых мечетей, изучение истории ислама.",
        "islamicSites": ["Пещера Хира", "Гора Нур", "Джабаль ан-Нур"]
      },
      {
        "day": 4,
        "title": "Переезд в Медину",
        "description":
            "Трансфер в Медину, размещение в отеле рядом с Масджид ан-Набави, первое посещение мечети Пророка.",
        "islamicSites": ["Масджид ан-Набави", "Равда аш-Шарифа"]
      },
      {
        "day": 5,
        "title": "Святые места Медины",
        "description":
            "Посещение могилы Пророка, мечети Куба, кладбища Джаннат аль-Баки, изучение истории раннего ислама.",
        "islamicSites": [
          "Масджид Куба",
          "Джаннат аль-Баки",
          "Масджид аль-Кибла"
        ]
      }
    ],
    "includedServices": [
      {
        "icon": "flight",
        "title": "Авиаперелет",
        "description": "Прямые рейсы Алматы-Джедда-Алматы"
      },
      {
        "icon": "hotel",
        "title": "Проживание",
        "description": "4* отели рядом с Харамом"
      },
      {
        "icon": "restaurant",
        "title": "Питание",
        "description": "Завтраки и ужины (халяль)"
      },
      {
        "icon": "directions_bus",
        "title": "Трансферы",
        "description": "Все переезды на комфортабельном транспорте"
      },
      {
        "icon": "person",
        "title": "Гид",
        "description": "Опытный русскоговорящий гид"
      },
      {
        "icon": "medical_services",
        "title": "Страховка",
        "description": "Медицинская страховка на весь период"
      }
    ],
    "excludedServices": [
      {
        "icon": "shopping_bag",
        "title": "Личные покупки",
        "description": "Сувениры и личные расходы"
      },
      {
        "icon": "local_laundry_service",
        "title": "Прачечная",
        "description": "Услуги прачечной в отеле"
      },
      {
        "icon": "phone",
        "title": "Связь",
        "description": "Международные звонки и интернет"
      }
    ],
    "hotelInfo": {
      "name": "Makkah Towers Hotel",
      "rating": 4,
      "location": "В 200 метрах от Масджид аль-Харам",
      "distanceToHaram": "2 минуты пешком до Харама",
      "image":
          "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&h=400&fit=crop",
      "description":
          "Современный отель с видом на Каабу, предлагающий комфортабельные номера и высокий уровень сервиса для паломников.",
      "amenities": [
        {"icon": "wifi", "name": "Wi-Fi"},
        {"icon": "ac_unit", "name": "Кондиционер"},
        {"icon": "restaurant", "name": "Ресторан"},
        {"icon": "local_laundry_service", "name": "Прачечная"},
        {"icon": "elevator", "name": "Лифт"},
        {"icon": "room_service", "name": "Room Service"}
      ]
    },
    "agencyInfo": {
      "name": "Хадж Тур Казахстан",
      "logo":
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200&h=200&fit=crop",
      "rating": 4.8,
      "experience": 15,
      "toursCount": 247,
      "isVerified": true,
      "description":
          "Ведущее туристическое агентство Казахстана, специализирующееся на религиозных турах. Более 15 лет успешно организуем паломничества в святые места ислама."
    },
    "reviews": [
      {
        "userName": "Айгуль Нурланова",
        "rating": 5,
        "date": "15 ноября 2024",
        "comment":
            "Прекрасно организованный тур! Гид был очень знающим, отели комфортные, все прошло без проблем. Рекомендую всем, кто планирует Умру.",
        "helpfulCount": 12
      },
      {
        "userName": "Ерлан Касымов",
        "rating": 5,
        "date": "8 ноября 2024",
        "comment":
            "Спасибо агентству за незабываемое духовное путешествие. Все было организовано на высшем уровне, особенно понравилось внимание к деталям.",
        "helpfulCount": 8
      },
      {
        "userName": "Гульнара Абдуллаева",
        "rating": 4,
        "date": "2 ноября 2024",
        "comment":
            "Хороший тур, но хотелось бы больше времени в Медине. В целом остались довольны, агентство работает профессионально.",
        "helpfulCount": 5
      }
    ],
    "averageRating": 4.8,
    "totalReviews": 156
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showHeader = _scrollController.offset > 30.h;
    if (showHeader != _showStickyHeader) {
      setState(() {
        _showStickyHeader = showHeader;
      });
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  void _onBookNow() {
    // Check authentication first
    _checkAuthenticationAndProceed(() {
      Navigator.pushNamed(context, '/booking-flow-screen');
    });
  }

  void _onContactAgency() {
    Navigator.pushNamed(context, '/ai-chat-support-screen');
  }

  void _onShareTour() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Функция "Поделиться" будет доступна в следующем обновлении'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _checkAuthenticationAndProceed(VoidCallback onAuthenticated) {
    // Mock authentication check
    bool isAuthenticated = false; // This would be actual auth check

    if (isAuthenticated) {
      onAuthenticated();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Требуется авторизация',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Для бронирования тура необходимо войти в систему или зарегистрироваться.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login-screen');
              },
              child: Text('Войти'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Image carousel
              SliverToBoxAdapter(
                child: TourImageCarouselWidget(
                  images: (tourData['images'] as List).cast<String>(),
                  tourName: tourData['name'] as String,
                ),
              ),

              // Content sections
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tour title and basic info
                      Text(
                        tourData['name'] as String,
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: 1.h),

                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme.textMediumEmphasisLight,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            tourData['duration'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.textMediumEmphasisLight,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          CustomIconWidget(
                            iconName: 'flight_takeoff',
                            color: AppTheme.textMediumEmphasisLight,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'из ${tourData['departureCity']}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.textMediumEmphasisLight,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      Text(
                        tourData['description'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Pricing section
                      TourPricingWidget(
                        price: tourData['price'] as String,
                        originalPrice: tourData['originalPrice'] as String,
                        currency: tourData['currency'] as String,
                        paymentPlans: (tourData['paymentPlans'] as List)
                            .cast<Map<String, dynamic>>(),
                      ),

                      SizedBox(height: 3.h),

                      // Itinerary section
                      TourItineraryWidget(
                        itinerary: (tourData['itinerary'] as List)
                            .cast<Map<String, dynamic>>(),
                      ),

                      SizedBox(height: 3.h),

                      // Services section
                      TourServicesWidget(
                        includedServices: (tourData['includedServices'] as List)
                            .cast<Map<String, dynamic>>(),
                        excludedServices: (tourData['excludedServices'] as List)
                            .cast<Map<String, dynamic>>(),
                      ),

                      SizedBox(height: 3.h),

                      // Hotel section
                      TourHotelWidget(
                        hotelInfo:
                            tourData['hotelInfo'] as Map<String, dynamic>,
                      ),

                      SizedBox(height: 3.h),

                      // Agency section
                      TourAgencyWidget(
                        agencyInfo:
                            tourData['agencyInfo'] as Map<String, dynamic>,
                        onContactAgency: _onContactAgency,
                      ),

                      SizedBox(height: 3.h),

                      // Reviews section
                      TourReviewsWidget(
                        reviews: (tourData['reviews'] as List)
                            .cast<Map<String, dynamic>>(),
                        averageRating: tourData['averageRating'] as double,
                        totalReviews: tourData['totalReviews'] as int,
                      ),

                      // Bottom spacing for booking bar
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky header
          if (_showStickyHeader)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TourStickyHeaderWidget(
                tourName: tourData['name'] as String,
                isFavorite: _isFavorite,
                onFavoriteToggle: _toggleFavorite,
                onBackPressed: _onBackPressed,
              ),
            ),

          // Booking bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: TourBookingBarWidget(
              price: tourData['price'] as String,
              currency: tourData['currency'] as String,
              onBookNow: _onBookNow,
              onContactAgency: _onContactAgency,
              onShareTour: _onShareTour,
            ),
          ),
        ],
      ),
    );
  }
}
