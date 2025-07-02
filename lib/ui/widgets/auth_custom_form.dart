// File: lib/ui/widgets/auth_form_container.dart

import 'package:flutter/material.dart';

class AuthFormContainer extends StatelessWidget {
  final Widget child;

  const AuthFormContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double formWidth = width > 800 ? 500 : width * 0.9;

          return Center(
            child: Container(
              width: formWidth,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
