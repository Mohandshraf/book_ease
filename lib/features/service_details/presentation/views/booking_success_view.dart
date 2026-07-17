import 'package:book_ease/core/app_colors.dart';
import 'package:book_ease/root_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BookingSuccessView extends StatelessWidget {
  const BookingSuccessView({
    super.key,
    required this.providerName,
    required this.doctorName,
    required this.dateText,
    required this.timeText,
    required this.amountPaid,
    this.confirmationCode,
    this.onViewBookingsPressed,
    this.onBackHomePressed,
  });

  final String providerName;
  final String doctorName;
  final String dateText;
  final String timeText;
  final double amountPaid;
  final String? confirmationCode;
  final VoidCallback? onViewBookingsPressed;
  final VoidCallback? onBackHomePressed;

  @override
  Widget build(BuildContext context) {
    // Default confirmation code if not provided
    final String displayCode = confirmationCode ?? "BKE-2026-7315";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Animated/Decorative Success checkmark with confetti
              Center(
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Confetti dots
                      Positioned(
                        top: 10,
                        left: 20,
                        child: _buildConfettiDot(color: Colors.amber, size: 10),
                      ),
                      Positioned(
                        top: 20,
                        right: 15,
                        child: _buildConfettiDot(color: Colors.pink, size: 8),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 25,
                        child: _buildConfettiDot(color: Colors.blueAccent, size: 7),
                      ),
                      Positioned(
                        bottom: 25,
                        right: 20,
                        child: _buildConfettiDot(color: Colors.purple, size: 12),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 65,
                        child: _buildConfettiDot(color: Colors.orange, size: 9),
                      ),

                      // Outer circular glow
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xffDDFBF0).withAlpha(150),
                        ),
                      ),
                      // Inner check circle
                      Container(
                        width: 76,
                        height: 76,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff0B9B7B),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Gap(24),

              // Title and Description
              const Text(
                "Booking Confirmed!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0B1F44),
                ),
              ),
              const Gap(12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Your appointment has been successfully booked. A confirmation has been sent to your email.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xff64748B),
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Confirmation Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xffF8FAFC),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xffE2E8F0), width: 1),
                ),
                child: Column(
                  children: [
                    const Text(
                      "CONFIRMATION CODE",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff94A3B8),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      displayCode,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ksecondColor,
                      ),
                    ),
                    const Gap(24),
                    const Divider(color: Color(0xffE2E8F0), thickness: 1, height: 1),
                    const Gap(20),

                    // Detail items
                    _buildSummaryDetailRow(label: "Provider", value: providerName),
                    const Gap(16),
                    _buildSummaryDetailRow(label: "Doctor", value: doctorName),
                    const Gap(16),
                    _buildSummaryDetailRow(label: "Date", value: dateText),
                    const Gap(16),
                    _buildSummaryDetailRow(label: "Time", value: timeText),
                    const Gap(16),
                    _buildSummaryDetailRow(
                      label: "Paid",
                      value: "\$${amountPaid.toStringAsFixed(2)}",
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Bottom Actions
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: onViewBookingsPressed ??
                          () {
                            // Pop to root home view
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RootView(),
                              ),
                              (route) => false,
                            );
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0B9B7B),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "View My Bookings",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: onBackHomePressed ??
                          () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RootView(),
                              ),
                              (route) => false,
                            );
                          },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xffE2E8F0), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Back to Home",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0B1F44),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfettiDot({required Color color, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withAlpha(200),
      ),
    );
  }

  Widget _buildSummaryDetailRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xff94A3B8),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xff0B1F44),
          ),
        ),
      ],
    );
  }
}
