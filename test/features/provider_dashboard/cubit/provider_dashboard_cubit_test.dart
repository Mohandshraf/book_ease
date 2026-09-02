import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:book_ease/features/booking/data/models/booking_model.dart';
import 'package:book_ease/features/booking/data/repo/booking_repo.dart';
import 'package:book_ease/features/provider_dashboard/data/cubit/provider_dashboard_cubit.dart';
import 'package:book_ease/features/provider_dashboard/data/cubit/provider_dashboard_state.dart';
import 'package:book_ease/features/provider_services/data/models/service_model.dart';
import 'package:book_ease/features/provider_services/data/repo/provider_services_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingRepo extends Mock implements BookingRepo {}

class MockProviderServicesRepo extends Mock implements ProviderServicesRepo {}

void main() {
  late MockBookingRepo mockBookingRepo;
  late MockProviderServicesRepo mockServicesRepo;
  late ProviderDashboardCubit cubit;

  final sampleBooking = BookingModel(
    id: 'b1',
    customerId: 'u1',
    customerName: 'Alice',
    customerEmail: 'alice@example.com',
    providerId: 'p1',
    providerName: 'Dr. John',
    serviceId: 's1',
    serviceTitle: 'Consultation',
    bookingDate: DateTime.now(),
    bookingTime: '09:00 AM',
    status: 'pending',
    price: 100.0,
    createdAt: DateTime.now(),
  );

  final sampleService = ServiceModel(
    id: 's1',
    providerId: 'p1',
    title: 'Consultation',
    category: 'Medical',
    price: 100.0,
    priceUnit: '/hr',
    durationMinutes: 60,
    description: 'Checkup',
    isActive: true,
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockBookingRepo = MockBookingRepo();
    mockServicesRepo = MockProviderServicesRepo();
    cubit = ProviderDashboardCubit(mockBookingRepo, mockServicesRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('ProviderDashboardCubit Tests', () {
    test('initial state is ProviderDashboardInitial', () {
      expect(cubit.state, isA<ProviderDashboardInitial>());
    });

    blocTest<ProviderDashboardCubit, ProviderDashboardState>(
      'emits [ProviderDashboardLoading, ProviderDashboardLoaded] when bookings stream emits',
      build: () {
        when(() => mockBookingRepo.getProviderBookingsStream('p1'))
            .thenAnswer((_) => Stream.value([sampleBooking]));
        when(() => mockServicesRepo.getProviderServices('p1'))
            .thenAnswer((_) async => [sampleService]);
        return cubit;
      },
      act: (cubit) => cubit.loadDashboardData(providerId: 'p1'),
      expect: () => [
        isA<ProviderDashboardLoading>(),
        isA<ProviderDashboardLoaded>(),
      ],
      verify: (_) {
        final state = cubit.state as ProviderDashboardLoaded;
        expect(state.stats.pendingRequests, 1);
        expect(state.stats.activeServicesCount, 1);
        expect(state.stats.totalEarnings, 100.0);
      },
    );

    blocTest<ProviderDashboardCubit, ProviderDashboardState>(
      'calculates totalEarnings including pending, confirmed, and completed bookings while excluding cancelled and rejected',
      build: () {
        final bookings = [
          sampleBooking.copyWith(id: 'b1', status: 'pending', price: 150.0),
          sampleBooking.copyWith(id: 'b2', status: 'confirmed', price: 200.0),
          sampleBooking.copyWith(id: 'b3', status: 'completed', price: 300.0),
          sampleBooking.copyWith(id: 'b4', status: 'cancelled', price: 500.0),
          sampleBooking.copyWith(id: 'b5', status: 'rejected', price: 400.0),
        ];
        when(() => mockBookingRepo.getProviderBookingsStream('p1'))
            .thenAnswer((_) => Stream.value(bookings));
        when(() => mockServicesRepo.getProviderServices('p1'))
            .thenAnswer((_) async => [sampleService]);
        return cubit;
      },
      act: (cubit) => cubit.loadDashboardData(providerId: 'p1'),
      expect: () => [
        isA<ProviderDashboardLoading>(),
        isA<ProviderDashboardLoaded>(),
      ],
      verify: (_) {
        final state = cubit.state as ProviderDashboardLoaded;
        // 150 (pending) + 200 (confirmed) + 300 (completed) = 650
        expect(state.stats.totalEarnings, 650.0);
        expect(state.stats.pendingRequests, 1);
        expect(state.stats.confirmedBookings, 1);
        expect(state.stats.completedBookings, 1);
      },
    );
  });
}
