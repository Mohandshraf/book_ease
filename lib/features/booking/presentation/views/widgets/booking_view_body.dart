import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/booking/data/cubit/booking_cubit.dart';
import 'package:book_ease/features/booking/data/cubit/booking_state.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/presentation/views/widgets/booking_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingViewBody extends StatefulWidget {
  const BookingViewBody({super.key});

  @override
  State<BookingViewBody> createState() => _BookingViewBodyState();
}

class _BookingViewBodyState extends State<BookingViewBody> {
  String selectedTab = "Upcoming";

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  void _fetchBookings() {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    context.read<BookingCubit>().getUserBookings(uid);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          _fetchBookings();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Row (Title + Refresh Button)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My bookings",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  ScaleOnTap(
                    onTap: _fetchBookings,
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.refresh_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 2. Custom Sliding Toggle Tab Bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    // Tab: Upcoming
                    Expanded(
                      child: ScaleOnTap(
                        onTap: () {
                          setState(() {
                            selectedTab = "Upcoming";
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: selectedTab == "Upcoming"
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: selectedTab == "Upcoming"
                                ? [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              "Upcoming",
                              style: TextStyle(
                                color: selectedTab == "Upcoming"
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Tab: Past
                    Expanded(
                      child: ScaleOnTap(
                        onTap: () {
                          setState(() {
                            selectedTab = "Past";
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: selectedTab == "Past"
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: selectedTab == "Past"
                                ? [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              "Past",
                              style: TextStyle(
                                color: selectedTab == "Past"
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Dynamic Bookings Content from Bloc
              BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  if (state is BookingLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  if (state is BookingFailure) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.error,
                              size: 40,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.errorMessage,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _fetchBookings,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              child: const Text("Retry",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final List<BookingModel> allBookings =
                      (state is BookingSuccess && state.bookings != null)
                          ? state.bookings!
                          : [];

                  final now = DateTime.now();
                  final todayStart = DateTime(now.year, now.month, now.day);

                  final upcomingBookings = allBookings.where((b) {
                    final bDate = DateTime(
                      b.bookingDate.year,
                      b.bookingDate.month,
                      b.bookingDate.day,
                    );
                    return bDate.isAfter(todayStart) ||
                        bDate.isAtSameMomentAs(todayStart);
                  }).toList();

                  final pastBookings = allBookings.where((b) {
                    final bDate = DateTime(
                      b.bookingDate.year,
                      b.bookingDate.month,
                      b.bookingDate.day,
                    );
                    return bDate.isBefore(todayStart);
                  }).toList();

                  final activeBookings = selectedTab == "Upcoming"
                      ? upcomingBookings
                      : pastBookings;

                  if (activeBookings.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              color: AppColors.accent,
                              size: 44,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No $selectedTab bookings found",
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  const months = [
                    "JAN",
                    "FEB",
                    "MAR",
                    "APR",
                    "MAY",
                    "JUN",
                    "JUL",
                    "AUG",
                    "SEP",
                    "OCT",
                    "NOV",
                    "DEC"
                  ];

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activeBookings.length,
                    itemBuilder: (context, index) {
                      final b = activeBookings[index];
                      final monthStr = months[b.bookingDate.month - 1];
                      final dayStr =
                          b.bookingDate.day.toString().padLeft(2, '0');

                      return BookingCard(
                        month: monthStr,
                        day: dayStr,
                        title: (b.serviceTitle != null && b.serviceTitle!.isNotEmpty)
                            ? b.serviceTitle!
                            : (b.serviceId.isNotEmpty
                                ? b.serviceId
                                : "Medical Service"),
                        doctorName: (b.providerName != null && b.providerName!.isNotEmpty)
                            ? b.providerName!
                            : (b.providerId.isNotEmpty
                                ? b.providerId
                                : "Doctor"),
                        time: b.bookingTime,
                        status: b.status.isNotEmpty
                            ? (b.status[0].toUpperCase() +
                                b.status.substring(1))
                            : "Confirmed",
                        onTap: () {},
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
