import 'package:flutter/material.dart';

class GradientButtonWithIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final List<Color> gradientColors;
  final double borderRadius;
  final EdgeInsets padding;

  const GradientButtonWithIcon({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.gradientColors = const [
      Colors.deepPurple,
      Color(0xFF1A0342),
    ],
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
          label: Text(label, style: const TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}
