import 'package:book_ease/features/home/presentation/views/widgets/home_view.dart';
import 'package:flutter/material.dart';

class CustomerRootView extends StatefulWidget {
  const CustomerRootView({super.key});

  @override
  State<CustomerRootView> createState() => _CustomerRootViewState();
}

class _CustomerRootViewState extends State<CustomerRootView> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeView(),

    Scaffold(
      body: Center(child: Text("Bookings", style: TextStyle(fontSize: 24))),
    ),

    Scaffold(
      body: Center(child: Text("Profile", style: TextStyle(fontSize: 24))),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

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
        ],
      ),
    );
  }
}
