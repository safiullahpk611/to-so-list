import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class CustomTitleBar extends StatelessWidget {
  const CustomTitleBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Colors.grey[300],
      child: Row(
        children: [
          // Make window draggable
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (_) => windowManager.startDragging(),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "To Do App",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),

          // Minimize Button
          IconButton(
            icon: const Icon(Icons.minimize),
            onPressed: () => windowManager.minimize(),
            tooltip: "Minimize",
          ),

          // Maximize / Restore
          IconButton(
            icon: const Icon(Icons.crop_square),
            onPressed: () async {
              bool isMax = await windowManager.isMaximized();
              if (isMax) {
                windowManager.unmaximize();
              } else {
                windowManager.maximize();
              }
            },
            tooltip: "Maximize / Restore",
          ),

          // Close Button
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => windowManager.close(),
            tooltip: "Close",
          ),
        ],
      ),
    );
  }
}
//
