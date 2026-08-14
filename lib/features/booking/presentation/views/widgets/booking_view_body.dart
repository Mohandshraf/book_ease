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
        onRefresh: () async {
          _fetchBookings();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      color: Color(0xff0B1F44),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: _fetchBookings,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.refresh_rounded,
                        color: Color(0xff0B1F44),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Custom Sliding Toggle Tab Bar
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xffF1F5F9),
                  borderRadius: BorderRadius.circular(26),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    // Tab: Upcoming
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = "Upcoming";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedTab == "Upcoming"
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: selectedTab == "Upcoming"
                                ? [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.04),
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
                                    ? const Color(0xff0B1F44)
                                    : const Color(0xff94A3B8),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Tab: Past
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = "Past";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedTab == "Past"
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: selectedTab == "Past"
                                ? [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.04),
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
                                    ? const Color(0xff0B1F44)
                                    : const Color(0xff94A3B8),
                                fontSize: 15,
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
              const SizedBox(height: 24),

              // 3. Dynamic Bookings Content from Bloc
              BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  if (state is BookingLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff0B9B7B),
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
                              color: Colors.redAccent,
                              size: 44,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.errorMessage,
                              style: const TextStyle(
                                color: Color(0xff64748B),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _fetchBookings,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff0B9B7B),
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
                              color: Color(0xff94A3B8),
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No $selectedTab bookings found",
                              style: const TextStyle(
                                color: Color(0xff64748B),
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
                        title: b.serviceId.isNotEmpty
                            ? b.serviceId
                            : "Medical Service",
                        doctorName: b.providerId.isNotEmpty
                            ? b.providerId
                            : "Doctor",
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
            ],
          ),
        ),
      ),
    );
  }
}
