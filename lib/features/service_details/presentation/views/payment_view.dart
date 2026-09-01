import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/booking/data/cubit/booking_cubit.dart';
import 'package:book_ease/features/booking/data/cubit/booking_state.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:book_ease/features/service_details/presentation/views/booking_success_view.dart';
import 'package:book_ease/features/service_details/presentation/views/widgets/payment_card_form.dart';
import 'package:book_ease/features/service_details/presentation/views/widgets/payment_card_preview.dart';
import 'package:book_ease/features/service_details/presentation/views/widgets/payment_method_selector.dart';
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
    numberController.text = "1234 5678 9012 4242";
    holderController.text = "Alex Johnson";
    expiryController.text = "08/28";
    cvvController.text = "•••";

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
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is BookingLoading;
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
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
                const Gap(14),
                const Text(
                  "Payment",
                  style: TextStyle(
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(10),
                  PaymentCardPreview(
                    cardNumber: cardNumber,
                    cardHolder: cardHolder,
                    expiryDate: expiryDate,
                  ),
                  const Gap(20),
                  PaymentMethodSelector(
                    selectedIndex: selectedMethodIndex,
                    onMethodSelected: (index) {
                      setState(() {
                        selectedMethodIndex = index;
                      });
                    },
                  ),
                  const Gap(20),
                  if (selectedMethodIndex == 0) ...[
                    PaymentCardForm(
                      numberController: numberController,
                      holderController: holderController,
                      expiryController: expiryController,
                      cvvController: cvvController,
                    ),
                  ] else if (selectedMethodIndex == 1) ...[
                    _buildAlternateMethodCard(
                      title: "PayPal Connection",
                      description:
                          "You will be redirected to PayPal website to authorize payment on the next step safely.",
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                  ] else ...[
                    _buildAlternateMethodCard(
                      title: "Apple Pay Integration",
                      description:
                          "Double-click your power button or verify with Face ID to pay with your default Apple wallet card.",
                      icon: Icons.apple_rounded,
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
                  color: AppColors.border,
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ScaleOnTap(
                  onTap: isLoading
                      ? null
                      : (widget.onPayPressed ??
                          () {
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            final currentUserId = currentUser?.uid ?? "";

                            final effectiveProviderId = (widget.model.providerId != null &&
                                    widget.model.providerId!.isNotEmpty)
                                ? widget.model.providerId!
                                : widget.model.providerName;
                            final effectiveServiceId = (widget.model.serviceId != null &&
                                    widget.model.serviceId!.isNotEmpty)
                                ? widget.model.serviceId!
                                : widget.model.title;

                            final booking = BookingModel(
                              customerId: currentUserId,
                              customerName: currentUser?.displayName,
                              customerEmail: currentUser?.email,
                              providerId: effectiveProviderId,
                              providerName: widget.model.providerName,
                              serviceId: effectiveServiceId,
                              serviceTitle: widget.model.title,
                              price: widget.totalPrice,
                              bookingDate: widget.selectedDate,
                              bookingTime: widget.selectedTime,
                              status: "pending",
                              createdAt: DateTime.now(),
                            );

                            context
                                .read<BookingCubit>()
                                .createBooking(booking);
                          }),
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
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const Gap(8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: .04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.accentLilacLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: AppColors.primary),
          ),
          const Gap(16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Gap(8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
