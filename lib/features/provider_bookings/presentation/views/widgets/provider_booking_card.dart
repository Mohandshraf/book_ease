import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/provider_bookings/data/cubit/provider_bookings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ProviderBookingCard extends StatelessWidget {
  final BookingModel booking;

  const ProviderBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final status = booking.status.toLowerCase();
    final isPending = status == 'pending';
    final isConfirmed = status == 'confirmed';
    final formattedDate =
        DateFormat('EEEE, MMM dd, yyyy').format(booking.bookingDate);

    return ScaleOnTap(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.03),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Client Avatar + Name + Service Title + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    booking.customerName != null &&
                            booking.customerName!.isNotEmpty
                        ? booking.customerName![0].toUpperCase()
                        : 'C',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.customerName ?? 'Client / Patient',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        booking.serviceTitle ?? 'Professional Service',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      if (booking.customerEmail != null &&
                          booking.customerEmail!.isNotEmpty)
                        Text(
                          booking.customerEmail!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                _buildStatusBadge(booking.status),
              ],
            ),
            const Divider(height: 28, color: AppColors.border),

            // Date, Time, and Price
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const Gap(6),
                  Text(
                    booking.bookingTime,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            if (booking.price != null) ...[
              const Gap(10),
              Row(
                children: [
                  const Icon(
                    Icons.payments_outlined,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const Gap(6),
                  Text(
                    'Fee: \$${booking.price!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
            if (booking.notes != null && booking.notes!.isNotEmpty) ...[
              const Gap(10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warningLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.notes_rounded,
                      size: 15,
                      color: AppColors.warning,
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        'Note: ${booking.notes}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Actions for pending
            if (isPending && booking.id != null) ...[
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.cancelled,
                        side: const BorderSide(color: AppColors.cancelledLight, width: 1.5),
                        backgroundColor: AppColors.cancelledLight.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () {
                        context
                            .read<ProviderBookingsCubit>()
                            .rejectBooking(booking.id!);
                      },
                      label: const Text('Decline', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.check, size: 16, color: Colors.white),
                      onPressed: () {
                        context
                            .read<ProviderBookingsCubit>()
                            .acceptBooking(booking.id!);
                      },
                      label: const Text(
                        'Accept Booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Actions for confirmed
            if (isConfirmed && booking.id != null) ...[
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        context
                            .read<ProviderBookingsCubit>()
                            .rejectBooking(booking.id!);
                      },
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.task_alt_rounded,
                          size: 16, color: Colors.white),
                      onPressed: () {
                        context
                            .read<ProviderBookingsCubit>()
                            .completeBooking(booking.id!);
                      },
                      label: const Text(
                        'Complete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;
    IconData icon;
    switch (status.toLowerCase()) {
      case 'confirmed':
        bg = AppColors.confirmedLight;
        text = AppColors.confirmed;
        icon = Icons.check_circle_rounded;
        break;
      case 'pending':
        bg = AppColors.pendingLight;
        text = AppColors.pending;
        icon = Icons.hourglass_top_rounded;
        break;
      case 'completed':
        bg = AppColors.completedLight;
        text = AppColors.completed;
        icon = Icons.verified_rounded;
        break;
      case 'cancelled':
      case 'rejected':
        bg = AppColors.cancelledLight;
        text = AppColors.cancelled;
        icon = Icons.cancel_rounded;
        break;
      default:
        bg = AppColors.surfaceMuted;
        text = AppColors.textSecondary;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: text),
          const Gap(4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: text,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
