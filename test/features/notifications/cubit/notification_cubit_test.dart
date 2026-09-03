import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_cubit.dart';
import 'package:book_ease/features/notifications/data/cubit/notification_state.dart';
import 'package:book_ease/features/notifications/data/models/notification_model.dart';
import 'package:book_ease/features/notifications/data/repo/notification_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepo extends Mock implements NotificationRepo {}

void main() {
  late MockNotificationRepo mockRepo;
  late NotificationCubit cubit;

  final sampleNotification1 = NotificationModel(
    id: 'n1',
    userId: 'u1',
    title: 'New Booking Request',
    body: 'John Doe booked Consultation',
    type: 'booking_created',
    relatedId: 'b1',
    isRead: false,
    createdAt: DateTime(2026, 8, 20, 10, 0),
  );

  final sampleNotification2 = NotificationModel(
    id: 'n2',
    userId: 'u1',
    title: 'Booking Confirmed',
    body: 'Your appointment has been confirmed',
    type: 'booking_confirmed',
    relatedId: 'b1',
    isRead: true,
    createdAt: DateTime(2026, 8, 20, 9, 0),
  );

  setUp(() {
    mockRepo = MockNotificationRepo();
    cubit = NotificationCubit(mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('NotificationCubit Tests', () {
    test('initial state is NotificationInitial', () {
      expect(cubit.state, isA<NotificationInitial>());
    });

    blocTest<NotificationCubit, NotificationState>(
      'subscribes to notifications stream and emits NotificationLoaded with correct unread count',
      build: () {
        when(() => mockRepo.getNotificationsStream()).thenAnswer(
          (_) => Stream.value([sampleNotification1, sampleNotification2]),
        );
        return cubit;
      },
      act: (cubit) => cubit.subscribeToNotifications(),
      expect: () => [
        isA<NotificationLoading>(),
        isA<NotificationLoaded>()
            .having((s) => s.notifications.length, 'notifications length', 2)
            .having((s) => s.unreadCount, 'unread count', 1),
      ],
    );

    blocTest<NotificationCubit, NotificationState>(
      'marks notification as read via repo',
      build: () {
        when(() => mockRepo.markAsRead('n1')).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.markAsRead('n1'),
      verify: (_) {
        verify(() => mockRepo.markAsRead('n1')).called(1);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'optimistically updates state when marking single notification as read in NotificationLoaded',
      build: () {
        when(() => mockRepo.markAsRead('n1')).thenAnswer((_) async {});
        return cubit;
      },
      seed: () => NotificationLoaded(
        notifications: [sampleNotification1, sampleNotification2],
        unreadCount: 1,
      ),
      act: (cubit) => cubit.markAsRead('n1'),
      expect: () => [
        isA<NotificationLoaded>()
            .having((s) => s.unreadCount, 'unread count', 0)
            .having((s) => s.notifications.first.isRead, 'n1 isRead', true),
      ],
      verify: (_) {
        verify(() => mockRepo.markAsRead('n1')).called(1);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'marks all notifications as read via repo',
      build: () {
        when(() => mockRepo.markAllAsRead()).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.markAllAsRead(),
      verify: (_) {
        verify(() => mockRepo.markAllAsRead()).called(1);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'optimistically updates state when marking all notifications as read in NotificationLoaded',
      build: () {
        when(() => mockRepo.markAllAsRead()).thenAnswer((_) async {});
        return cubit;
      },
      seed: () => NotificationLoaded(
        notifications: [sampleNotification1, sampleNotification2],
        unreadCount: 1,
      ),
      act: (cubit) => cubit.markAllAsRead(),
      expect: () => [
        isA<NotificationLoaded>()
            .having((s) => s.unreadCount, 'unread count', 0)
            .having((s) => s.notifications.every((n) => n.isRead), 'all isRead', true),
      ],
      verify: (_) {
        verify(() => mockRepo.markAllAsRead()).called(1);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'deletes notification via repo',
      build: () {
        when(() => mockRepo.deleteNotification('n1')).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.deleteNotification('n1'),
      verify: (_) {
        verify(() => mockRepo.deleteNotification('n1')).called(1);
      },
    );
  });
}
