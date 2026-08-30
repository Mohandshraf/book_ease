import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/admin/data/recent_booking_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RecentBookingsSection extends StatelessWidget {
  const RecentBookingsSection({
    super.key,
    required this.bookings,
    this.onViewAllPressed,
    this.onBookingPressed,
  });

  final List<RecentBookingModel> bookings;
  final VoidCallback? onViewAllPressed;
  final Function(RecentBookingModel)? onBookingPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Bookings",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ScaleOnTap(
              onTap: onViewAllPressed,
              child: const Text(
                "View all",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const Gap(12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: List.generate(bookings.length, (index) {
              final booking = bookings[index];
              final isLast = index == bookings.length - 1;
              return Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: ScaleOnTap(
                      onTap: onBookingPressed != null
                          ? () => onBookingPressed!(booking)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        key: ValueKey(booking.name),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: AppColors.accentLilacLight,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.accentLilac.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  booking.initials,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const Gap(3),
                                  Text(
                                    "${booking.service} · ${booking.time}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\$${booking.price.toInt()}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const Gap(4),
                                _buildStatusBadge(booking.status),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.border,
                      indent: 18,
                      endIndent: 18,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final bool isConfirmed = status.toLowerCase() == 'confirmed';
    final Color backgroundColor =
        isConfirmed ? AppColors.successLight : AppColors.warningLight;
    final Color textColor =
        isConfirmed ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
