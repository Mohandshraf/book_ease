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
    final weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    final String formattedDate =
        "${weekdays[selectedDate.weekday - 1]}, ${months[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}";

    const double bookingFee = 3.0;
    const double memberDiscount = 8.0;
    final double totalPrice = model.price + bookingFee - memberDiscount;

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8FAFC),
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: const Color(0xffE2E8F0)),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xff0B1F44),
                  size: 22,
                ),
              ),
            ),
            const Gap(16),
            const Text(
              "Booking Summary",
              style: TextStyle(
                color: Color(0xff0B1F44),
                fontSize: 24,
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
              const Gap(20),
              BookingSummaryAppointmentCard(
                formattedDate: formattedDate,
                selectedTime: selectedTime,
                providerName: model.providerName,
              ),
              const Gap(20),
              BookingSummaryPriceCard(
                consultationFee: model.price,
                bookingFee: bookingFee,
                memberDiscount: memberDiscount,
                totalPrice: totalPrice,
              ),
              const Gap(20),
              const BookingSummaryNotesCard(),
              const Gap(120),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xffF1F5F9), width: 1)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onProceedToPaymentPressed ??
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0B9B7B),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Proceed to Payment",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
