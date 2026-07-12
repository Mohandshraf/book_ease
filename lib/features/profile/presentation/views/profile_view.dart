import 'package:book_ease/features/profile/presentation/views/widgets/profile_stat_card.dart';
import 'package:book_ease/features/profile/presentation/views/widgets/profile_view_body.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 360,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      color: Color(0xff0B1F44),
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xffE2E8F0)),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xff0B1F44),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xffDDFBF0),
                          width: 3,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 42,
                        backgroundImage: NetworkImage(
                          "https://picsum.photos/200",
                        ),
                      ),
                    ),

                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xff0B9B7B),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 17,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 18),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Alex Johnson",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0B1F44),
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        "alex.johnson@email.com",
                        style: TextStyle(
                          color: Color(0xff64748B),
                          fontSize: 17,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "Member since Jan 2024",
                        style: TextStyle(
                          color: Color(0xff94A3B8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Row(
              children: [
                Expanded(
                  child: ProfileStatCard(number: "24", title: "Bookings"),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: ProfileStatCard(number: "12", title: "Reviews"),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: ProfileStatCard(number: "8", title: "Saved"),
                ),
              ],
            ),
          ],
        ),
      ),

      body:  ProfileViewBody(),
    );
  }
}
