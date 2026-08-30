import 'package:book_ease/core/theme/app_colors.dart';
import 'package:book_ease/features/discover/presentation/views/widgets/discover_view_body.dart';
import 'package:flutter/material.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: DiscoverViewBody(),
    );
  }
}
