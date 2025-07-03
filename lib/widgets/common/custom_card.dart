import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  // final double? elevation; // We'll remove this or ignore it if we use custom shadow

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    // this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    // Get card theme defaults, but we will override shadow
    final cardTheme = Theme.of(context).cardTheme;

    return Container(
      margin: margin ?? cardTheme.margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: color ?? cardTheme.color ?? Theme.of(context).colorScheme.surface,
        borderRadius: (cardTheme.shape as RoundedRectangleBorder?)?.borderRadius ?? BorderRadius.circular(12), // Get border radius from theme or default
        boxShadow: [
          BoxShadow(

            offset: const Offset(4.0, 4.0),
            blurRadius: 32.0,
            spreadRadius: 4.0,
            color: AppColors.foreground.withValues(alpha: 0.1), 
          ),
        ],
      ),
      child: ClipRRect( // Important to clip child to the rounded corners if the child might overflow
         borderRadius: (cardTheme.shape as RoundedRectangleBorder?)?.borderRadius ?? BorderRadius.circular(12),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}