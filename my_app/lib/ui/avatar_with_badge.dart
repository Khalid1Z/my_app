import 'package:flutter/material.dart';

class AvatarWithBadge extends StatelessWidget {
  const AvatarWithBadge({
    super.key,
    this.image,
    this.initials,
    this.size = 56,
    this.isOnline = false,
    this.backgroundColor,
  });

  final ImageProvider? image;
  final String? initials;
  final double size;
  final bool isOnline;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fallbackInitials = (initials == null || initials!.isEmpty)
        ? '--'
        : initials!.substring(0, initials!.length >= 2 ? 2 : 1).toUpperCase();

    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CircleAvatar(
              backgroundColor: backgroundColor ?? colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              radius: size / 2,
              backgroundImage: image,
              child: image == null
                  ? Text(
                      fallbackInitials,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: size * 0.34,
                      ),
                    )
                  : null,
            ),
          ),
          if (isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: size * 0.28,
                height: size * 0.28,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Container(
                  width: size * 0.2,
                  height: size * 0.2,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
