import 'package:book_ease/features/service_details/data/service_details_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ServiceDetailsHeaderImage extends StatefulWidget {
  final ServiceDetailsModel model;

  const ServiceDetailsHeaderImage({super.key, required this.model});

  @override
  State<ServiceDetailsHeaderImage> createState() =>
      _ServiceDetailsHeaderImageState();
}

class _ServiceDetailsHeaderImageState extends State<ServiceDetailsHeaderImage> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 320,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.model.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 320,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0x66000000),
                Colors.transparent,
                Color(0x44000000),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Top Action Buttons
        Positioned(
          top: 48,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(50),
                    border: Border.all(color: Colors.white.withAlpha(50)),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              // Favorite/Like Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(50),
                    border: Border.all(color: Colors.white.withAlpha(50)),
                  ),
                  child: Icon(
                    isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isLiked ? Colors.red : Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Rating Badge
        Positioned(
          bottom: 20,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xCC0B1F44),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 18,
                ),
                const Gap(4),
                Text(
                  "${widget.model.rating} (${widget.model.reviewsCount} reviews)",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
