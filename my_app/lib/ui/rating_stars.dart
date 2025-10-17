import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.color,
  });

  final double rating;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clampedRating = rating.clamp(0, 5);
    final fullStars = clampedRating.floor();
    final hasHalfStar = (clampedRating - fullStars) >= 0.5;
    final iconColor = color ?? theme.colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star_rounded, color: iconColor, size: size);
        }
        if (index == fullStars && hasHalfStar) {
          return Icon(Icons.star_half_rounded, color: iconColor, size: size);
        }
        return Icon(
          Icons.star_border_rounded,
          color: iconColor.withValues(alpha: 0.4),
          size: size,
        );
      }),
    );
  }
}
