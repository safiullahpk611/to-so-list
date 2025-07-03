import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

import 'ui/screens/auth/sign_in/sign_in.dart';
import 'ui/screens/todo/todo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window manager
  await _initializeWindow();

  // Initialize SQLite FFI
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // Load saved preferences
  final prefs = await SharedPreferences.getInstance();
  final currentUserId = prefs.getString('loggedInUserId') ?? '';
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(
    userId: currentUserId,
    isLoggedIn: isLoggedIn,
  ));
}

Future<void> _initializeWindow() async {
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1000, 700),
    center: true,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.normal,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setMinimumSize(const Size(600, 800));
    await windowManager.setMaximumSize(const Size(1600, 1200));

    await windowManager.show();
    await windowManager.focus();
  });
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String userId;

  const MyApp({super.key, required this.isLoggedIn, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? TodoScreen(userId: userId) : SignInScreen(),
    );
  }
}
