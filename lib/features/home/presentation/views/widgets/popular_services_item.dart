import 'package:flutter/material.dart';

class PopularServiceItem extends StatelessWidget {
  const PopularServiceItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 12),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              "https://picsum.photos/90",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 15),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "City Medical Clinic",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                SizedBox(height: 5),

                Text(
                  "Dr. Sarah Mitchell",
                  style: TextStyle(color: Colors.grey),
                ),

                SizedBox(height: 8),

                Text("⭐⭐⭐⭐⭐ (284)", style: TextStyle(color: Colors.orange)),
              ],
            ),
          ),

          const Column(
            children: [
              Text(
                "\$80",
                style: TextStyle(
                  color: Color(0xff0B9B7B),
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),

              Text("per visit", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
