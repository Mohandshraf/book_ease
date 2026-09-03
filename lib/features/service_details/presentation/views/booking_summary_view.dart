import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:book_ease/features/service_details/presentation/views/payment_view.dart';
import 'package:book_ease/features/service_details/presentation/views/widgets/booking_summary_appointment_card.dart';
import 'package:book_ease/features/service_details/presentation/views/widgets/booking_summary_clinic_card.dart';
import 'package:book_ease/features/service_details/presentation/views/widgets/booking_summary_notes_card.dart';
import 'package:book_ease/features/service_details/presentation/views/widgets/booking_summary_price_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BookingSummaryView extends StatelessWidget {
  const BookingSummaryView({
    super.key,
    required this.model,
    required this.selectedDate,
    required this.selectedTime,
    this.onProceedToPaymentPressed,
  });

  final ServiceDetailsModel model;
  final DateTime selectedDate;
  final String selectedTime;
  final VoidCallback? onProceedToPaymentPressed;

  @override
  Widget build(BuildContext context) {
    final String formattedDate = context.localizedFormattedDate(selectedDate);

    const double bookingFee = 3.0;
    const double memberDiscount = 8.0;
    final double totalPrice = model.price + bookingFee - memberDiscount;

    return Scaffold(
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
              context.tr('summary_title'),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingSummaryClinicCard(model: model),
              const Gap(16),
              BookingSummaryAppointmentCard(
                formattedDate: formattedDate,
                selectedTime: context.localizedTime(selectedTime),
                providerName: model.providerName,
              ),
              const Gap(16),
              BookingSummaryPriceCard(
                consultationFee: model.price,
                bookingFee: bookingFee,
                memberDiscount: memberDiscount,
                totalPrice: totalPrice,
              ),
              const Gap(16),
              const BookingSummaryNotesCard(),
              const Gap(120),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ScaleOnTap(
              onTap: onProceedToPaymentPressed ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentView(
                          totalPrice: totalPrice,
                          model: model,
                          selectedDate: selectedDate,
                          selectedTime: selectedTime,
                        ),
                      ),
                    );
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
                child: Text(
                  context.tr('summary_proceed_payment'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
