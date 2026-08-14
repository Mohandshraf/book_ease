import 'package:book_ease/core/app_colors.dart';
import 'package:book_ease/features/booking/data/cubit/booking_cubit.dart';
import 'package:book_ease/features/booking/data/cubit/booking_state.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:book_ease/features/service_details/presentation/views/booking_success_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({
    super.key,
    required this.totalPrice,
    required this.model,
    required this.selectedDate,
    required this.selectedTime,
    this.onPayPressed,
  });

  final double totalPrice;
  final ServiceDetailsModel model;
  final DateTime selectedDate;
  final String selectedTime;
  final VoidCallback? onPayPressed;

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  int selectedMethodIndex = 0; // 0: Credit Card, 1: PayPal, 2: Apple Pay

  final TextEditingController numberController = TextEditingController();
  final TextEditingController holderController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  String cardNumber = "•••• •••• •••• 4242";
  String cardHolder = "Alex Johnson";
  String expiryDate = "08/28";
  String cvv = "•••";

  @override
  void initState() {
    super.initState();
    // Default values matching screenshot
    numberController.text = "1234 5678 9012 4242";
    holderController.text = "Alex Johnson";
    expiryController.text = "08/28";
    cvvController.text = "•••";

    // Listen to changes to update card preview dynamically
    numberController.addListener(() {
      setState(() {
        cardNumber = numberController.text.isEmpty
            ? "•••• •••• •••• 4242"
            : numberController.text;
      });
    });

    holderController.addListener(() {
      setState(() {
        cardHolder = holderController.text.isEmpty
            ? "Alex Johnson"
            : holderController.text;
      });
    });

    expiryController.addListener(() {
      setState(() {
        expiryDate = expiryController.text.isEmpty
            ? "08/28"
            : expiryController.text;
      });
    });

    cvvController.addListener(() {
      setState(() {
        cvv = cvvController.text.isEmpty ? "•••" : cvvController.text;
      });
    });
  }

  @override
  void dispose() {
    numberController.dispose();
    holderController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          final weekdays = [
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday",
            "Sunday"
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
            "December"
          ];
          final String formattedDate =
              "${weekdays[widget.selectedDate.weekday - 1]}, ${months[widget.selectedDate.month - 1]} ${widget.selectedDate.day}, ${widget.selectedDate.year}";

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BookingSuccessView(
                providerName: widget.model.title,
                doctorName: widget.model.providerName,
                dateText: formattedDate,
                timeText: widget.selectedTime,
                amountPaid: widget.totalPrice,
              ),
            ),
          );
        } else if (state is BookingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is BookingLoading;
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
                  "Payment",
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(10),

                  // 1. Credit Card Graphic Widget
                  Container(
                    height: 210,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff0B9B7B),
                          Color(0xff0284c7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff0B9B7B).withAlpha(40),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          // Decorative background shapes
                          Positioned(
                            right: -30,
                            bottom: -40,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withAlpha(12),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 40,
                            top: -50,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withAlpha(8),
                              ),
                            ),
                          ),

                          // Card Content
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Card Type Brand Logo
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Yellow Card Chip
                                    Container(
                                      width: 46,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF59E0B),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    // Mastercard style Brand Circles
                                    SizedBox(
                                      width: 48,
                                      height: 32,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color(0xffEF4444)
                                                    .withAlpha(220),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color(0xffF59E0B)
                                                    .withAlpha(200),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Card Number
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "CARD NUMBER",
                                      style: TextStyle(
                                        color: Colors.white.withAlpha(150),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const Gap(6),
                                    Text(
                                      cardNumber,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ],
                                ),

                                // Card Holder & Expiration
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "CARD HOLDER",
                                          style: TextStyle(
                                            color: Colors.white.withAlpha(150),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const Gap(4),
                                        Text(
                                          cardHolder,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "EXPIRES",
                                          style: TextStyle(
                                            color: Colors.white.withAlpha(150),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const Gap(4),
                                        Text(
                                          expiryDate,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Gap(24),

                  // 2. Payment Method Selector Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildMethodButton(
                          index: 0,
                          label: "Credit Card",
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: _buildMethodButton(
                          index: 1,
                          label: "PayPal",
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: _buildMethodButton(
                          index: 2,
                          label: "Apple Pay",
                        ),
                      ),
                    ],
                  ),

                  const Gap(24),

                  // 3. Conditional Content
                  if (selectedMethodIndex == 0) ...[
                    // Card Details Form Container
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
                            "Card Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0B1F44),
                            ),
                          ),
                          const Gap(20),

                          // Card Number Field
                          const Text(
                            "CARD NUMBER",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff94A3B8),
                              letterSpacing: 1,
                            ),
                          ),
                          const Gap(8),
                          _buildTextField(
                            controller: numberController,
                            icon: Icons.credit_card_outlined,
                          ),
                          const Gap(16),

                          // Card Holder Field
                          const Text(
                            "CARD HOLDER",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff94A3B8),
                              letterSpacing: 1,
                            ),
                          ),
                          const Gap(8),
                          _buildTextField(
                            controller: holderController,
                            icon: Icons.person_outline_rounded,
                          ),
                          const Gap(16),

                          // Expiry & CVV Row
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "EXPIRY",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff94A3B8),
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const Gap(8),
                                    _buildTextField(
                                      controller: expiryController,
                                      icon: Icons.date_range_outlined,
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "CVV",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff94A3B8),
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const Gap(8),
                                    _buildTextField(
                                      controller: cvvController,
                                      icon: Icons.lock_outline_rounded,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else if (selectedMethodIndex == 1) ...[
                    // PayPal Message Card
                    _buildAlternateMethodCard(
                      title: "PayPal Connection",
                      description:
                          "You will be redirected to PayPal website to authorize payment on the next step safely.",
                      icon: Icons.paypal_outlined,
                    ),
                  ] else ...[
                    // Apple Pay Message Card
                    _buildAlternateMethodCard(
                      title: "Apple Pay Integration",
                      description:
                          "Double-click your power button or verify with Face ID to pay with your default Apple wallet card.",
                      icon: Icons.apple_outlined,
                    ),
                  ],

                  const Gap(120),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xffF1F5F9),
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : (widget.onPayPressed ??
                          () {
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            final currentUserId = currentUser?.uid ?? "";

                            final booking = BookingModel(
                              customerId: currentUserId,
                              customerName: currentUser?.displayName,
                              customerEmail: currentUser?.email,
                              providerId: widget.model.providerName,
                              serviceId: widget.model.title,
                              bookingDate: widget.selectedDate,
                              bookingTime: widget.selectedTime,
                              status: "confirmed",
                              createdAt: DateTime.now(),
                            );

                            context
                                .read<BookingCubit>()
                                .createBooking(booking);
                          }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0B9B7B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Pay \$${widget.totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Gap(6),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMethodButton({required int index, required String label}) {
    final isSelected = selectedMethodIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethodIndex = index;
        });
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.ksecondColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.ksecondColor : const Color(0xffE2E8F0),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xff64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: const Color(0xff94A3B8),
          size: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
      style: const TextStyle(
        color: Color(0xff0B1F44),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAlternateMethodCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
        children: [
          Icon(icon, size: 64, color: AppColors.ksecondColor),
          const Gap(16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff0B1F44),
            ),
          ),
          const Gap(8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff64748B),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
