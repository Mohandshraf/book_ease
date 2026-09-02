import 'package:book_ease/features/booking/data/cubit/booking_cubit.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:book_ease/features/booking/presentation/views/booking_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingRepo extends Mock implements BookingRepo {}

void main() {
  late MockBookingRepo mockBookingRepo;
  late BookingCubit bookingCubit;

  setUp(() {
    mockBookingRepo = MockBookingRepo();
    bookingCubit = BookingCubit(mockBookingRepo);
  });

  tearDown(() {
    bookingCubit.close();
  });

  final testBooking = BookingModel(
    id: 'BK12345678',
    customerId: 'cust_001',
    customerName: 'Mohand Ashraf',
    customerEmail: 'mohand@example.com',
    providerId: 'prov_001',
    providerName: 'Dr. Sarah Connor',
    serviceId: 'srv_001',
    serviceTitle: 'Doctor Now',
    price: 50.0,
    bookingDate: DateTime(2026, 9, 2),
    bookingTime: '3:00 PM',
    status: 'confirmed',
    createdAt: DateTime(2026, 8, 30),
    notes: 'Severe headache and checkup',
  );

  testWidgets('BookingDetailsView renders all booking information correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<BookingCubit>.value(
          value: bookingCubit,
          child: BookingDetailsView(booking: testBooking),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Header & Title
    expect(find.text('Booking Details'), findsOneWidget);
    expect(find.text('Booking Reference'), findsOneWidget);
    expect(find.text('#BK123456'), findsOneWidget);
    expect(find.text('Confirmed'), findsOneWidget);

    // Doctor & Service Details
    expect(find.text('Doctor Now'), findsOneWidget);
    expect(find.text('Dr. Sarah Connor'), findsOneWidget);
    expect(find.text('5.0'), findsOneWidget);
    expect(find.text('Message Doctor'), findsWidgets);

    // Appointment Schedule
    expect(find.text('Appointment Schedule'), findsOneWidget);
    expect(find.text('Wednesday, September 2, 2026'), findsOneWidget);
    expect(find.text('3:00 PM'), findsOneWidget);
    expect(find.text('123 Medical Center Dr., Suite 400'), findsOneWidget);

    // Patient Details
    expect(find.text('Patient Details'), findsOneWidget);
    expect(find.text('Mohand Ashraf'), findsOneWidget);
    expect(find.text('mohand@example.com'), findsOneWidget);
    expect(find.text('Severe headache and checkup'), findsOneWidget);

    // Payment Summary
    expect(find.text('Payment Summary'), findsOneWidget);
    expect(find.text('Consultation Fee'), findsOneWidget);
    expect(find.text('\$50.00'), findsOneWidget);
    expect(find.text('Booking Fee'), findsOneWidget);
    expect(find.text('\$3.00'), findsOneWidget);
    expect(find.text('Total Amount'), findsOneWidget);
    expect(find.text('\$53.00'), findsOneWidget);
    expect(find.text('Paid'), findsOneWidget);

    // Action Buttons
    expect(find.text('Cancel'), findsOneWidget);
  });
}
