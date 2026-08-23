import 'dart:async';
import 'package:book_ease/core/di/service_locator.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:book_ease/features/home/presentation/views/widgets/category_item.dart';
import 'package:book_ease/features/provider_services/data/models/service_model.dart';
import 'package:book_ease/features/provider_services/data/repo/provider_services_repo.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:book_ease/features/service_details/presentation/views/service_details_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  ServiceModel? _featuredService;

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
          return bDate.isAfter(todayStart) ||
              bDate.isAtSameMomentAs(todayStart);
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
        _featuredService = services.isNotEmpty ? services.first : null;
      });
    }, onError: (_) {});
  }

  @override
  void dispose() {
    _bookingsSubscription?.cancel();
    _servicesSubscription?.cancel();
    super.dispose();
  }

  ServiceDetailsModel _createServiceDetailsModel(ServiceModel s) {
    return ServiceDetailsModel(
      serviceId: s.id ?? s.title,
      providerId: s.providerId,
      providerImage: s.providerImage,
      title: s.title,
      providerName: s.providerName ?? "Specialist Provider",
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
          : "Experienced specialist providing top-tier professional consultations.",
      specialties: s.specialties.isNotEmpty
          ? s.specialties
          : [s.category, "Consultation", "Care"],
      availableDates: mockServiceDetails.availableDates,
      availableTimes: mockServiceDetails.availableTimes,
    );
  }

  @override
  Widget build(BuildContext context) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Your next appointment Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your next appointment",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0B1F44),
                    ),
                  ),
                  if (_nextBooking != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xffE6F7F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _nextBooking!.status.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xff0B9B7B),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const Gap(16),

              // Your next appointment Card
              if (_nextBooking != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .04),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xffEAFDF6),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                months[_nextBooking!.bookingDate.month - 1]
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xff0B9B7B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "${_nextBooking!.bookingDate.day}",
                                style: const TextStyle(
                                  color: Color(0xff0B1F44),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (_nextBooking!.providerName != null &&
                                      _nextBooking!.providerName!.isNotEmpty)
                                  ? _nextBooking!.providerName!
                                  : (_nextBooking!.serviceTitle ??
                                      "Specialist Provider"),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff0B1F44),
                              ),
                            ),
                            const Gap(4),
                            Text(
                              "${_nextBooking!.serviceTitle ?? 'Consultation'} • ${_nextBooking!.bookingTime}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xff64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xff94A3B8),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .04),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xffEAFDF6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.calendar_today_rounded,
                          color: Color(0xff0B9B7B),
                          size: 24,
                        ),
                      ),
                      const Gap(16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "No upcoming appointments",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff0B1F44),
                              ),
                            ),
                            Gap(4),
                            Text(
                              "Explore verified doctors & book care anytime",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Gap(32),

              // 2. Browse care Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Browse care",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0B1F44),
                    ),
                  ),
                  Text(
                    "All specialties",
                    style: TextStyle(
                      color: Color(0xff0B9B7B),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Gap(20),

              // Categories Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CategoryItem(
                    title: "Doctor",
                    icon: Icons.medical_services_outlined,
                    color: Color(0xffEAFDF6),
                    iconColor: Color(0xff0B9B7B),
                  ),
                  CategoryItem(
                    title: "Dentist",
                    icon: Icons.health_and_safety_outlined,
                    color: Color(0xffEAF1FF),
                    iconColor: Colors.blueAccent,
                  ),
                  CategoryItem(
                    title: "Salon",
                    icon: Icons.content_cut,
                    color: Color(0xffFFE5F2),
                    iconColor: Colors.pink,
                  ),
                  CategoryItem(
                    title: "Gym",
                    icon: Icons.fitness_center,
                    color: Color(0xffFFF5D9),
                    iconColor: Colors.orange,
                  ),
                ],
              ),

              const Gap(32),

              // 3. Recommended for you Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Recommended for you",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0B1F44),
                    ),
                  ),
                ],
              ),
              const Gap(20),

              // Recommendation Card
              if (_featuredService != null) ...[
                Builder(
                  builder: (context) {
                    final detailsModel =
                        _createServiceDetailsModel(_featuredService!);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailsView(
                              model: detailsModel,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .04),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                              child: Image.network(
                                (_featuredService!.imageUrl != null &&
                                        _featuredService!.imageUrl!.isNotEmpty)
                                    ? _featuredService!.imageUrl!
                                    : "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=600&auto=format&fit=crop",
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 180,
                                  color: const Color(0xffE2E8F0),
                                  child: const Center(
                                    child: Icon(Icons.medical_services_rounded,
                                        size: 48, color: Color(0xff94A3B8)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _featuredService!.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff0B1F44),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffE6F7F3),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          "Verified",
                                          style: TextStyle(
                                            color: Color(0xff0B9B7B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(6),
                                  Text(
                                    "${_featuredService!.providerName ?? 'Specialist Provider'} • ${_featuredService!.category}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff64748B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Gap(16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star_rounded,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                          const Gap(4),
                                          Text(
                                            _featuredService!.rating
                                                .toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff0B1F44),
                                            ),
                                          ),
                                          const Gap(4),
                                          Text(
                                            "(${_featuredService!.reviewsCount})",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff94A3B8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "From \$${_featuredService!.price.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff0B9B7B),
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
                  },
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .04),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.local_hospital_outlined,
                        color: Color(0xff94A3B8),
                        size: 40,
                      ),
                      Gap(12),
                      Text(
                        "No services currently listed",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0B1F44),
                        ),
                      ),
                      Gap(4),
                      Text(
                        "Providers will appear here once they register services",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
