import 'package:book_ease/core/app_colors.dart';
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
                color: Color(0xff0B1F44),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: onViewAllPressed,
              child: const Text(
                "View all",
                style: TextStyle(
                  color: AppColors.ksecondColor,
                  fontSize: 16,
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
            boxShadow: [
              BoxShadow(
                color: const Color(0x0A000000),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: List.generate(bookings.length, (index) {
              final booking = bookings[index];
              final isLast = index == bookings.length - 1;
              return Column(
                children: [
                  InkWell(
                    onTap: onBookingPressed != null
                        ? () => onBookingPressed!(booking)
                        : null,
                    borderRadius: BorderRadius.vertical(
                      top: index == 0 ? const Radius.circular(24) : Radius.zero,
                      bottom: isLast ? const Radius.circular(24) : Radius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      key: ValueKey(booking.name),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: AppColors.ksecondColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                booking.initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking.name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0B1F44),
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  "${booking.service} · ${booking.time}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$${booking.price.toInt()}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.ksecondColor,
                                ),
                              ),
                              const Gap(6),
                              _buildStatusBadge(booking.status),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xffF1F5F9),
                      indent: 20,
                      endIndent: 20,
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
        isConfirmed ? const Color(0xffDDFBF0) : const Color(0xffFFF3D6);
    final Color textColor =
        isConfirmed ? const Color(0xff0B9B7B) : const Color(0xffD97706);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
