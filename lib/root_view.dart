import 'package:book_ease/features/home/presentation/views/widgets/home_view.dart';
import 'package:flutter/material.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeView(),
    Scaffold(
      body: Center(child: Text("Bookings", style: TextStyle(fontSize: 24))),
    ),

    Scaffold(
      body: Center(child: Text("Admin", style: TextStyle(fontSize: 24))),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),

      bottomNavigationBar: NavigationBar(
        height: 78,
        selectedIndex: currentIndex,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xffDDFBF0),

        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),

          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: "Bookings",
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          ),

          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: "Admin",
          ),
        ],
      ),
    );
  }
}
