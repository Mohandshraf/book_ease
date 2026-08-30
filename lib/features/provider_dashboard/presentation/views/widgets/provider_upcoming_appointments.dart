import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/provider_bookings/data/cubit/provider_bookings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ProviderUpcomingAppointments extends StatelessWidget {
  final List<BookingModel> bookings;
  final Function(int)? onTabChangeRequested;

  const ProviderUpcomingAppointments({
    super.key,
    required this.bookings,
    this.onTabChangeRequested,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Appointments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            ScaleOnTap(
              onTap: () {
                onTabChangeRequested?.call(1); // switch to bookings
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Gap(14),
        if (bookings.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    size: 40,
                    color: AppColors.textMuted,
                  ),
                  Gap(10),
                  Text(
                    'No upcoming appointments scheduled',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: bookings
                .map((b) => _UpcomingBookingCard(booking: b))
                .toList(),
          ),
      ],
    );
  }
}

class _UpcomingBookingCard extends StatelessWidget {
  final BookingModel booking;

  const _UpcomingBookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final isPending = booking.status.toLowerCase() == 'pending';
    final isConfirmed = booking.status.toLowerCase() == 'confirmed';
    final formattedDate =
        DateFormat('MMM dd, yyyy').format(booking.bookingDate);

    return ScaleOnTap(
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.03),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
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
                        booking.customerName ?? 'Patient / Client',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        booking.serviceTitle ?? 'General Consultation',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(booking.status),
              ],
            ),
            const Divider(height: 28, color: AppColors.border),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 15,
                  color: AppColors.textSecondary,
                ),
                const Gap(6),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Gap(18),
                const Icon(
                  Icons.access_time_rounded,
                  size: 15,
                  color: AppColors.textSecondary,
                ),
                const Gap(6),
                Text(
                  booking.bookingTime,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            if (isPending && booking.id != null) ...[
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.cancelled,
                        side: const BorderSide(color: AppColors.cancelledLight, width: 1.5),
                        backgroundColor: AppColors.cancelledLight.withValues(alpha: 0.3),
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
                      child:
                          const Text('Decline', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () {
                        context
                            .read<ProviderBookingsCubit>()
                            .acceptBooking(booking.id!);
                      },
                      child: const Text(
                        'Accept',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (isConfirmed && booking.id != null) ...[
              const Gap(16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  onPressed: () {
                    context
                        .read<ProviderBookingsCubit>()
                        .completeBooking(booking.id!);
                  },
                  child: const Text(
                    'Mark as Completed',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bg;
    Color text;
    switch (status.toLowerCase()) {
      case 'confirmed':
        bg = AppColors.confirmedLight;
        text = AppColors.confirmed;
        break;
      case 'pending':
        bg = AppColors.pendingLight;
        text = AppColors.pending;
        break;
      case 'completed':
        bg = AppColors.completedLight;
        text = AppColors.completed;
        break;
      case 'cancelled':
      case 'rejected':
        bg = AppColors.cancelledLight;
        text = AppColors.cancelled;
        break;
      default:
        bg = AppColors.surfaceMuted;
        text = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
