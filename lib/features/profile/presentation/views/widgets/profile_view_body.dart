import 'package:flutter/material.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          children: [
            ProfileMenuTile(
              icon: Icons.notifications_none_rounded,
              title: "Notifications",
              subtitle: "Manage your alerts",
              onTap: () {},
            ),

            ProfileMenuTile(
              icon: Icons.credit_card_outlined,
              title: "Payment Methods",
              subtitle: "Cards & wallets",
              onTap: () {},
            ),

            ProfileMenuTile(
              icon: Icons.location_on_outlined,
              title: "Saved Addresses",
              subtitle: "Home, Work & more",
              onTap: () {},
            ),

            ProfileMenuTile(
              icon: Icons.settings_outlined,
              title: "App Settings",
              subtitle: "Language, theme & more",
              onTap: () {},
            ),

            ProfileMenuTile(
              icon: Icons.call_outlined,
              title: "Help & Support",
              subtitle: "FAQs & contact us",
              onTap: () {},
            ),

            ProfileMenuTile(
              icon: Icons.logout_rounded,
              title: "Sign Out",
              subtitle: "Log out of account",
              iconBackground: const Color(0xffFFF2F2),
              iconColor: Colors.red,
              titleColor: Colors.red,
              showDivider: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconBackground = const Color(0xffDDFBF0),
    this.iconColor = const Color(0xff0B9B7B),
    this.titleColor = const Color(0xff0B1F44),
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  final Color iconBackground;
  final Color iconColor;
  final Color titleColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xff94A3B8),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  size: 30,
                  color: Color(0xffCBD5E1),
                ),
              ],
            ),
          ),

          if (showDivider)
            const Divider(
              height: 1,
              indent: 86,
              endIndent: 20,
              color: Color(0xffEDF2F7),
            ),
        ],
      ),
    );
  }
}
