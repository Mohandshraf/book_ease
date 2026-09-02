import 'package:bloc_test/bloc_test.dart';
import 'package:book_ease/features/booking/data/cubit/booking_cubit.dart';
import 'package:book_ease/features/booking/data/cubit/booking_state.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingRepo extends Mock implements BookingRepo {}
class FakeBookingModel extends Fake implements BookingModel {}

void main() {
  late MockBookingRepo mockBookingRepo;
  late BookingCubit bookingCubit;

  setUpAll(() {
    registerFallbackValue(FakeBookingModel());
  });

  setUp(() {
    mockBookingRepo = MockBookingRepo();
    bookingCubit = BookingCubit(mockBookingRepo);
  });

  tearDown(() {
    bookingCubit.close();
  });

  group('BookingCubit Test Suite', () {
    test('initial state is BookingInitial', () {
      expect(bookingCubit.state, isA<BookingInitial>());
    });

    final testBooking = BookingModel(
      customerId: 'user123',
      providerId: 'provider456',
      serviceId: 'General Checkup',
      bookingDate: DateTime(2026, 8, 20),
      bookingTime: '10:30 AM',
      status: 'confirmed',
      createdAt: DateTime(2026, 8, 15),
    );

    blocTest<BookingCubit, BookingState>(
      'emits [BookingLoading, BookingSuccess] when createBooking succeeds',
      build: () {
        when(() => mockBookingRepo.createBooking(any()))
            .thenAnswer((_) async {});
        return bookingCubit;
      },
      act: (cubit) => cubit.createBooking(testBooking),
      expect: () => [
        isA<BookingLoading>(),
        isA<BookingSuccess>(),
      ],
    );

    blocTest<BookingCubit, BookingState>(
      'emits [BookingLoading, BookingFailure] when createBooking fails',
      build: () {
        when(() => mockBookingRepo.createBooking(any()))
            .thenThrow(Exception('Failed to connect'));
        return bookingCubit;
      },
      act: (cubit) => cubit.createBooking(testBooking),
      expect: () => [
        isA<BookingLoading>(),
        isA<BookingFailure>().having(
          (s) => s.errorMessage,
          'errorMessage',
          contains('Failed to connect'),
        ),
      ],
    );

    blocTest<BookingCubit, BookingState>(
      'emits [BookingLoading, BookingSuccess] with list when getUserBookings succeeds',
      build: () {
        when(() => mockBookingRepo.getUserBookings('user123'))
            .thenAnswer((_) async => [testBooking]);
        return bookingCubit;
      },
      act: (cubit) => cubit.getUserBookings('user123'),
      expect: () => [
        isA<BookingLoading>(),
        isA<BookingSuccess>().having(
          (s) => s.bookings?.length,
          'bookings count',
          1,
        ),
      ],
    );

    blocTest<BookingCubit, BookingState>(
      'emits [BookingLoading, BookingSuccess] when cancelBooking succeeds',
      build: () {
        when(() => mockBookingRepo.updateBookingStatus('bk1', 'cancelled'))
            .thenAnswer((_) async {});
        when(() => mockBookingRepo.getUserBookings('user123'))
            .thenAnswer((_) async => []);
        return bookingCubit;
      },
      act: (cubit) => cubit.cancelBooking('bk1', 'user123'),
      expect: () => [
        isA<BookingLoading>(),
        isA<BookingSuccess>().having(
          (s) => s.bookings?.length,
          'bookings count',
          0,
        ),
      ],
    );
  });
}
