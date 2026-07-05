import 'package:flutter/material.dart';

class ProviderRootView extends StatelessWidget {
  const ProviderRootView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Provider Home", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
