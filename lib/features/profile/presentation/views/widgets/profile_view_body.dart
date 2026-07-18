import 'package:book_ease/features/profile/presentation/views/widgets/profile_card.dart';
import 'package:book_ease/features/profile/presentation/views/widgets/menu_option_tile.dart';
import 'package:book_ease/features/settings/presentation/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Profile",
                style: TextStyle(
                  color: Color(0xff0B1F44),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsView(),
                    ),
                  );
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: Color(0xff0B1F44),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Profile Card
          ProfileCard(
            name: "Alex Johnson",
            email: "alex.johnson@email.com",
            imageUrl: "https://picsum.photos/id/64/200",
            onEditTap: () {
              // Edit profile action
            },
          ),

          // Menu Options
          MenuOptionTile(
            icon: Icons.calendar_month_outlined,
            title: "My bookings",
            iconColor: const Color(0xff0B9B7B),
            iconBackgroundColor: const Color(0xffEAFDF6),
            onTap: () {
              // Action or navigation
            },
          ),
          MenuOptionTile(
            icon: Icons.favorite_outline_rounded,
            title: "Saved providers",
            iconColor: const Color(0xff0B9B7B),
            iconBackgroundColor: const Color(0xffEAFDF6),
            onTap: () {
              // Action
            },
          ),
          MenuOptionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: "Messages",
            iconColor: const Color(0xff0B9B7B),
            iconBackgroundColor: const Color(0xffEAFDF6),
            onTap: () {
              // Action
            },
          ),
          MenuOptionTile(
            icon: Icons.notifications_none_rounded,
            title: "Notifications",
            iconColor: const Color(0xff0B9B7B),
            iconBackgroundColor: const Color(0xffEAFDF6),
            onTap: () {
              // Action
            },
          ),
        ],
      ),
    );
  }
}
