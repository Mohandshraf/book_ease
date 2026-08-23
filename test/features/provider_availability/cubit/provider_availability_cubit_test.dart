import 'package:bloc_test/bloc_test.dart';
import 'package:book_ease/features/provider_availability/data/cubit/provider_availability_cubit.dart';
import 'package:book_ease/features/provider_availability/data/cubit/provider_availability_state.dart';
import 'package:book_ease/features/provider_availability/data/models/provider_availability_model.dart';
import 'package:book_ease/features/provider_availability/data/repo/provider_availability_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProviderAvailabilityRepo extends Mock
    implements ProviderAvailabilityRepo {}

void main() {
  late MockProviderAvailabilityRepo mockRepo;
  late ProviderAvailabilityCubit cubit;

  final sampleAvailability = ProviderAvailabilityModel(
    providerId: 'p1',
    isAvailable: true,
    workingDays: ['Monday', 'Tuesday', 'Wednesday'],
    startHour: '09:00 AM',
    endHour: '05:00 PM',
    slots: ['09:00 AM', '10:00 AM'],
  );

  setUp(() {
    mockRepo = MockProviderAvailabilityRepo();
    cubit = ProviderAvailabilityCubit(mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('ProviderAvailabilityCubit Test Suite', () {
    test('initial state is ProviderAvailabilityInitial', () {
      expect(cubit.state, isA<ProviderAvailabilityInitial>());
    });

    blocTest<ProviderAvailabilityCubit, ProviderAvailabilityState>(
      'emits [ProviderAvailabilityLoading, ProviderAvailabilityLoaded] on fetchAvailability',
      build: () {
        when(() => mockRepo.getAvailability('p1'))
            .thenAnswer((_) async => sampleAvailability);
        return cubit;
      },
      act: (cubit) => cubit.fetchAvailability(providerId: 'p1'),
      expect: () => [
        isA<ProviderAvailabilityLoading>(),
        isA<ProviderAvailabilityLoaded>(),
      ],
      verify: (_) {
        expect(cubit.currentModel?.isAvailable, true);
        expect(cubit.currentModel?.workingDays.length, 3);
      },
    );

    blocTest<ProviderAvailabilityCubit, ProviderAvailabilityState>(
      'toggleDay adds and removes day from workingDays',
      build: () {
        when(() => mockRepo.getAvailability('p1'))
            .thenAnswer((_) async => sampleAvailability);
        return cubit;
      },
      act: (cubit) async {
        await cubit.fetchAvailability(providerId: 'p1');
        cubit.toggleDay('Thursday');
        expect(cubit.currentModel?.workingDays.contains('Thursday'), true);
        cubit.toggleDay('Thursday');
        expect(cubit.currentModel?.workingDays.contains('Thursday'), false);
      },
    );
  });
}
