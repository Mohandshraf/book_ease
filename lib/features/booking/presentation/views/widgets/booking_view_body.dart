import 'package:book_ease/features/booking/presentation/views/widgets/booking_card.dart';
import 'package:flutter/material.dart';

class BookingViewBody extends StatefulWidget {
  const BookingViewBody({super.key});

  @override
  State<BookingViewBody> createState() => _BookingViewBodyState();
}

class _BookingViewBodyState extends State<BookingViewBody> {
  String selectedTab = "Past"; // Default to "Past" matching the mockup

  final List<Map<String, dynamic>> pastBookings = const [
    {
      "month": "JUN",
      "day": "20",
      "title": "Annual wellness exam",
      "doctorName": "Dr. Sarah Mitchell",
      "time": "9:00 AM",
      "status": "Completed"
    },
    {
      "month": "MAY",
      "day": "12",
      "title": "Dental Cleaning",
      "doctorName": "Dr. Omar Hassan",
      "time": "2:30 PM",
      "status": "Completed"
    }
  ];

  final List<Map<String, dynamic>> upcomingBookings = const [
    {
      "month": "JUL",
      "day": "28",
      "title": "General Health Checkup",
      "doctorName": "Dr. Sarah Mitchell",
      "time": "10:30 AM",
      "status": "Confirmed"
    },
    {
      "month": "AUG",
      "day": "05",
      "title": "Skin Care Followup",
      "doctorName": "Dr. Maya Patel",
      "time": "11:00 AM",
      "status": "Confirmed"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final activeBookings = selectedTab == "Upcoming" ? upcomingBookings : pastBookings;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Row (Title + Add Button)
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
                  onTap: () {
                    // Placeholder for adding a new booking
                  },
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
                      Icons.add_rounded,
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
                          color: selectedTab == "Upcoming" ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: selectedTab == "Upcoming"
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            "Upcoming",
                            style: TextStyle(
                              color: selectedTab == "Upcoming" ? const Color(0xff0B1F44) : const Color(0xff94A3B8),
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
                          color: selectedTab == "Past" ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: selectedTab == "Past"
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            "Past",
                            style: TextStyle(
                              color: selectedTab == "Past" ? const Color(0xff0B1F44) : const Color(0xff94A3B8),
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

            // 3. Dynamic Bookings Cards List
            if (activeBookings.isEmpty)
              Center(
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
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activeBookings.length,
                itemBuilder: (context, index) {
                  final b = activeBookings[index];
                  return BookingCard(
                    month: b["month"],
                    day: b["day"],
                    title: b["title"],
                    doctorName: b["doctorName"],
                    time: b["time"],
                    status: b["status"],
                    onTap: () {
                      // Optionally open booking detail or chat
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
