import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/features/messages/presentation/views/chat_view.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:book_ease/features/service_details/presentation/views/booking_summary_view.dart';
import 'package:book_ease/features/service_details/presentation/views/widgets/service_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ServiceDetailsView extends StatefulWidget {
  const ServiceDetailsView({
    super.key,
    required this.model,
    this.onBookNowPressed,
  });

  final ServiceDetailsModel model;
  final void Function(DateTime date, String time)? onBookNowPressed;

  @override
  State<ServiceDetailsView> createState() => _ServiceDetailsViewState();
}

class _ServiceDetailsViewState extends State<ServiceDetailsView> {
  late DateTime selectedDate;
  late String selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.model.availableDates.isNotEmpty
        ? widget.model.availableDates.first.date
        : DateTime.now();
    selectedTime = widget.model.availableTimes.isNotEmpty
        ? widget.model.availableTimes.first
        : "9:30 AM";
  }

  @override
  Widget build(BuildContext context) {
    final effectiveProviderId =
        (widget.model.providerId != null && widget.model.providerId!.isNotEmpty)
            ? widget.model.providerId!
            : widget.model.providerName.toLowerCase().replaceAll(RegExp(r'\s+'), '_');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar with Circular Back & Share Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Circular Back Button
                  ScaleOnTap(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: AppColors.border, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: .04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.textPrimary,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Doctor Details",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  // Circular Share / Bookmark Button
                  ScaleOnTap(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Doctor link copied to clipboard!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: AppColors.border, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: .04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.share_outlined,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: ServiceDetailsViewBody(
                model: widget.model,
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                onTimeSelected: (time) {
                  setState(() {
                    selectedTime = time;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.border.withValues(alpha: .8), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: .06),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
        child: SafeArea(
          child: Row(
            children: [
              // Circular Message Doctor Button
              ScaleOnTap(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatView(
                        otherUserId: effectiveProviderId,
                        doctorName: widget.model.providerName,
                        otherUserImage:
                            widget.model.providerImage ?? widget.model.imageUrl,
                        otherUserSpecialty: widget.model.specialties.isNotEmpty
                            ? widget.model.specialties.first
                            : "Doctor",
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.border,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: .04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ),
              ),

              const Gap(14),

              // Full-Width Solid Blue Pill Button "Book an Appointment"
              Expanded(
                child: ScaleOnTap(
                  onTap: () {
                    if (widget.onBookNowPressed != null) {
                      widget.onBookNowPressed!(selectedDate, selectedTime);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingSummaryView(
                            model: widget.model,
                            selectedDate: selectedDate,
                            selectedTime: selectedTime,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 56,
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
                    child: const Center(
                      child: Text(
                        "Book an Appointment",
                        style: TextStyle(
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
            ],
          ),
        ),
      ),
    );
  }
}
