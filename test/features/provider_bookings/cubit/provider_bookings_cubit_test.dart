import 'package:bloc_test/bloc_test.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:book_ease/features/provider_bookings/data/cubit/provider_bookings_cubit.dart';
import 'package:book_ease/features/provider_bookings/data/cubit/provider_bookings_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingRepo extends Mock implements BookingRepo {}

void main() {
  late MockBookingRepo mockRepo;
  late ProviderBookingsCubit cubit;

  final sampleBooking = BookingModel(
    id: 'b1',
    customerId: 'u1',
    customerName: 'John Doe',
    customerEmail: 'john@example.com',
    providerId: 'p1',
    providerName: 'Provider Pro',
    serviceId: 's1',
    serviceTitle: 'Dentist Checkup',
    price: 150.0,
    bookingDate: DateTime(2026, 8, 20),
    bookingTime: '10:00 AM',
    status: 'pending',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockRepo = MockBookingRepo();
    cubit = ProviderBookingsCubit(mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('ProviderBookingsCubit Tests', () {
    test('initial state is ProviderBookingsInitial', () {
      expect(cubit.state, isA<ProviderBookingsInitial>());
    });

    blocTest<ProviderBookingsCubit, ProviderBookingsState>(
      'emits [ProviderBookingsLoading, ProviderBookingsSuccess] on fetchProviderBookings',
      build: () {
        when(() => mockRepo.getProviderBookings('p1'))
            .thenAnswer((_) async => [sampleBooking]);
        return cubit;
      },
      act: (cubit) => cubit.fetchProviderBookings(providerId: 'p1'),
      expect: () => [
        isA<ProviderBookingsLoading>(),
        isA<ProviderBookingsSuccess>(),
      ],
      verify: (_) {
        final state = cubit.state as ProviderBookingsSuccess;
        expect(state.allBookings.length, 1);
        expect(state.allBookings.first.customerName, 'John Doe');
      },
    );

    blocTest<ProviderBookingsCubit, ProviderBookingsState>(
      'calls updateBookingStatus when acceptBooking is called',
      build: () {
        when(() => mockRepo.updateBookingStatus('b1', 'confirmed'))
            .thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.acceptBooking('b1'),
      verify: (_) {
        verify(() => mockRepo.updateBookingStatus('b1', 'confirmed')).called(1);
      },
    );

    blocTest<ProviderBookingsCubit, ProviderBookingsState>(
      'filters bookings by status correctly',
      build: () {
        when(() => mockRepo.getProviderBookings('p1'))
            .thenAnswer((_) async => [sampleBooking]);
        return cubit;
      },
      act: (cubit) {
        cubit.fetchProviderBookings(providerId: 'p1');
        cubit.filterByStatus('confirmed');
      },
      verify: (_) {
        expect(cubit.currentFilter, 'confirmed');
      },
    );
  });
}
