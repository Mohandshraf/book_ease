import 'package:bloc_test/bloc_test.dart';
import 'package:book_ease/features/provider_services/data/cubit/provider_services_cubit.dart';
import 'package:book_ease/features/provider_services/data/cubit/provider_services_state.dart';
import 'package:book_ease/features/provider_services/data/models/service_model.dart';
import 'package:book_ease/features/provider_services/data/repo/provider_services_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProviderServicesRepo extends Mock implements ProviderServicesRepo {}

void main() {
  late MockProviderServicesRepo mockRepo;
  late ProviderServicesCubit cubit;

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
    mockRepo = MockProviderServicesRepo();
    cubit = ProviderServicesCubit(mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('ProviderServicesCubit Tests', () {
    test('initial state is ProviderServicesInitial', () {
      expect(cubit.state, isA<ProviderServicesInitial>());
    });

    blocTest<ProviderServicesCubit, ProviderServicesState>(
      'emits [ProviderServicesLoading, ProviderServicesSuccess] on fetchServices',
      build: () {
        when(() => mockRepo.getProviderServices('p1'))
            .thenAnswer((_) async => [sampleService]);
        return cubit;
      },
      act: (cubit) => cubit.fetchServices(providerId: 'p1'),
      expect: () => [
        isA<ProviderServicesLoading>(),
        isA<ProviderServicesSuccess>(),
      ],
      verify: (_) {
        expect(cubit.services.length, 1);
        expect(cubit.services.first.title, 'Consultation');
      },
    );

    blocTest<ProviderServicesCubit, ProviderServicesState>(
      'emits [ProviderServicesLoading, ProviderServicesSuccess] on subscribeToServices',
      build: () {
        when(() => mockRepo.getProviderServicesStream('p1'))
            .thenAnswer((_) => Stream.value([sampleService]));
        return cubit;
      },
      act: (cubit) => cubit.subscribeToServices(providerId: 'p1'),
      expect: () => [
        isA<ProviderServicesLoading>(),
        isA<ProviderServicesSuccess>(),
      ],
    );
  });
}
