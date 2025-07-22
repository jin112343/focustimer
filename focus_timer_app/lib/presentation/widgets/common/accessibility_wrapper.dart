import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../../../core/constants/colors.dart';

class AccessibilityWrapper extends StatelessWidget {
  final Widget child;
  final String? label;
  final String? hint;
  final bool isButton;
  final VoidCallback? onTap;
  final bool isFocusable;

  const AccessibilityWrapper({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.isButton = false,
    this.onTap,
    this.isFocusable = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget wrappedChild = child;

    // セマンティクスラベルを追加
    if (label != null) {
      wrappedChild = Semantics(
        label: label,
        hint: hint,
        button: isButton,
        enabled: isFocusable,
        child: wrappedChild,
      );
    }

    // タップ可能な場合はGestureDetectorでラップ
    if (onTap != null) {
      wrappedChild = GestureDetector(
        onTap: onTap,
        child: wrappedChild,
      );
    }

    // フォーカス可能な場合はFocusでラップ
    if (isFocusable) {
      wrappedChild = Focus(
        child: wrappedChild,
      );
    }

    return wrappedChild;
  }
}

class HighContrastText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const HighContrastText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(
        color: AppColors.highContrastTextColor,
        fontWeight: FontWeight.bold,
      ),
      textAlign: textAlign,
    );
  }
}

class ScreenReaderText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const ScreenReaderText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text,
      child: Text(
        text,
        style: (style ?? const TextStyle()).copyWith(
          color: AppColors.screenReaderTextColor,
          fontSize: 12,
        ),
      ),
    );
  }
}

class FocusIndicator extends StatelessWidget {
  final Widget child;
  final Color? color;

  const FocusIndicator({
    super.key,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color ?? AppColors.focusIndicatorColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}

class AccessibilityButton extends StatelessWidget {
  final String label;
  final String? hint;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;

  const AccessibilityButton({
    super.key,
    required this.label,
    this.hint,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: onPressed != null,
      child: SizedBox(
        width: width,
        height: height ?? 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primaryColor,
            foregroundColor: textColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 