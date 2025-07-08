import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum ButtonStyleType { filled, outlined }

class Button extends StatelessWidget {
  const Button.filled({
    super.key,
    required this.onPressed,
    required this.label,
    this.width = double.infinity,
    this.height = 56.0,
    this.borderRadius = 12.0,
    this.icon,
    this.suffixIcon,
    this.disabled = false,
    this.fontSize = 16.0,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
  }) : style = ButtonStyleType.filled;

  const Button.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.width = double.infinity,
    this.height = 56.0,
    this.borderRadius = 12.0,
    this.icon,
    this.suffixIcon,
    this.disabled = false,
    this.fontSize = 16.0,
    this.color = Colors.transparent,
    this.textColor = AppColors.primary,
  }) : style = ButtonStyleType.outlined;

  final VoidCallback? onPressed;
  final String label;
  final ButtonStyleType style;
  final Color color;
  final Color textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool disabled;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final Widget child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) icon!,
        if (icon != null && label.isNotEmpty) const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (suffixIcon != null && label.isNotEmpty) const SizedBox(width: 8),
        if (suffixIcon != null) suffixIcon!,
      ],
    );

    return SizedBox(
      height: height,
      width: width,
      child: style == ButtonStyleType.filled
          ? ElevatedButton(
              onPressed: disabled ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              child: child,
            )
          : OutlinedButton(
              onPressed: disabled ? null : onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: color,
                side: BorderSide(color: textColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              child: child,
            ),
    );
  }
}
