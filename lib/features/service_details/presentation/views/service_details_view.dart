import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:book_ease/features/service_details/presentation/views/booking_summary_view.dart';
import 'package:book_ease/features/service_details/presentation/views/widgets/service_details_view_body.dart';
import 'package:flutter/material.dart';

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
    selectedDate = widget.model.availableDates.first.date;
    selectedTime = widget.model.availableTimes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ServiceDetailsViewBody(
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
              onPressed: () {
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0B9B7B),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "Book Now — \$${widget.model.price.toInt()}",
                style: const TextStyle(
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
