import 'package:flutter/material.dart';

class DiscoverProviderCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String rating;
  final String reviews;
  final String price;
  final String image;
  final VoidCallback onTap;

  const DiscoverProviderCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Doctor Profile Image
            CircleAvatar(
              radius: 36,
              backgroundImage: NetworkImage(image),
              backgroundColor: const Color(0xffE2E8F0),
            ),
            const SizedBox(width: 16),
            // Doctor Metadata
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Color(0xff0B1F44),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xff64748B),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xffF59E0B),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Color(0xff0B1F44),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "($reviews)",
                        style: const TextStyle(
                          color: Color(0xff94A3B8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Starting Price
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                price,
                style: const TextStyle(
                  color: Color(0xff0B9B7B),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
