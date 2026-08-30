import 'dart:async';
import 'package:book_ease/core/di/service_locator.dart';
import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:book_ease/features/provider_services/data/models/service_model.dart';
import 'package:book_ease/features/provider_services/data/repo/provider_services_repo.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:book_ease/features/service_details/presentation/views/service_details_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  StreamSubscription<List<BookingModel>>? _bookingsSubscription;
  StreamSubscription<List<ServiceModel>>? _servicesSubscription;

  BookingModel? _nextBooking;
  List<ServiceModel> _firestoreServices = [];
  String _selectedCategory = "All";
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _bookmarkedDoctors = {};

  final List<String> _categories = const [
    "All",
    "Cardiology",
    "Dermatology",
    "Dentist",
    "General",
    "Neurology",
  ];

  // Default curated doctors matching the design mockup if Firestore has few or no items
  final List<Map<String, dynamic>> _mockDoctors = const [
    {
      "id": "doc_1",
      "name": "Dr. Jenny Watson",
      "specialty": "Cardiologist",
      "category": "Cardiology",
      "rating": 4.9,
      "reviews": 190,
      "price": 85.0,
      "image":
          "https://images.unsplash.com/photo-1594824813588-466d7e0c4f8d?auto=format&fit=crop&q=80&w=400",
      "about":
          "Dr. Jenny Watson is a top-rated cardiologist with over 12 years of experience in cardiovascular wellness, heart disease prevention, and non-invasive cardiac imaging.",
      "location": "City Heart Clinic • 1.5 km",
    },
    {
      "id": "doc_2",
      "name": "Dr. Ali Khan",
      "specialty": "Cardiologist",
      "category": "Cardiology",
      "rating": 4.8,
      "reviews": 142,
      "price": 90.0,
      "image":
          "https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=400",
      "about":
          "Dr. Ali Khan specializes in adult cardiology, heart rhythm diagnostics, and hypertension management with cutting-edge medical protocols.",
      "location": "Central Medical Hospital • 2.1 km",
    },
    {
      "id": "doc_3",
      "name": "Dr. Sarah Mitchell",
      "specialty": "Dermatologist",
      "category": "Dermatology",
      "rating": 4.9,
      "reviews": 215,
      "price": 75.0,
      "image":
          "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=400",
      "about":
          "Board-certified dermatologist focusing on advanced skin health, medical dermatology, and modern laser therapy.",
      "location": "Derma Care Pavilion • 0.8 km",
    },
    {
      "id": "doc_4",
      "name": "Dr. Michael Chen",
      "specialty": "Dental Specialist",
      "category": "Dentist",
      "rating": 4.7,
      "reviews": 98,
      "price": 60.0,
      "image":
          "https://images.unsplash.com/photo-1537368910025-700350fe46c7?auto=format&fit=crop&q=80&w=400",
      "about":
          "Experienced dental surgeon specializing in cosmetic dentistry, painless root canals, and teeth restoration.",
      "location": "Smile Dental Center • 3.2 km",
    },
    {
      "id": "doc_5",
      "name": "Dr. Emily Stone",
      "specialty": "General Practitioner",
      "category": "General",
      "rating": 4.9,
      "reviews": 310,
      "price": 50.0,
      "image":
          "https://images.unsplash.com/photo-1527613426441-4da17471b66d?auto=format&fit=crop&q=80&w=400",
      "about":
          "Family physician providing comprehensive primary healthcare, preventative checkups, and chronic disease support.",
      "location": "Community Care Center • 1.0 km",
    },
  ];

  @override
  void initState() {
    super.initState();
    _subscribeData();
  }

  void _subscribeData() {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (uid.isNotEmpty) {
      final bookingRepo = sl<BookingRepo>();
      _bookingsSubscription =
          bookingRepo.getUserBookingsStream(uid).listen((bookings) {
        if (!mounted) return;
        final now = DateTime.now();
        final todayStart = DateTime(now.year, now.month, now.day);

        final upcoming = bookings.where((b) {
          final bDate = DateTime(
            b.bookingDate.year,
            b.bookingDate.month,
            b.bookingDate.day,
          );
          return (bDate.isAfter(todayStart) ||
                  bDate.isAtSameMomentAs(todayStart)) &&
              b.status.toLowerCase() != "cancelled";
        }).toList();

        setState(() {
          _nextBooking = upcoming.isNotEmpty ? upcoming.first : null;
        });
      }, onError: (_) {});
    }

    final servicesRepo = sl<ProviderServicesRepo>();
    _servicesSubscription =
        servicesRepo.getAllActiveServicesStream().listen((services) {
      if (!mounted) return;
      setState(() {
        _firestoreServices = services;
      });
    }, onError: (_) {});
  }

  @override
  void dispose() {
    _bookingsSubscription?.cancel();
    _servicesSubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  ServiceDetailsModel _serviceModelToDetails(ServiceModel s) {
    return ServiceDetailsModel(
      serviceId: s.id ?? s.title,
      providerId: s.providerId,
      providerImage: s.providerImage,
      title: s.title,
      providerName: s.providerName ?? "Dr. Specialist",
      location: "Cairo Clinic • 1.2 km",
      rating: s.rating,
      reviewsCount: s.reviewsCount,
      price: s.price,
      priceUnit: s.priceUnit,
      imageUrl: (s.imageUrl != null && s.imageUrl!.isNotEmpty)
          ? s.imageUrl!
          : "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=800",
      aboutText: s.description.isNotEmpty
          ? s.description
          : "Experienced medical specialist dedicated to providing first-class patient care.",
      specialties: s.specialties.isNotEmpty
          ? s.specialties
          : [s.category, "Consultation", "Care"],
      availableDates: mockServiceDetails.availableDates,
      availableTimes: mockServiceDetails.availableTimes,
    );
  }

  ServiceDetailsModel _mockToDetails(Map<String, dynamic> doc) {
    return ServiceDetailsModel(
      serviceId: doc["id"],
      providerId: doc["id"],
      providerImage: doc["image"],
      title: "${doc['specialty']} Consultation",
      providerName: doc["name"],
      location: doc["location"],
      rating: (doc["rating"] as num).toDouble(),
      reviewsCount: doc["reviews"],
      price: (doc["price"] as num).toDouble(),
      priceUnit: "per visit",
      imageUrl: doc["image"],
      aboutText: doc["about"],
      specialties: [doc["category"], "Consultation", "Specialist"],
      availableDates: mockServiceDetails.availableDates,
      availableTimes: mockServiceDetails.availableTimes,
    );
  }

  String _getUserName(UserCubitState state) {
    if (state is UserDataLoaded) {
      return state.userData['name'] ?? '';
    }
    return '';
  }

  String _getUserPhoto(UserCubitState state) {
    if (state is UserDataLoaded) {
      return state.userData['photoUrl'] ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();

    // Prepare combined list of doctors
    List<ServiceDetailsModel> allDoctors = [];

    if (_firestoreServices.isNotEmpty) {
      allDoctors = _firestoreServices.map(_serviceModelToDetails).toList();
    } else {
      allDoctors = _mockDoctors.map(_mockToDetails).toList();
    }

    // Filter by Category and Search query
    final filteredDoctors = allDoctors.where((doc) {
      final matchesCategory = _selectedCategory == "All" ||
          doc.specialties.any(
              (s) => s.toLowerCase().contains(_selectedCategory.toLowerCase())) ||
          doc.title.toLowerCase().contains(_selectedCategory.toLowerCase());

      final matchesQuery = query.isEmpty ||
          doc.providerName.toLowerCase().contains(query) ||
          doc.title.toLowerCase().contains(query) ||
          doc.aboutText.toLowerCase().contains(query) ||
          doc.specialties.any((s) => s.toLowerCase().contains(query));

      return matchesCategory && matchesQuery;
    }).toList();

    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, userState) {
        final userName = _getUserName(userState);
        final userPhoto = _getUserPhoto(userState);

        return SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Row (Avatar + Greeting + Notification Bell)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // User Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.border,
                              width: 1.5,
                            ),
                            image: userPhoto.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(userPhoto),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: NetworkImage(
                                      "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=200",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const Gap(12),
                        // Greeting Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Good morning!",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(2),
                            Text(
                              userName.isNotEmpty ? userName : "David Gale",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Notification Bell Button
                    ScaleOnTap(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.notifications);
                      },
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.border,
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: .04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.notifications_none_rounded,
                              color: AppColors.textPrimary,
                              size: 22,
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.accentAmber,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(22),

                // 2. Large Bold Typography Headline
                const Text(
                  "How are your feeling\ntoday?",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.2,
                    letterSpacing: -0.6,
                  ),
                ),

                const Gap(20),

                // 3. Search Pill Bar
                Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.border, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: .03),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: AppColors.textMuted,
                        size: 22,
                      ),
                      const Gap(12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: "Search a doctor, medicins, etc...",
                            hintStyle: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.mic_none_rounded,
                        color: AppColors.textMuted,
                        size: 22,
                      ),
                    ],
                  ),
                ),

                const Gap(26),

                // 4. Upcoming Appointments Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Upcoming Appointments",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    ScaleOnTap(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.booking);
                      },
                      child: const Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(14),

                // Upcoming Appointment Card (Solid Vibrant Blue)
                _buildUpcomingAppointmentCard(context),

                const Gap(28),

                // 5. Popular Doctors Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Popular Doctors",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    ScaleOnTap(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.booking);
                      },
                      child: const Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(16),

                // Horizontal Category Filter Pills
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => const Gap(10),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat;
                      return ScaleOnTap(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: .25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Gap(18),

                // Popular Doctors List Cards
                if (filteredDoctors.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredDoctors.length,
                    separatorBuilder: (context, index) => const Gap(14),
                    itemBuilder: (context, index) {
                      final doc = filteredDoctors[index];
                      return _buildDoctorCard(context, doc);
                    },
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.search_off_rounded,
                          size: 40,
                          color: AppColors.textMuted,
                        ),
                        Gap(10),
                        Text(
                          "No doctors found",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Gap(4),
                        Text(
                          "Try searching for another specialty or name",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpcomingAppointmentCard(BuildContext context) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    const days = [
      "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
    ];

    if (_nextBooking != null) {
      final bDate = _nextBooking!.bookingDate;
      final dateStr =
          "${bDate.day} ${months[bDate.month - 1]}, ${days[bDate.weekday - 1]}";
      final timeStr = _nextBooking!.bookingTime;
      final doctorName = (_nextBooking!.providerName != null &&
              _nextBooking!.providerName!.isNotEmpty)
          ? _nextBooking!.providerName!
          : (_nextBooking!.serviceTitle ?? "Dr. Jenny Wilson");
      final specialty = _nextBooking!.serviceTitle ?? "General Practitioner";

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .28),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Row: Doctor Avatar + Name/Specialty + Video Call Button
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1594824813588-466d7e0c4f8d?auto=format&fit=crop&q=80&w=200",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const Gap(3),
                      Text(
                        specialty,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .85),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Video Call Circle Button
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.videocam_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),

            const Gap(16),

            // Middle Row: Date & Time Translucent Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Date
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .75),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              dateStr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 28,
                    color: Colors.white.withValues(alpha: .25),
                  ),
                  const Gap(14),
                  // Time
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Time",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .75),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              timeStr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Gap(16),

            // Bottom Action Pill Buttons
            Row(
              children: [
                Expanded(
                  child: ScaleOnTap(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.booking);
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Center(
                        child: Text(
                          "Re-Schedule",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: ScaleOnTap(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.booking);
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .3),
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "View Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Default placeholder if no upcoming booking (matching the exact mockup style)
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://images.unsplash.com/photo-1594824813588-466d7e0c4f8d?auto=format&fit=crop&q=80&w=200",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dr. Jenny Wilson",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const Gap(3),
                    Text(
                      "General Practitioner",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .85),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.videocam_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .75),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            "18 Nov, Monday",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: Colors.white.withValues(alpha: .25),
                ),
                const Gap(14),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .75),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            "8:00pm - 8:30pm",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: ScaleOnTap(
                  onTap: () {
                    final defaultDoc = _mockToDetails(_mockDoctors.first);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ServiceDetailsView(model: defaultDoc),
                      ),
                    );
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Center(
                      child: Text(
                        "Re-Schedule",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: ScaleOnTap(
                  onTap: () {
                    final defaultDoc = _mockToDetails(_mockDoctors.first);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ServiceDetailsView(model: defaultDoc),
                      ),
                    );
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .3),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "View Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, ServiceDetailsModel doc) {
    final docId = doc.serviceId ?? doc.providerName;
    final isBookmarked = _bookmarkedDoctors.contains(docId);

    return ScaleOnTap(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsView(model: doc),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: .03),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Doctor Photo
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                doc.imageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 72,
                  height: 72,
                  color: AppColors.primaryLight,
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 36,
                  ),
                ),
              ),
            ),
            const Gap(14),
            // Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.providerName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    doc.specialties.isNotEmpty
                        ? doc.specialties.first
                        : "Specialist Doctor",
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.accentAmber,
                        size: 17,
                      ),
                      const Gap(4),
                      Text(
                        "${doc.rating.toStringAsFixed(1)}  |  ${doc.reviewsCount} Reviews",
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bookmark Icon Button
            GestureDetector(
              onTap: () {
                setState(() {
                  if (isBookmarked) {
                    _bookmarkedDoctors.remove(docId);
                  } else {
                    _bookmarkedDoctors.add(docId);
                  }
                });
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isBookmarked
                      ? AppColors.primaryLight
                      : const Color(0xFFF8FAFC),
                  border: Border.all(
                    color: isBookmarked
                        ? AppColors.primary.withValues(alpha: .3)
                        : AppColors.border,
                  ),
                ),
                child: Icon(
                  isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isBookmarked ? AppColors.primary : AppColors.textMuted,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
