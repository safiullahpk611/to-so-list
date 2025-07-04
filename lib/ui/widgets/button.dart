import 'package:flutter/material.dart';

class GradientButtonWithIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final List<Color> gradientColors;
  final double borderRadius;
  final EdgeInsets? padding;

  const GradientButtonWithIcon({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.gradientColors = const [Colors.deepPurple, Color(0xFF1A0342)],
    this.borderRadius = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon:
            Icon(icon, color: Colors.white, size: screenWidth < 400 ? 18 : 24),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth < 420 ? 9 : 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: screenWidth < 400 ? 16 : 24,
                vertical: screenWidth < 400 ? 10 : 14,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
