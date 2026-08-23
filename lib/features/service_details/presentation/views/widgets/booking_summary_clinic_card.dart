import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BookingSummaryClinicCard extends StatelessWidget {
  final ServiceDetailsModel model;

  const BookingSummaryClinicCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              model.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 70,
                height: 70,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image_not_supported_rounded),
              ),
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0B1F44),
                  ),
                ),
                const Gap(4),
                Text(
                  model.providerName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(6),
                Row(
                  children: const [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                    Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                    Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                    Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                    Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                    Gap(4),
                    Text(
                      "(284)",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff94A3B8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
