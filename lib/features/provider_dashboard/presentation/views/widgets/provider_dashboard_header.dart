import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/auth/data/cubit/user_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderDashboardHeader extends StatelessWidget {
  const ProviderDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, userState) {
        final currentUser = FirebaseAuth.instance.currentUser;
        String name = '';
        String email = '';
        String? photoUrl;

        if (userState is UserDataLoaded) {
          final docName = userState.userData['name'] as String?;
          if (docName != null && docName.trim().isNotEmpty) {
            name = docName.trim();
          }
          final docEmail = userState.userData['email'] as String?;
          if (docEmail != null && docEmail.trim().isNotEmpty) {
            email = docEmail.trim();
          }
          photoUrl = userState.userData['photoUrl'] as String?;
        }

        // Fallback to FirebaseAuth currentUser displayName if not present in doc
        if (name.isEmpty) {
          final displayName = currentUser?.displayName;
          if (displayName != null && displayName.trim().isNotEmpty) {
            name = displayName.trim();
          }
        }

        if (email.isEmpty && currentUser?.email != null) {
          email = currentUser!.email!;
        }
        if (photoUrl == null || photoUrl.isEmpty) {
          photoUrl = currentUser?.photoURL;
        }

        final String displayDoctorName;
        if (name.isEmpty || name.toLowerCase() == 'doctor' || name.toLowerCase() == 'user' || name.toLowerCase() == 'provider') {
          displayDoctorName = 'Doctor';
        } else if (name.startsWith('Dr.') || name.startsWith('Dr ')) {
          displayDoctorName = name;
        } else {
          displayDoctorName = 'Dr. $name';
        }

        final String avatarLetter = (name.isNotEmpty && name.toLowerCase() != 'doctor' && name.toLowerCase() != 'user' && name.toLowerCase() != 'provider')
            ? name[0].toUpperCase()
            : 'D';

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                    ? NetworkImage(photoUrl)
                    : null,
                child: photoUrl == null || photoUrl.isEmpty
                    ? Text(
                        avatarLetter,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back,',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayDoctorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (email.isNotEmpty)
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 4,
                      backgroundColor: Color(0xFF4ADE80),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Online',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
