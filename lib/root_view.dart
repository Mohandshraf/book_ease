import 'package:book_ease/custom_provider_view.dart';
import 'package:book_ease/custom_root_view.dart';
import 'package:book_ease/features/auth/data/UserCubit/cubit/user_cubit_cubit.dart';
import 'package:book_ease/features/auth/data/UserCubit/cubit/user_cubit_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, state) {
        if (state is UserDataLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is UserDataFailure) {
          return Scaffold(body: Center(child: Text(state.errorMessage)));
        }

        if (state is UserDataLoaded) {
          final role = state.userData["role"];

          if (role == "customer") {
            return const CustomerRootView();
          }

          return const ProviderRootView();
        }

        return const SizedBox();
      },
    );
  }
}
