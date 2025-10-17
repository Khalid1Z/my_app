import 'package:flutter/material.dart';

import 'package:my_app/ui/app_spacing.dart';

enum AppButtonVariant { primary, ghost }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.leading,
    this.trailing,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? leading;
  final Widget? trailing;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleSmall;
    final child = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: expand
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: AppSpacing.small),
        ],
        Text(label, style: textStyle),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.small),
          trailing!,
        ],
      ],
    );

    switch (variant) {
      case AppButtonVariant.primary:
        return expand
            ? FilledButton(
                onPressed: onPressed,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: child,
              )
            : FilledButton(onPressed: onPressed, child: child);
      case AppButtonVariant.ghost:
        return expand
            ? OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: child,
              )
            : OutlinedButton(onPressed: onPressed, child: child);
    }
  }
}
