import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/search_header_widget.dart';
import './widgets/skeleton_card_widget.dart';
import './widgets/tour_card_widget.dart';

class TourBrowseScreen extends StatefulWidget {
  const TourBrowseScreen({Key? key}) : super(key: key);

  @override
  State<TourBrowseScreen> createState() => _TourBrowseScreenState();
}

class _TourBrowseScreenState extends State<TourBrowseScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _tours = [];
  List<Map<String, dynamic>> _filteredTours = [];
  Set<String> _favoriteTours = {};
  Map<String, dynamic> _activeFilters = {};
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentNavIndex = 0;
  String _sortBy = 'price';

  @override
  void initState() {
    super.initState();
    _loadTours();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadTours() {
    setState(() {
      _isLoading = true;
    });

    // Mock tour data with Kazakhstan-specific content
    final List<Map<String, dynamic>> mockTours = [
      {
        "id": 1,
        "name": "Premium Umra Package - Makkah & Madinah",
        "description":
            "Complete spiritual journey with 5-star accommodation and guided tours",
        "price": "₸ 650,000",
        "departureCity": "Almaty",
        "duration": "14 days",
        "agencyName": "Nur Travel Kazakhstan",
        "isVerified": true,
        "rating": 4.8,
        "image":
            "https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "hotelCategory": "5 Star",
        "departureDate": DateTime.now().add(Duration(days: 30)),
      },
      {
        "id": 2,
        "name": "Economy Umra Tour - Budget Friendly",
        "description":
            "Affordable pilgrimage package with comfortable 3-star hotels",
        "price": "₸ 420,000",
        "departureCity": "Nur-Sultan",
        "duration": "10 days",
        "agencyName": "Barakah Tours",
        "isVerified": true,
        "rating": 4.5,
        "image":
            "https://images.unsplash.com/photo-1564769662533-4f00a87b4056?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "hotelCategory": "3 Star",
        "departureDate": DateTime.now().add(Duration(days: 45)),
      },
      {
        "id": 3,
        "name": "Deluxe Umra Experience - VIP Service",
        "description":
            "Luxury pilgrimage with private transportation and premium services",
        "price": "₸ 850,000",
        "departureCity": "Almaty",
        "duration": "16 days",
        "agencyName": "Hajj & Umra Services KZ",
        "isVerified": true,
        "rating": 4.9,
        "image":
            "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "hotelCategory": "5 Star",
        "departureDate": DateTime.now().add(Duration(days: 20)),
      },
      {
        "id": 4,
        "name": "Family Umra Package - Special Rates",
        "description":
            "Perfect for families with children, includes special arrangements",
        "price": "₸ 580,000",
        "departureCity": "Shymkent",
        "duration": "12 days",
        "agencyName": "Islamic Travel Kazakhstan",
        "isVerified": false,
        "rating": 4.3,
        "image":
            "https://images.unsplash.com/photo-1542816417-0983c9c9ad53?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "hotelCategory": "4 Star",
        "departureDate": DateTime.now().add(Duration(days: 60)),
      },
      {
        "id": 5,
        "name": "Express Umra - Quick Pilgrimage",
        "description":
            "Short but complete Umra experience for busy professionals",
        "price": "₸ 380,000",
        "departureCity": "Almaty",
        "duration": "7 days",
        "agencyName": "Swift Pilgrimage Tours",
        "isVerified": true,
        "rating": 4.2,
        "image":
            "https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "hotelCategory": "4 Star",
        "departureDate": DateTime.now().add(Duration(days: 15)),
      },
      {
        "id": 6,
        "name": "Senior Citizens Umra - Comfort Plus",
        "description":
            "Specially designed for elderly pilgrims with medical support",
        "price": "₸ 720,000",
        "departureCity": "Nur-Sultan",
        "duration": "15 days",
        "agencyName": "Care Pilgrimage Services",
        "isVerified": true,
        "rating": 4.7,
        "image":
            "https://images.unsplash.com/photo-1564769662533-4f00a87b4056?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "hotelCategory": "5 Star",
        "departureDate": DateTime.now().add(Duration(days: 40)),
      },
    ];

    // Simulate network delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _tours = mockTours;
        _filteredTours = List.from(_tours);
        _isLoading = false;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreTours();
    }
  }

  void _loadMoreTours() {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more tours
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoadingMore = false;
      });
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTours = List.from(_tours);
      } else {
        _filteredTours = _tours.where((tour) {
          final name = (tour['name'] as String).toLowerCase();
          final agency = (tour['agencyName'] as String).toLowerCase();
          final city = (tour['departureCity'] as String).toLowerCase();
          final searchQuery = query.toLowerCase();

          return name.contains(searchQuery) ||
              agency.contains(searchQuery) ||
              city.contains(searchQuery);
        }).toList();
      }
    });
  }

  void _onFilterPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        currentFilters: _activeFilters,
        onFiltersChanged: _applyFilters,
      ),
    );
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
      _filteredTours = _tours.where((tour) {
        // Price filter
        if (filters['minPrice'] != null && filters['maxPrice'] != null) {
          final priceStr = (tour['price'] as String)
              .replaceAll('₸ ', '')
              .replaceAll(',', '');
          final price = double.tryParse(priceStr) ?? 0;
          if (price < filters['minPrice'] || price > filters['maxPrice']) {
            return false;
          }
        }

        // City filter
        if (filters['city'] != null &&
            tour['departureCity'] != filters['city']) {
          return false;
        }

        // Hotel category filter
        if (filters['hotelCategory'] != null &&
            tour['hotelCategory'] != filters['hotelCategory']) {
          return false;
        }

        // Date range filter
        if (filters['dateRange'] != null) {
          final dateRange = filters['dateRange'] as DateTimeRange;
          final tourDate = tour['departureDate'] as DateTime;
          if (tourDate.isBefore(dateRange.start) ||
              tourDate.isAfter(dateRange.end)) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String tourId) {
    setState(() {
      if (_favoriteTours.contains(tourId)) {
        _favoriteTours.remove(tourId);
      } else {
        _favoriteTours.add(tourId);
      }
    });
  }

  void _onTourTap(Map<String, dynamic> tour) {
    Navigator.pushNamed(context, '/tour-detail-screen', arguments: tour);
  }

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    // Navigate to different screens based on index
    switch (index) {
      case 0:
        // Already on browse screen
        break;
      case 1:
        // Navigate to favorites (not implemented in this screen)
        break;
      case 2:
        Navigator.pushNamed(context, '/booking-flow-screen');
        break;
      case 3:
        // Navigate to profile (not implemented in this screen)
        break;
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Sort Tours By',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildSortOption('Price: Low to High', 'price'),
            _buildSortOption('Price: High to Low', 'price_desc'),
            _buildSortOption('Duration', 'duration'),
            _buildSortOption('Rating', 'rating'),
            _buildSortOption('Departure Date', 'date'),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: _sortBy == value ? FontWeight.w600 : FontWeight.w400,
          color: _sortBy == value
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      trailing: _sortBy == value
          ? CustomIconWidget(
              iconName: 'check',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            )
          : null,
      onTap: () {
        setState(() {
          _sortBy = value;
          _sortTours();
        });
        Navigator.pop(context);
      },
    );
  }

  void _sortTours() {
    setState(() {
      switch (_sortBy) {
        case 'price':
          _filteredTours.sort((a, b) {
            final priceA = double.tryParse((a['price'] as String)
                    .replaceAll('₸ ', '')
                    .replaceAll(',', '')) ??
                0;
            final priceB = double.tryParse((b['price'] as String)
                    .replaceAll('₸ ', '')
                    .replaceAll(',', '')) ??
                0;
            return priceA.compareTo(priceB);
          });
          break;
        case 'price_desc':
          _filteredTours.sort((a, b) {
            final priceA = double.tryParse((a['price'] as String)
                    .replaceAll('₸ ', '')
                    .replaceAll(',', '')) ??
                0;
            final priceB = double.tryParse((b['price'] as String)
                    .replaceAll('₸ ', '')
                    .replaceAll(',', '')) ??
                0;
            return priceB.compareTo(priceA);
          });
          break;
        case 'rating':
          _filteredTours.sort((a, b) =>
              (b['rating'] as double).compareTo(a['rating'] as double));
          break;
        case 'duration':
          _filteredTours.sort((a, b) {
            final durationA =
                int.tryParse((a['duration'] as String).split(' ')[0]) ?? 0;
            final durationB =
                int.tryParse((b['duration'] as String).split(' ')[0]) ?? 0;
            return durationA.compareTo(durationB);
          });
          break;
        case 'date':
          _filteredTours.sort((a, b) => (a['departureDate'] as DateTime)
              .compareTo(b['departureDate'] as DateTime));
          break;
      }
    });
  }

  int get _activeFilterCount {
    int count = 0;
    if (_activeFilters['city'] != null) count++;
    if (_activeFilters['hotelCategory'] != null) count++;
    if (_activeFilters['dateRange'] != null) count++;
    if (_activeFilters['minPrice'] != null &&
        _activeFilters['maxPrice'] != null) {
      if (_activeFilters['minPrice'] != 200000 ||
          _activeFilters['maxPrice'] != 800000) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          SearchHeaderWidget(
            searchController: _searchController,
            onFilterPressed: _onFilterPressed,
            filterCount: _activeFilterCount,
            onSearchChanged: _onSearchChanged,
          ),
          if (_activeFilterCount > 0) _buildActiveFilters(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _loadTours();
              },
              color: AppTheme.lightTheme.colorScheme.primary,
              child: _buildToursList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSortOptions,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'sort',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (_activeFilters['city'] != null)
            FilterChipWidget(
              label: _activeFilters['city'],
              isSelected: true,
              onTap: () {
                setState(() {
                  _activeFilters.remove('city');
                  _applyFilters(_activeFilters);
                });
              },
              iconName: 'location_on',
            ),
          if (_activeFilters['hotelCategory'] != null)
            FilterChipWidget(
              label: _activeFilters['hotelCategory'],
              isSelected: true,
              onTap: () {
                setState(() {
                  _activeFilters.remove('hotelCategory');
                  _applyFilters(_activeFilters);
                });
              },
              iconName: 'star',
            ),
          if (_activeFilters['dateRange'] != null)
            FilterChipWidget(
              label: 'Custom Dates',
              isSelected: true,
              onTap: () {
                setState(() {
                  _activeFilters.remove('dateRange');
                  _applyFilters(_activeFilters);
                });
              },
              iconName: 'calendar_today',
            ),
          if (_activeFilters['minPrice'] != null &&
              _activeFilters['maxPrice'] != null)
            if (_activeFilters['minPrice'] != 200000 ||
                _activeFilters['maxPrice'] != 800000)
              FilterChipWidget(
                label: 'Price Range',
                isSelected: true,
                onTap: () {
                  setState(() {
                    _activeFilters.remove('minPrice');
                    _activeFilters.remove('maxPrice');
                    _applyFilters(_activeFilters);
                  });
                },
                iconName: 'attach_money',
              ),
        ],
      ),
    );
  }

  Widget _buildToursList() {
    if (_isLoading) {
      return ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) => SkeletonCardWidget(),
      );
    }

    if (_filteredTours.isEmpty) {
      return EmptyStateWidget(
        title: 'No Tours Found',
        subtitle:
            'Try adjusting your search criteria or filters to find more tours.',
        buttonText: 'Clear Filters',
        onButtonPressed: () {
          setState(() {
            _activeFilters.clear();
            _searchController.clear();
            _filteredTours = List.from(_tours);
          });
        },
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _filteredTours.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _filteredTours.length) {
          return Padding(
            padding: EdgeInsets.all(4.w),
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          );
        }

        final tour = _filteredTours[index];
        final tourId = tour['id'].toString();

        return TourCardWidget(
          tour: tour,
          isFavorite: _favoriteTours.contains(tourId),
          onTap: () => _onTourTap(tour),
          onFavoritePressed: () => _toggleFavorite(tourId),
          onSharePressed: () {
            // Share functionality would be implemented here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Share feature coming soon!'),
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              ),
            );
          },
          onComparePressed: () {
            // Compare functionality would be implemented here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Compare feature coming soon!'),
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              ),
            );
          },
        );
      },
    );
  }
}
