import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = Colors.green;
        break;
      case SnackBarType.error:
        backgroundColor = Colors.red;
        break;
      case SnackBarType.warning:
        backgroundColor = Colors.orange;
        break;
      case SnackBarType.info:
      default:
        backgroundColor = Colors.blue;
        break;
    }

    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

enum SnackBarType { success, error, warning, info }
