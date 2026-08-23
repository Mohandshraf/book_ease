import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/widgets/user_avatar.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ProviderProfileHeaderCard extends StatelessWidget {
  const ProviderProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        String name = "";
        String email = user?.email ?? "";
        String? photoUrl = user?.photoURL;
        Map<String, dynamic> userData = {};

        if (state is UserDataLoaded) {
          userData = state.userData;
          final docName = state.userData["name"] as String?;
          if (docName != null && docName.trim().isNotEmpty) {
            name = docName.trim();
          }
          final docEmail = state.userData["email"] as String?;
          if (docEmail != null && docEmail.trim().isNotEmpty) {
            email = docEmail.trim();
          }
          photoUrl = state.userData["photoUrl"] as String? ?? photoUrl;
        }

        if (name.isEmpty) {
          final displayName = user?.displayName;
          if (displayName != null && displayName.trim().isNotEmpty) {
            name = displayName.trim();
          } else {
            name = "Doctor";
          }
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              UserAvatar(
                imageUrl: photoUrl,
                name: name,
                radius: 34,
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(3),
                    Text(
                      email.isNotEmpty ? email : "Provider Account",
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(6),
                    Row(
                      children: const [
                        Icon(Icons.star_rounded,
                            color: AppColors.star, size: 16),
                        Gap(4),
                        Text(
                          "4.9",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Gap(4),
                        Text(
                          "(124 reviews)",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.editProfile,
                    arguments: {
                      'currentName': name,
                      'currentEmail': email,
                      'currentPhone': userData['phone'],
                      'currentPhotoUrl': photoUrl,
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
