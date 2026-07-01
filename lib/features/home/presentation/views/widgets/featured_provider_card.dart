import 'package:flutter/material.dart';

class FeaturedProviderCard extends StatelessWidget {
  const FeaturedProviderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Stack(
            children: [

              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Image.network(
                  "https://picsum.photos/300/180",
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "⭐ 4.9",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff0B9B7B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "\$80",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "City Medical Clinic",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  "General & Family Medicine",
                  style: TextStyle(color: Colors.grey),
                ),

                SizedBox(height: 8),

                Text(
                  "📍 Downtown, 0.8 km",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}