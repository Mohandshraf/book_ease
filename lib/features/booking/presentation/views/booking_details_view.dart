import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/core/widgets/safe_image.dart';
import 'package:book_ease/features/booking/data/cubit/booking_cubit.dart';
import 'package:book_ease/features/booking/data/cubit/booking_state.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class BookingDetailsView extends StatefulWidget {
  final BookingModel booking;

  const BookingDetailsView({super.key, required this.booking});

  @override
  State<BookingDetailsView> createState() => _BookingDetailsViewState();
}

class _BookingDetailsViewState extends State<BookingDetailsView> {
  late BookingModel _currentBooking;

  @override
  void initState() {
    super.initState();
    _currentBooking = widget.booking;
  }

  void _confirmCancelBooking() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          context.tr('booking_details_cancel_title'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          context.tr('booking_details_cancel_confirm'),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              context.tr('booking_details_keep'),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final uid = FirebaseAuth.instance.currentUser?.uid ??
                  _currentBooking.customerId;
              if (_currentBooking.id != null) {
                await context
                    .read<BookingCubit>()
                    .cancelBooking(_currentBooking.id!, uid);
                if (mounted) {
                  setState(() {
                    _currentBooking = _currentBooking.copyWith(status: 'cancelled');
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr('booking_details_cancelled_success')),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              context.tr('booking_details_yes_cancel'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusLower = _currentBooking.status.toLowerCase();
    Color badgeBgColor = AppColors.primaryLight;
    Color badgeTextColor = AppColors.primary;
    IconData statusIcon = Icons.check_circle_outline_rounded;

    if (statusLower == "completed") {
      badgeBgColor = AppColors.successLight;
      badgeTextColor = AppColors.success;
      statusIcon = Icons.task_alt_rounded;
    } else if (statusLower == "cancelled" || statusLower == "rejected") {
      badgeBgColor = AppColors.errorLight;
      badgeTextColor = AppColors.error;
      statusIcon = Icons.cancel_outlined;
    } else if (statusLower == "pending") {
      badgeBgColor = AppColors.warningLight;
      badgeTextColor = AppColors.warning;
      statusIcon = Icons.hourglass_top_rounded;
    }

    final date = _currentBooking.bookingDate;
    final String formattedDate = context.localizedFormattedDate(date);

    final bookingIdDisplay = _currentBooking.id != null && _currentBooking.id!.isNotEmpty
        ? "#${_currentBooking.id!.substring(0, _currentBooking.id!.length.clamp(0, 8)).toUpperCase()}"
        : "#BK-${_currentBooking.createdAt.millisecondsSinceEpoch.toString().substring(7)}";

    final consultationPrice = _currentBooking.price ?? 50.0;
    const double bookingFee = 3.0;
    final double totalPrice = consultationPrice + bookingFee;

    final isActionable = statusLower == "confirmed" || statusLower == "pending";

    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 70,
          title: Row(
            children: [
              ScaleOnTap(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor.withValues(alpha: .03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    context.isRtl
                        ? Icons.arrow_forward_rounded
                        : Icons.arrow_back_rounded,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
              const Gap(14),
              Text(
                context.tr('booking_details_title'),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Status & ID Card
              FadeSlideTransition(
                delay: const Duration(milliseconds: 50),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor.withValues(alpha: .03),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('booking_details_ref'),
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Gap(3),
                          Text(
                            bookingIdDisplay,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              statusIcon,
                              size: 14,
                              color: badgeTextColor,
                            ),
                            const Gap(5),
                            Text(
                              statusLower == "completed"
                                  ? context.tr('bookings_status_completed')
                                  : statusLower == "cancelled"
                                      ? context.tr('bookings_status_cancelled')
                                      : statusLower == "rejected"
                                          ? context.tr('bookings_status_rejected')
                                          : statusLower == "pending"
                                              ? context.tr('bookings_status_pending')
                                              : context.tr('bookings_status_confirmed'),
                              style: TextStyle(
                                color: badgeTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(16),

              // 2. Doctor & Service Info Card
              FadeSlideTransition(
                delay: const Duration(milliseconds: 100),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor.withValues(alpha: .03),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SafeImage(
                              imageSource: _currentBooking.providerImage ??
                                  'assets/images/default_doctor.png',
                              width: 68,
                              height: 68,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Gap(14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (_currentBooking.serviceTitle != null &&
                                          _currentBooking.serviceTitle!.isNotEmpty)
                                      ? _currentBooking.serviceTitle!
                                      : "Doctor Consultation",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  (_currentBooking.providerName != null &&
                                          _currentBooking.providerName!.isNotEmpty)
                                      ? _currentBooking.providerName!
                                      : "Mohand Ashraf",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Gap(6),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.star_rounded,
                                      color: AppColors.rating,
                                      size: 16,
                                    ),
                                    Gap(4),
                                    Text(
                                      "5.0",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Gap(4),
                                    Text(
                                      "(284 reviews)",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(16),

              // 3. Appointment Schedule Card
              FadeSlideTransition(
                delay: const Duration(milliseconds: 150),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor.withValues(alpha: .03),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Appointment Schedule",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Gap(16),
                      _buildScheduleRow(
                        icon: Icons.calendar_today_rounded,
                        label: "Date",
                        value: formattedDate,
                      ),
                      const Gap(14),
                      _buildScheduleRow(
                        icon: Icons.access_time_rounded,
                        label: "Time Slot",
                        value: _currentBooking.bookingTime.isNotEmpty
                            ? _currentBooking.bookingTime
                            : "3:00 PM",
                      ),
                      const Gap(14),
                      _buildScheduleRow(
                        icon: Icons.location_on_outlined,
                        label: "Location",
                        value: "123 Medical Center Dr., Suite 400",
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(16),

              // 4. Patient Information Card
              FadeSlideTransition(
                delay: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor.withValues(alpha: .03),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Patient Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Gap(16),
                      _buildScheduleRow(
                        icon: Icons.person_outline_rounded,
                        label: "Full Name",
                        value: (_currentBooking.customerName != null &&
                                _currentBooking.customerName!.isNotEmpty)
                            ? _currentBooking.customerName!
                            : (FirebaseAuth.instance.currentUser?.displayName ??
                                "Patient"),
                      ),
                      if (_currentBooking.customerEmail != null &&
                          _currentBooking.customerEmail!.isNotEmpty) ...[
                        const Gap(14),
                        _buildScheduleRow(
                          icon: Icons.email_outlined,
                          label: "Email Address",
                          value: _currentBooking.customerEmail!,
                        ),
                      ],
                      const Gap(14),
                      _buildScheduleRow(
                        icon: Icons.notes_rounded,
                        label: "Reason / Notes",
                        value: (_currentBooking.notes != null &&
                                _currentBooking.notes!.isNotEmpty)
                            ? _currentBooking.notes!
                            : "General medical checkup and consultation",
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(16),

              // 5. Payment Summary Card
              FadeSlideTransition(
                delay: const Duration(milliseconds: 250),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor.withValues(alpha: .03),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Payment Summary",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 13,
                                  color: AppColors.success,
                                ),
                                Gap(4),
                                Text(
                                  "Paid",
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      _buildPriceRow("Consultation Fee", "\$${consultationPrice.toStringAsFixed(2)}"),
                      const Gap(10),
                      _buildPriceRow("Booking Fee", "\$${bookingFee.toStringAsFixed(2)}"),
                      const Gap(12),
                      const Divider(height: 1, color: AppColors.border),
                      const Gap(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Amount",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            "\$${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(120),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: SafeArea(
            child: isActionable
                ? ScaleOnTap(
                    onTap: _confirmCancelBooking,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            color: AppColors.error,
                            size: 18,
                          ),
                          Gap(8),
                          Text(
                            "Cancel Appointment",
                            style: TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ScaleOnTap(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.discover);
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primaryGradientStart,
                            AppColors.primaryGradientEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: .3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Book New Appointment",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accentLilacLight,
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(3),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
