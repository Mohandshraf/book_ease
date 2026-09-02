import 'package:book_ease/features/service_details/data/cubit/booking_date_cubit.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:book_ease/features/service_details/presentation/views/widgets/service_details_date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServiceDetailsDateTimePicker Tests', () {
    late ServiceDetailsModel testModel;
    late BookingSelectionCubit bookingSelectionCubit;

    setUp(() {
      bookingSelectionCubit = BookingSelectionCubit();
      testModel = ServiceDetailsModel(
        serviceId: 'srv_test',
        providerId: 'prov_test',
        providerName: 'Dr. Test Provider',
        title: 'Consultation',
        location: 'Clinic 101',
        rating: 4.8,
        reviewsCount: 120,
        price: 75.0,
        priceUnit: 'per session',
        imageUrl: 'assets/images/doctor1.png',
        aboutText: 'Experienced practitioner',
        specialties: const ['Family Medicine'],
        availableDates: const [],
        availableTimes: const ['09:00 AM', '10:00 AM', '02:00 PM', '04:00 PM'],
      );
    });

    tearDown(() {
      bookingSelectionCubit.close();
    });

    testWidgets('renders calendar header, weekdays, and time slots',
        (WidgetTester tester) async {
      final initialDate = DateTime(2026, 9, 2); // Wednesday, 2 Sep 2026
      DateTime selectedDate = initialDate;
      String selectedTime = '09:00 AM';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<BookingSelectionCubit>.value(
              value: bookingSelectionCubit,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    child: ServiceDetailsDateTimePicker(
                      model: testModel,
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
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check header format: "2 Sep, 26" and "Wednesday"
      expect(find.text('2 Sep, 26'), findsOneWidget);
      expect(find.text('Wednesday'), findsOneWidget);

      // Check 7 weekday column headers starting on Sunday
      expect(find.text('Sun'), findsOneWidget);
      expect(find.text('Mon'), findsOneWidget);
      expect(find.text('Tue'), findsOneWidget);
      expect(find.text('Wed'), findsOneWidget);
      expect(find.text('Thu'), findsOneWidget);
      expect(find.text('Fri'), findsOneWidget);
      expect(find.text('Sat'), findsOneWidget);

      // Next month arrow test
      final nextMonthIcon = find.byIcon(Icons.chevron_right_rounded);
      expect(nextMonthIcon, findsOneWidget);
      await tester.tap(nextMonthIcon);
      await tester.pumpAndSettle();

      // Should transition to October 2026
      expect(find.textContaining('Oct, 26'), findsOneWidget);

      // Check Time selection header and slot count
      await tester.ensureVisible(find.text('Select Time'));
      expect(find.text('Select Time'), findsOneWidget);
      expect(find.text('4 Slots'), findsOneWidget);

      // Tap time slot "10:00 AM"
      await tester.ensureVisible(find.text('10:00 AM'));
      await tester.tap(find.text('10:00 AM'));
      await tester.pumpAndSettle();
      expect(selectedTime, '10:00 AM');
    });
  });
}
