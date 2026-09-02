import 'package:bloc_test/bloc_test.dart';
import 'package:book_ease/features/profile/cubit/saved_providers_cubit.dart';
import 'package:book_ease/features/profile/cubit/saved_providers_state.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;
  late SavedProvidersCubit cubit;

  final testDoctor1 = ServiceDetailsModel(
    serviceId: 'doc_test_1',
    providerId: 'provider_test_1',
    providerName: 'Dr. John Doe',
    title: 'Cardiologist Consultation',
    location: 'Central Hospital',
    rating: 4.8,
    reviewsCount: 120,
    price: 90.0,
    priceUnit: 'per visit',
    imageUrl: 'https://example.com/john.png',
    aboutText: 'Experienced cardiologist.',
    specialties: const ['Cardiology', 'Cardiologist'],
    availableDates: const [],
    availableTimes: const [],
  );

  final testDoctor2 = ServiceDetailsModel(
    serviceId: 'doc_test_2',
    providerId: 'provider_test_2',
    providerName: 'Dr. Jane Smith',
    title: 'Dentist Checkup',
    location: 'Smile Clinic',
    rating: 4.9,
    reviewsCount: 85,
    price: 75.0,
    priceUnit: 'per visit',
    imageUrl: 'https://example.com/jane.png',
    aboutText: 'Specialist dentist.',
    specialties: const ['Dentist', 'Dental Surgery'],
    availableDates: const [],
    availableTimes: const [],
  );

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    when(() => mockAuth.currentUser).thenReturn(null);
    cubit = SavedProvidersCubit(firestore: mockFirestore, auth: mockAuth);
  });

  tearDown(() {
    cubit.close();
  });

  group('SavedProvidersCubit Test Suite', () {
    test('initial state is SavedProvidersInitial', () {
      expect(cubit.state, isA<SavedProvidersInitial>());
      expect(cubit.state.savedDoctors, isEmpty);
      expect(cubit.state.savedIds, isEmpty);
    });

    test('isSaved returns true for saved doctor and false otherwise', () {
      final docId = testDoctor1.serviceId!;
      expect(cubit.isSaved(docId), isFalse);

      cubit.toggleSaveDoctor(testDoctor1);
      expect(cubit.isSaved(docId), isTrue);
    });

    blocTest<SavedProvidersCubit, SavedProvidersState>(
      'loadSavedProviders emits [SavedProvidersLoading, SavedProvidersLoaded] when unauthenticated',
      build: () => cubit,
      act: (c) => c.loadSavedProviders(),
      expect: () => [
        isA<SavedProvidersLoading>(),
        isA<SavedProvidersLoaded>(),
      ],
    );

    blocTest<SavedProvidersCubit, SavedProvidersState>(
      'toggleSaveDoctor adds doctor to saved list when not already saved',
      build: () => cubit,
      act: (c) => c.toggleSaveDoctor(testDoctor1),
      expect: () => [
        isA<SavedProvidersLoaded>().having(
          (s) => s.savedIds.contains('doc_test_1'),
          'savedIds contains doc_test_1',
          isTrue,
        ),
      ],
      verify: (c) {
        expect(c.isSaved('doc_test_1'), isTrue);
        expect(c.state.savedDoctors.length, 1);
        expect(c.state.savedDoctors.first.providerName, 'Dr. John Doe');
      },
    );

    blocTest<SavedProvidersCubit, SavedProvidersState>(
      'toggleSaveDoctor removes doctor when called twice',
      build: () => cubit,
      act: (c) async {
        await c.toggleSaveDoctor(testDoctor2);
        await c.toggleSaveDoctor(testDoctor2);
      },
      expect: () => [
        isA<SavedProvidersLoaded>().having(
          (s) => s.savedIds.contains('doc_test_2'),
          'first toggle adds doc_test_2',
          isTrue,
        ),
        isA<SavedProvidersLoaded>().having(
          (s) => s.savedIds.contains('doc_test_2'),
          'second toggle removes doc_test_2',
          isFalse,
        ),
      ],
      verify: (c) {
        expect(c.isSaved('doc_test_2'), isFalse);
        expect(c.state.savedDoctors, isEmpty);
      },
    );

    blocTest<SavedProvidersCubit, SavedProvidersState>(
      'removeSavedDoctor removes doctor by serviceId',
      build: () => cubit,
      seed: () => SavedProvidersLoaded(
        savedDoctors: [testDoctor1],
        savedIds: {'doc_test_1'},
      ),
      act: (c) => c.removeSavedDoctor('doc_test_1'),
      expect: () => [
        isA<SavedProvidersLoaded>().having(
          (s) => s.savedIds.contains('doc_test_1'),
          'savedIds does not contain doc_test_1',
          isFalse,
        ),
      ],
      verify: (c) {
        expect(c.isSaved('doc_test_1'), isFalse);
      },
    );
  });
}
