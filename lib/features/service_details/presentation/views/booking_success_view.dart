import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/root/presentation/views/customer_root_view.dart';
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
                        child: _buildConfettiDot(color: AppColors.warning, size: 10),
                      ),
                      Positioned(
                        top: 20,
                        right: 15,
                        child: _buildConfettiDot(color: AppColors.accentLilac, size: 8),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 25,
                        child: _buildConfettiDot(color: AppColors.info, size: 7),
                      ),
                      Positioned(
                        bottom: 25,
                        right: 20,
                        child: _buildConfettiDot(color: AppColors.primary, size: 12),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 65,
                        child: _buildConfettiDot(color: AppColors.warning, size: 9),
                      ),

                      // Outer circular glow
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.successLight.withValues(alpha: .5),
                        ),
                      ),
                      // Inner check circle
                      Container(
                        width: 76,
                        height: 76,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.success,
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
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Gap(10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Your appointment has been successfully booked. A confirmation has been sent to your email.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Confirmation Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Column(
                  children: [
                    const Text(
                      "CONFIRMATION CODE",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      displayCode,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const Gap(18),
                    const Divider(color: AppColors.border, thickness: 1, height: 1),
                    const Gap(16),

                    // Detail items
                    _buildSummaryDetailRow(label: "Provider", value: providerName),
                    const Gap(14),
                    _buildSummaryDetailRow(label: "Doctor", value: doctorName),
                    const Gap(14),
                    _buildSummaryDetailRow(label: "Date", value: dateText),
                    const Gap(14),
                    _buildSummaryDetailRow(label: "Time", value: timeText),
                    const Gap(14),
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
                    child: ScaleOnTap(
                      onTap: onViewBookingsPressed ??
                          () {
                            CustomerRootView.navigateToTab(context, 2);
                          },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: .3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "View My Bookings",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ScaleOnTap(
                      onTap: onBackHomePressed ??
                          () {
                            CustomerRootView.navigateToTab(context, 0);
                          },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.border, width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Back to Home",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.2,
                          ),
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
        color: color.withValues(alpha: .8),
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
