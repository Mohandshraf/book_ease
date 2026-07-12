import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 25, 24, 30),
      decoration: const BoxDecoration(color: Color(0xff0B9B7B)),
      child: Column(
        children: [
          // Row(
          //   children: [
          //     const Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "Good morning,",
          //             style: TextStyle(color: Colors.white70),
          //           ),

          //           SizedBox(height: 4),

          //           Text(
          //             "Alex Johnson 👋",
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 30,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),

          //     CircleAvatar(
          //       radius: 28,
          //       backgroundImage: NetworkImage("https://picsum.photos/200"),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 25),

          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 18),
          //   height: 60,
          //   decoration: BoxDecoration(
          //     color: Colors.white24,
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: const Row(
          //     children: [
          //       Icon(Icons.search, color: Colors.white70),

          //       SizedBox(width: 10),

          //       Expanded(
          //         child: Text(
          //           "Search providers, services...",
          //           style: TextStyle(color: Colors.white70),
          //         ),
          //       ),

          //       CircleAvatar(
          //         backgroundColor: Colors.white24,
          //         child: Icon(Icons.tune, color: Colors.white),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
