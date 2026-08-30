import 'package:book_ease/features/booking/presentation/views/booking_view.dart';
import 'package:book_ease/features/admin/presentation/views/admin_view.dart';
import 'package:book_ease/features/register/presentation/views/register_view.dart';
import 'package:book_ease/features/splash/presentation/views/splash_view.dart';
import 'package:book_ease/features/login/presentation/views/login_view.dart';
import 'package:book_ease/features/messages/presentation/views/chat_view.dart';
import 'package:book_ease/features/notifications/presentation/views/notifications_view.dart';
import 'package:book_ease/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:book_ease/features/profile/presentation/views/edit_profile_view.dart';
import 'package:book_ease/features/provider_availability/presentation/views/provider_availability_view.dart';
import 'package:book_ease/features/role_selection/presentation/views/choose_role_view.dart';
import 'package:book_ease/features/root/presentation/views/root_view.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:book_ease/features/service_details/presentation/views/booking_summary_view.dart';
import 'package:book_ease/features/service_details/presentation/views/service_details_view.dart';
import 'package:book_ease/features/settings/presentation/views/settings_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onBoarding = '/on_boarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String chooseRole = '/choose_role';
  static const String root = '/root';
  static const String customerRoot = '/customer_root';
  static const String providerRoot = '/provider_root';
  static const String providerAvailability = '/provider_availability';
  static const String admin = '/admin';
  static const String booking = '/booking';
  static const String serviceDetails = '/service_details';
  static const String bookingSummary = '/booking_summary';
  static const String chat = '/chat';
  static const String editProfile = '/edit_profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashView());

      case onBoarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterView());

      case chooseRole:
        return MaterialPageRoute(builder: (_) => const ChooseRoleView());

      case root:
        return MaterialPageRoute(builder: (_) => const RootView());

      case customerRoot:
        return MaterialPageRoute(builder: (_) => const CustomerRootView());

      case providerRoot:
        return MaterialPageRoute(builder: (_) => const ProviderRootView());

      case providerAvailability:
        return MaterialPageRoute(builder: (_) => const ProviderAvailabilityView());

      case admin:
        return MaterialPageRoute(builder: (_) => const AdminView());

      case booking:
        return MaterialPageRoute(builder: (_) => const BookingView());

      case serviceDetails:
        final model = routeSettings.arguments as ServiceDetailsModel;
        return MaterialPageRoute(
          builder: (_) => ServiceDetailsView(model: model),
        );

      case bookingSummary:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BookingSummaryView(
            model: args['model'] as ServiceDetailsModel,
            selectedDate: args['selectedDate'] as DateTime,
            selectedTime: args['selectedTime'] as String,
          ),
        );

      case chat:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChatView(
            otherUserId: args['otherUserId'] as String,
            doctorName: args['doctorName'] as String,
            otherUserImage: args['otherUserImage'] as String?,
            otherUserSpecialty: args['otherUserSpecialty'] as String?,
          ),
        );

      case editProfile:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => EditProfileView(
            currentName: args['currentName'] as String? ?? '',
            currentEmail: args['currentEmail'] as String? ?? '',
            currentPhone: args['currentPhone'] as String?,
            currentPhotoUrl: args['currentPhotoUrl'] as String?,
          ),
        );

      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsView());

      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsView());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
        );
    }
  }
}
