import 'package:book_ease/core/app_colors.dart';
import 'package:book_ease/features/messages/presentation/views/chat_view.dart';
import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ServiceDetailsInfoSection extends StatelessWidget {
  final ServiceDetailsModel model;

  const ServiceDetailsInfoSection({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final effectiveProviderId = (model.providerId != null && model.providerId!.isNotEmpty)
        ? model.providerId!
        : model.providerName.toLowerCase().replaceAll(RegExp(r'\s+'), '_');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Price Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0B1F44),
                    ),
                  ),
                  const Gap(6),
                  Text(
                    model.providerName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$${model.price.toInt()}",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ksecondColor,
                  ),
                ),
                Text(
                  model.priceUnit,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Gap(8),
        // Location Row
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 16,
              color: Color(0xff94A3B8),
            ),
            const Gap(4),
            Text(
              model.location,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff94A3B8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Gap(16),
        // Specialty Chips and Message Button Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: model.specialties.map((specialty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffDDFBF0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      specialty,
                      style: const TextStyle(
                        color: AppColors.ksecondColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Gap(12),
            // Message Provider Action Button
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatView(
                      otherUserId: effectiveProviderId,
                      doctorName: model.providerName,
                      otherUserImage: model.providerImage ?? model.imageUrl,
                      otherUserSpecialty: model.specialties.isNotEmpty
                          ? model.specialties.first
                          : "Specialist",
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffEAFDF6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xffBEE7DF)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 18,
                      color: Color(0xff0B9B7B),
                    ),
                    Gap(6),
                    Text(
                      "Message",
                      style: TextStyle(
                        color: Color(0xff0B9B7B),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Gap(24),
        // About Section
        const Text(
          "About",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff0B1F44),
          ),
        ),
        const Gap(8),
        Text(
          model.aboutText,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xff64748B),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
