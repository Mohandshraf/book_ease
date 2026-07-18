import 'package:flutter/material.dart';

class PopularSearchesCard extends StatelessWidget {
  final List<String> popularSearches;
  final ValueChanged<String>? onSearchTap;

  const PopularSearchesCard({
    super.key,
    required this.popularSearches,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Popular searches",
            style: TextStyle(
              color: Color(0xff0B1F44),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: popularSearches.map((search) {
              return GestureDetector(
                onTap: () => onSearchTap?.call(search),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1F5F9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    search,
                    style: const TextStyle(
                      color: Color(0xff475569),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
