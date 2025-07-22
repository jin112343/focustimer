import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';

class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool isOutlined;
  final bool isText;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.isLoading = false,
    this.isOutlined = false,
    this.isText = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isText) {
      return SizedBox(
        width: width,
        height: height ?? 48,
        child: TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? theme.colorScheme.primary,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
          ),
          child: _buildButtonContent(),
        ),
      );
    }

    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height ?? 48,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? theme.colorScheme.primary,
            side: BorderSide(
              color: textColor ?? theme.colorScheme.primary,
              width: 1.5,
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
            ),
          ),
          child: _buildButtonContent(),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.colorScheme.primary,
          foregroundColor: textColor ?? Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient? gradient;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.gradient,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 48,
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, size: 20, color: textColor ?? Colors.white),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor ?? Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class ModernFloatingActionButton extends StatelessWidget {
  final String? label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool isExtended;

  const ModernFloatingActionButton({
    super.key,
    this.label,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.isExtended = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: foregroundColor ?? Colors.white,
        elevation: elevation ?? 6,
        icon: Icon(icon),
        label: Text(
          label!,
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation ?? 6,
      child: Icon(icon),
    );
  }
}

class IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? size;
  final double? borderRadius;
  final String? tooltip;

  const IconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.size,
    this.borderRadius,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        child: Container(
          width: size ?? 48,
          height: size ?? 48,
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: foregroundColor ?? theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
    );
  }
} 