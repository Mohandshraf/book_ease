import 'package:book_ease/features/discover/presentation/views/widgets/discover_view_body.dart';
import 'package:flutter/material.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffF8FAFC),
      body: DiscoverViewBody(),
    );
  }
}
