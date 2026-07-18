import 'package:book_ease/features/settings/presentation/views/widgets/settings_view_body.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffF8FAFC),
      body: SafeArea(
        child: SettingsViewBody(),
      ),
    );
  }
}
