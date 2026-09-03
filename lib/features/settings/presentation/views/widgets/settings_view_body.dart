import 'package:book_ease/core/routes/app_routes.dart';
import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/core/utils/app_animations.dart';
import 'package:book_ease/core/utils/app_reset_helper.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsViewBody extends StatefulWidget {
  const SettingsViewBody({super.key});

  @override
  State<SettingsViewBody> createState() => _SettingsViewBodyState();
}

class _SettingsViewBodyState extends State<SettingsViewBody> {
  bool _pushNotifications = true;
  bool _biometrics = true;
  bool _emailAlerts = false;
  bool _soundAndVibrate = true;
  String _selectedLanguage = "English (US)";

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          "Log out",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure you want to log out of your account?",
          style: TextStyle(color: AppColors.textSecondary, height: 1.4),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ScaleOnTap(
            onTap: () async {
              debugPrint('LOGOUT DIALOG: Confirm clicked');
              final navigator = Navigator.of(context, rootNavigator: true);
              final authCubit = context.read<AuthCubit>();

              Navigator.pop(dialogContext);

              AppResetHelper.resetAllUserData(context);

              try {
                await authCubit.signOut();
                debugPrint('LOGOUT DIALOG: Sign out complete');
              } catch (e) {
                debugPrint('Error signing out: $e');
              }

              debugPrint('LOGOUT DIALOG: Navigating to login...');
              navigator.pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cancelled,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cancelled.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                "Log out",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final languages = ["English (US)", "English (UK)", "العربية (Arabic)", "Français (French)", "Español (Spanish)"];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    "Select Language",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...languages.map((lang) => ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: Text(
                    lang,
                    style: TextStyle(
                      fontWeight: lang == _selectedLanguage ? FontWeight.bold : FontWeight.normal,
                      color: lang == _selectedLanguage ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  trailing: lang == _selectedLanguage
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedLanguage = lang);
                    Navigator.pop(ctx);
                  },
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top App Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ScaleOnTap(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary,
                    size: 16,
                  ),
                ),
              ),
              const Text(
                "Settings & Privacy",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),

        // Scrollable Body
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CARD 1: PREFERENCES
                _buildSectionHeader("Preferences"),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      _buildSwitchRow(
                        icon: Icons.notifications_active_rounded,
                        iconColor: const Color(0xFF3B82F6),
                        iconBg: const Color(0xFFEFF6FF),
                        title: "Push Notifications",
                        value: _pushNotifications,
                        onChanged: (val) => setState(() => _pushNotifications = val),
                      ),
                      const Divider(height: 1, color: AppColors.surfaceContainerLow),
                      _buildSwitchRow(
                        icon: Icons.fingerprint_rounded,
                        iconColor: const Color(0xFF6366F1),
                        iconBg: const Color(0xFFEEF2FF),
                        title: "Face ID / Biometrics",
                        value: _biometrics,
                        onChanged: (val) => setState(() => _biometrics = val),
                      ),
                      const Divider(height: 1, color: AppColors.surfaceContainerLow),
                      _buildSwitchRow(
                        icon: Icons.volume_up_rounded,
                        iconColor: const Color(0xFF8B5CF6),
                        iconBg: const Color(0xFFF5F3FF),
                        title: "Sound & Vibrations",
                        value: _soundAndVibrate,
                        onChanged: (val) => setState(() => _soundAndVibrate = val),
                      ),
                      const Divider(height: 1, color: AppColors.surfaceContainerLow),
                      _buildSwitchRow(
                        icon: Icons.mark_email_read_rounded,
                        iconColor: const Color(0xFF10B981),
                        iconBg: const Color(0xFFECFDF5),
                        title: "Email Appointment Updates",
                        value: _emailAlerts,
                        onChanged: (val) => setState(() => _emailAlerts = val),
                      ),
                      const Divider(height: 1, color: AppColors.surfaceContainerLow),
                      _buildNavigationRow(
                        icon: Icons.language_rounded,
                        iconColor: const Color(0xFF06B6D4),
                        iconBg: const Color(0xFFECFEFF),
                        title: "Language",
                        trailingText: _selectedLanguage,
                        onTap: _showLanguagePicker,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // CARD 2: ACCOUNT & SECURITY
                _buildSectionHeader("Account & Security"),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      _buildNavigationRow(
                        icon: Icons.lock_outline_rounded,
                        iconColor: const Color(0xFF6366F1),
                        iconBg: const Color(0xFFEEF2FF),
                        title: "Change Password",
                        trailingIcon: Icons.chevron_right_rounded,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Password reset email sent or manage credentials"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: AppColors.surfaceContainerLow),
                      _buildNavigationRow(
                        icon: Icons.shield_outlined,
                        iconColor: const Color(0xFF10B981),
                        iconBg: const Color(0xFFECFDF5),
                        title: "Privacy & Data Permissions",
                        trailingIcon: Icons.chevron_right_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // CARD 3: LEGAL & SUPPORT
                _buildSectionHeader("Legal & Support"),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "App Version",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Text(
                                "2.6.0 Production",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.surfaceContainerLow),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Terms of Service",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.open_in_new_rounded, size: 16, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.surfaceContainerLow),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Privacy Policy",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.open_in_new_rounded, size: 16, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // LOGOUT CARD
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cancelled.withValues(alpha: 0.2)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _showLogoutDialog(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              height: 38,
                              width: 38,
                              decoration: BoxDecoration(
                                color: AppColors.cancelled.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.logout_rounded,
                                color: AppColors.cancelled,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Text(
                                "Log Out",
                                style: TextStyle(
                                  color: AppColors.cancelled,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.cancelled,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // STICKY BOTTOM SAVE BUTTON
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.7))),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: ScaleOnTap(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: const [
                        Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
                          "Settings saved successfully",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.confirmed,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 2),
                  ),
                );
                Navigator.maybePop(context);
              },
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryGradientStart,
                      AppColors.primaryGradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Save Settings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    String? trailingText,
    IconData? trailingIcon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (trailingIcon != null)
              Icon(trailingIcon, color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}
