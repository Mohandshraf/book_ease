import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:book_ease/features/root/presentation/views/customer_root_view.dart';
import 'package:book_ease/features/root/presentation/views/provider_root_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'customer_root_view.dart';
export 'provider_root_view.dart';

class RootView extends StatefulWidget {
  final int initialIndex;

  const RootView({super.key, this.initialIndex = 0});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  @override
  void initState() {
    super.initState();
    final userCubitState = context.read<UserCubit>().state;
    if (userCubitState is! UserDataLoaded) {
      context.read<UserCubit>().getCurrentUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      buildWhen: (previous, current) {
        if (current is UserDataLoaded) return true;
        if (previous is! UserDataLoaded) return true;
        return false;
      },
      builder: (context, state) {
        if (state is UserDataLoading && state is! UserDataLoaded) {
          if (FirebaseAuth.instance.currentUser != null) {
            return CustomerRootView(initialIndex: widget.initialIndex);
          }
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state is UserDataFailure) {
          if (FirebaseAuth.instance.currentUser != null) {
            return CustomerRootView(initialIndex: widget.initialIndex);
          }
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.errorMessage,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () =>
                        context.read<UserCubit>().getCurrentUserData(),
                    child: const Text("Retry",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is UserDataLoaded) {
          final role = state.userData["role"];
          if (role == "provider") {
            return const ProviderRootView();
          }
          return CustomerRootView(initialIndex: widget.initialIndex);
        }

        if (FirebaseAuth.instance.currentUser != null) {
          return CustomerRootView(initialIndex: widget.initialIndex);
        }

        return const Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      },
    );
  }
}
