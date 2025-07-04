import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:to_do_list/core/services/loger.dart';
import 'package:to_do_list/ui/screens/todo/todo_screen.dart';
import 'package:window_manager/window_manager.dart';

import 'ui/screens/auth/sign_in/sign_in.dart';
import 'ui/screens/auth/signup/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  // Initialize FFI for Windows
  sqfliteFfiInit();

  // Set FFI as default database factory
  databaseFactory = databaseFactoryFfi;

  final prefs = await SharedPreferences.getInstance();
  final currentUserId = prefs.getString('loggedInUserId');
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1000, 700),
    center: true,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.normal,
  );
  await LoggerService.init();
  LoggerService.logger.i("App started");
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setMinimumSize(const Size(600, 800));

    await windowManager.setMaximumSize(const Size(1600, 1200));
    await windowManager.show();
    await windowManager.focus();
    // 👇 Add this to open in maximized state
    await windowManager.maximize();
  });

  runApp(MyApp(
    userId: currentUserId.toString(),
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String userId;
  const MyApp({super.key, required this.isLoggedIn, required this.userId});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("is login  ${isLoggedIn}");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //  title: 'To Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn
          ? TodoScreen(
              userId: userId,
            )
          : SignInScreen(),
    );
  }
}
