import 'dart:async';
import 'package:book_ease/core/di/service_locator.dart';
import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_cubit.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_state.dart';
import 'package:book_ease/features/profile/cubit/saved_providers_cubit.dart';
import 'package:book_ease/features/provider_services/data/models/service_model.dart';
import 'package:book_ease/features/provider_services/data/repo/provider_services_repo.dart';
import 'package:book_ease/features/root/presentation/views/customer_root_view.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:book_ease/features/service_details/presentation/views/service_details_view.dart';
import 'package:book_ease/core/widgets/safe_image.dart';
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
      "image": "assets/images/doctor1.png",
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
      "image": "assets/images/doctor2.png",
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
      "image": "assets/images/doctor3.png",
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
      "image": "assets/images/image1.png",
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
      "image": "assets/images/image2.png",
      "about":
          "Family physician providing comprehensive primary healthcare, preventative checkups, and chronic disease support.",
      "location": "Community Care Center • 1.0 km",
    },
    {
      "id": "doc_6",
      "name": "Dr. Marcus Vance",
      "specialty": "Neurologist",
      "category": "Neurology",
      "rating": 4.9,
      "reviews": 160,
      "price": 110.0,
      "image": "assets/images/image3.png",
      "about":
          "Expert in neurological disorders, migraine treatments, EEG diagnostics, and stroke recovery care.",
      "location": "Brain & Spine Institute • 2.8 km",
    },
    {
      "id": "doc_7",
      "name": "Dr. Sophia Patel",
      "specialty": "Pediatrician",
      "category": "Pediatrics",
      "rating": 4.8,
      "reviews": 230,
      "price": 65.0,
      "image": "assets/images/default_doctor.png",
      "about":
          "Dedicated pediatric specialist passionate about child wellness, newborn health checks, and vaccination care.",
      "location": "Children's Health Pavilion • 1.7 km",
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
          : "assets/images/doctor1.png",
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
      specialties: [doc["category"], doc["specialty"], "Consultation", "Specialist"],
      availableDates: mockServiceDetails.availableDates,
      availableTimes: mockServiceDetails.availableTimes,
    );
  }

  bool _matchesSpecialty(ServiceDetailsModel doc, String category) {
    if (category == "All") return true;
    final catLower = category.toLowerCase();

    if (catLower == "dentist" || catLower == "dental") {
      return doc.specialties.any((s) => s.toLowerCase().contains("dent")) ||
          doc.title.toLowerCase().contains("dent") ||
          doc.aboutText.toLowerCase().contains("dent");
    }
    if (catLower == "cardiology" || catLower == "cardiologist") {
      return doc.specialties.any((s) => s.toLowerCase().contains("cardio")) ||
          doc.title.toLowerCase().contains("cardio") ||
          doc.aboutText.toLowerCase().contains("cardio");
    }
    if (catLower == "neurology" || catLower == "neurologist") {
      return doc.specialties.any((s) => s.toLowerCase().contains("neuro")) ||
          doc.title.toLowerCase().contains("neuro") ||
          doc.aboutText.toLowerCase().contains("neuro");
    }
    if (catLower == "pediatrics" || catLower == "pediatrician") {
      return doc.specialties.any((s) => s.toLowerCase().contains("pediatric") || s.toLowerCase().contains("child")) ||
          doc.title.toLowerCase().contains("pediatric") ||
          doc.aboutText.toLowerCase().contains("pediatric");
    }
    if (catLower == "dermatology" || catLower == "dermatologist") {
      return doc.specialties.any((s) => s.toLowerCase().contains("derma") || s.toLowerCase().contains("skin")) ||
          doc.title.toLowerCase().contains("derma") ||
          doc.aboutText.toLowerCase().contains("derma");
    }
    if (catLower == "general") {
      return doc.specialties.any((s) => s.toLowerCase().contains("general") || s.toLowerCase().contains("family")) ||
          doc.title.toLowerCase().contains("general") ||
          doc.aboutText.toLowerCase().contains("general") ||
          doc.aboutText.toLowerCase().contains("family");
    }

    return doc.specialties.any((s) => s.toLowerCase().contains(catLower)) ||
        doc.title.toLowerCase().contains(catLower);
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
      final matchesCategory = _matchesSpecialty(doc, _selectedCategory);

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
                          ),
                          child: ClipOval(
                            child: SafeImage(
                              imageSource: userPhoto.isNotEmpty
                                  ? userPhoto
                                  : "assets/images/default_user.png",
                              width: 48,
                              height: 48,
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
                      child: BlocBuilder<NotificationCubit, NotificationState>(
                        builder: (context, notifState) {
                          final unreadCount =
                              notifState is NotificationLoaded ? notifState.unreadCount : 0;
                          return Container(
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
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                const Icon(
                                  Icons.notifications_none_rounded,
                                  color: AppColors.textPrimary,
                                  size: 22,
                                ),
                                if (unreadCount > 0)
                                  Positioned(
                                    top: -2,
                                    right: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFEF4444).withValues(alpha: 0.45),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          unreadCount > 9 ? '9+' : '$unreadCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const Gap(20),

                // 2. Large Bold Typography Headline
                const Text(
                  "Find Your Best\nHealthcare Provider 🩺",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.25,
                    letterSpacing: -0.5,
                  ),
                ),

                const Gap(18),

                // 3. Search Pill Bar with Filter Tune Button
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      const Gap(12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Search doctors, clinics, specialties...",
                            hintStyle: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                        ),
                      ),
                      ScaleOnTap(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.discover);
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowColor.withValues(alpha: 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(24),

                // 4. Upcoming Appointments Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Upcoming Appointment",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    ScaleOnTap(
                      onTap: () {
                        CustomerRootView.navigateToTab(context, 2);
                      },
                      child: const Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(12),

                // Upcoming Appointment Card (Gradient Blue)
                _buildUpcomingAppointmentCard(context),

                const Gap(26),

                // 5. Medical Specialties / Categories Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Specialties",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    ScaleOnTap(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.discover);
                      },
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(14),

                // Circular Category Icons Row
                _buildCircularCategoriesRow(),

                const Gap(26),

                // 6. Top Specialists / Featured Doctors Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Top Specialists",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        if (_selectedCategory != "All") ...[
                          const Gap(8),
                          ScaleOnTap(
                            onTap: () {
                              setState(() {
                                _selectedCategory = "All";
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _selectedCategory,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const Gap(4),
                                  const Icon(
                                    Icons.close_rounded,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    ScaleOnTap(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.discover);
                      },
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(14),

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
                  _buildEmptySpecialistsState(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptySpecialistsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 28,
              color: AppColors.textMuted,
            ),
          ),
          const Gap(12),
          Text(
            _selectedCategory == "All"
                ? "No specialists found"
                : "No specialists found in $_selectedCategory",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(6),
          const Text(
            "Try searching or choose another specialty",
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (_selectedCategory != "All" || _searchController.text.isNotEmpty) ...[
            const Gap(16),
            ScaleOnTap(
              onTap: () {
                setState(() {
                  _selectedCategory = "All";
                  _searchController.clear();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Show All Specialists",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCircularCategoriesRow() {
    final List<Map<String, dynamic>> specialtyItems = [
      {
        "name": "All",
        "icon": Icons.grid_view_rounded,
        "bg": const Color(0xFFF1F5F9),
        "color": AppColors.textSecondary,
      },
      {
        "name": "Cardiology",
        "icon": Icons.favorite_rounded,
        "bg": const Color(0xFFEFF4FF),
        "color": AppColors.primary,
      },
      {
        "name": "Dentist",
        "icon": Icons.medical_services_rounded,
        "bg": const Color(0xFFE6FAF8),
        "color": AppColors.secondary,
      },
      {
        "name": "General",
        "icon": Icons.local_hospital_rounded,
        "bg": const Color(0xFFFFF0EC),
        "color": AppColors.accentPeach,
      },
      {
        "name": "Neurology",
        "icon": Icons.psychology_rounded,
        "bg": const Color(0xFFF5F3FF),
        "color": AppColors.accentLilac,
      },
      {
        "name": "Pediatrics",
        "icon": Icons.child_care_rounded,
        "bg": const Color(0xFFE0F2FE),
        "color": AppColors.accentSky,
      },
      {
        "name": "Dermatology",
        "icon": Icons.healing_rounded,
        "bg": const Color(0xFFFFE4E6),
        "color": AppColors.accentRose,
      },
    ];

    return SizedBox(
      height: 98,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: specialtyItems.length,
        separatorBuilder: (context, index) => const Gap(14),
        itemBuilder: (context, index) {
          final item = specialtyItems[index];
          final isSelected = _selectedCategory == item["name"];

          return ScaleOnTap(
            onTap: () {
              setState(() {
                if (item["name"] == "All") {
                  _selectedCategory = "All";
                } else {
                  _selectedCategory =
                      _selectedCategory == item["name"] ? "All" : item["name"];
                }
              });
            },
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : item["bg"] as Color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (item["bg"] as Color).withValues(alpha: 0.8),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Icon(
                      item["icon"] as IconData,
                      color: isSelected ? Colors.white : item["color"] as Color,
                      size: 26,
                    ),
                  ),
                ),
                const Gap(6),
                Text(
                  item["name"] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
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

    final bool hasBooking = _nextBooking != null;

    if (!hasBooking) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.event_available_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "No upcoming appointments",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(3),
                      Text(
                        "Book your consultation with certified doctors.",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(16),
            ScaleOnTap(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.discover);
              },
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryGradientStart,
                      AppColors.primaryGradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.search_rounded, color: Colors.white, size: 16),
                    Gap(8),
                    Text(
                      "Find a Doctor & Book",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final bDate = _nextBooking!.bookingDate;
    final dateStr =
        "${bDate.day} ${months[bDate.month - 1]}, ${days[bDate.weekday - 1]}";
    final timeStr = _nextBooking!.bookingTime;
    final doctorName = ((_nextBooking!.providerName != null &&
            _nextBooking!.providerName!.isNotEmpty)
        ? _nextBooking!.providerName!
        : (_nextBooking!.serviceTitle ?? "Doctor"));
    final specialty = _nextBooking!.serviceTitle ?? "Specialist";
    final doctorPhoto = _nextBooking!.providerImage ??
        "assets/images/default_doctor.png";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Doctor Avatar + Name/Specialty + Action Buttons
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: SafeImage(
                    imageSource: doctorPhoto,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Gap(12),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        specialty,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Video and Chat Action Buttons
              Row(
                children: [
                  ScaleOnTap(
                    onTap: () {
                      final pId = _nextBooking!.providerId;
                      Navigator.pushNamed(
                        context,
                        AppRoutes.chat,
                        arguments: {
                          'otherUserId': pId,
                          'doctorName': doctorName,
                          'otherUserImage': _nextBooking!.providerImage,
                          'otherUserSpecialty': specialty,
                        },
                      );
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const Gap(8),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.videocam_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Gap(16),

          // Middle Row: Date & Time Translucent Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .18),
              borderRadius: BorderRadius.circular(14),
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
                        size: 15,
                      ),
                      const Gap(8),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.white.withValues(alpha: .3),
                ),
                const Gap(10),
                // Time
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                      const Gap(8),
                      Text(
                        timeStr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Gap(14),

          // Bottom Action Pill Buttons
          Row(
            children: [
              Expanded(
                child: ScaleOnTap(
                  onTap: () {
                    CustomerRootView.navigateToTab(context, 2);
                  },
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21),
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
              const Gap(10),
              Expanded(
                child: ScaleOnTap(
                  onTap: () {
                    if (hasBooking) {
                      CustomerRootView.navigateToTab(context, 2);
                    } else {
                      final defaultDoc = _mockToDetails(_mockDoctors.first);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ServiceDetailsView(model: defaultDoc),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .35),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Details",
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
    final docId = doc.serviceId ?? doc.providerId ?? doc.providerName;
    final savedCubit = context.watch<SavedProvidersCubit>();
    final isBookmarked = savedCubit.isSaved(docId);
    final specialtyName = doc.specialties.isNotEmpty
        ? doc.specialties.first
        : "Cardiologist";

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
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: .03),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Doctor Photo
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SafeImage(
                imageSource: doc.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const Gap(14),
            // Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Specialty Tag + Rating & Bookmark Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          specialtyName,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.star,
                            size: 16,
                          ),
                          const Gap(2),
                          Text(
                            doc.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Gap(6),
                          GestureDetector(
                            onTap: () {
                              final cubit = context.read<SavedProvidersCubit>();
                              final messenger = ScaffoldMessenger.of(context);
                              cubit.toggleSaveDoctor(doc);
                              messenger.hideCurrentSnackBar();
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isBookmarked
                                        ? "${doc.providerName} removed from saved"
                                        : "${doc.providerName} added to saved providers",
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Icon(
                              isBookmarked
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              color: isBookmarked
                                  ? const Color(0xFFEC4899)
                                  : AppColors.textMuted,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(6),
                  Text(
                    doc.providerName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.textMuted,
                        size: 13,
                      ),
                      const Gap(2),
                      Expanded(
                        child: Text(
                          doc.location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  // Price + Book Now Pill Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${doc.price.toStringAsFixed(0)} / visit",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "Book Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
