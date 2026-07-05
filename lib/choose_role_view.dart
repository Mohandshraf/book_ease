import 'package:book_ease/core/app_colors.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/auth_state.dart';
import 'package:book_ease/root_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ChooseRoleView extends StatelessWidget {
  const ChooseRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const RootView()),
          );
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xffebfcf4),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(70),

                const Center(
                  child: CircleAvatar(
                    radius: 38,
                    backgroundColor: Color(0xffDDFBF0),
                    child: Icon(
                      Icons.person_outline,
                      size: 40,
                      color: AppColors.ksecondColor,
                    ),
                  ),
                ),

                const Gap(32),

                const Text(
                  "Welcome to BookEase",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
                ),

                const Gap(10),

                Text(
                  "Choose how you want to use the app",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),

                const Gap(45),

                _RoleCard(
                  icon: Icons.search_rounded,
                  title: "Looking for Services",
                  subtitle: "Book appointments easily",
                  onTap: () {
                    context.read<AuthCubit>().saveRole(role: "customer");
                  },
                ),

                const Gap(20),

                _RoleCard(
                  icon: Icons.business_center_outlined,
                  title: "I Provide Services",
                  subtitle: "Manage your bookings",
                  onTap: () {
                    context.read<AuthCubit>().saveRole(role: "provider");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xffDDFBF0),
              child: Icon(icon, color: AppColors.ksecondColor, size: 30),
            ),

            const Gap(18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Gap(5),

                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.ksecondColor,
            ),
          ],
        ),
      ),
    );
  }
}
