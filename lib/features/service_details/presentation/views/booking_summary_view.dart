import 'package:book_ease/core/app_colors.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:book_ease/features/service_details/presentation/views/payment_view.dart';
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
    // Format the date manually (e.g. Monday, July 15, 2024)
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

    // Hardcoded calculation values (for UI display only)
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
              // 1. Clinic Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        model.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0B1F44),
                            ),
                          ),
                          const Gap(4),
                          Text(
                            model.providerName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xff64748B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(6),
                          Row(
                            children: const [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 16,
                              ),
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 16,
                              ),
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 16,
                              ),
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 16,
                              ),
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 16,
                              ),
                              Gap(4),
                              Text(
                                "(284)",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff94A3B8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(20),

              // 2. Appointment Details Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Appointment Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0B1F44),
                      ),
                    ),
                    const Gap(20),

                    // Date Row
                    _buildDetailsRow(
                      icon: Icons.calendar_today_outlined,
                      label: "Date",
                      value: formattedDate,
                    ),
                    const Gap(16),

                    // Time Row
                    _buildDetailsRow(
                      icon: Icons.access_time_rounded,
                      label: "Time",
                      value: selectedTime,
                    ),
                    const Gap(16),

                    // Location Row
                    _buildDetailsRow(
                      icon: Icons.location_on_outlined,
                      label: "Location",
                      value: "123 Medical Center Dr.",
                    ),
                    const Gap(16),

                    // Doctor Row
                    _buildDetailsRow(
                      icon: Icons.person_outline_rounded,
                      label: "Doctor",
                      value: model.providerName,
                    ),
                  ],
                ),
              ),

              const Gap(20),

              // 3. Price Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Price Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0B1F44),
                      ),
                    ),
                    const Gap(16),

                    // Consultation Fee
                    _buildPriceRow(
                      label: "Consultation fee",
                      value: "\$${model.price.toStringAsFixed(2)}",
                    ),
                    const Gap(12),

                    // Booking Fee
                    _buildPriceRow(
                      label: "Booking fee",
                      value: "\$${bookingFee.toStringAsFixed(2)}",
                    ),
                    const Gap(12),

                    // Member Discount
                    _buildPriceRow(
                      label: "Member discount",
                      value: "-\$${memberDiscount.toStringAsFixed(2)}",
                      isDiscount: true,
                    ),
                    const Gap(16),

                    const Divider(color: Color(0xffE2E8F0), thickness: 1),

                    const Gap(16),

                    // Total Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0B1F44),
                          ),
                        ),
                        Text(
                          "\$${totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ksecondColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Gap(20),

              // 4. Add Notes Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add Notes",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0B1F44),
                      ),
                    ),
                    const Gap(12),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Any special requests or medical notes...",
                        hintStyle: const TextStyle(
                          color: Color(0xff94A3B8),
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        filled: true,
                        fillColor: const Color(0xffF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xffE2E8F0),
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xffE2E8F0),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.ksecondColor,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(120), // Extra space for scrolling above bottom button
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
              onPressed:
                  onProceedToPaymentPressed ??
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

  Widget _buildDetailsRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffDDFBF0),
          ),
          child: Icon(icon, color: AppColors.ksecondColor, size: 20),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xff94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(2),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xff0B1F44),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String value,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff64748B),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDiscount
                ? AppColors.ksecondColor
                : const Color(0xff0B1F44),
            fontSize: 15,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
