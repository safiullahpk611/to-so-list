import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/core/models/app_user.dart';
import 'package:to_do_list/core/models/base_view_model.dart';
import 'package:to_do_list/core/services/auth_services.dart';
import 'package:to_do_list/core/services/view_state.dart';
import 'package:to_do_list/ui/screens/todo/todo_screen.dart';

class SignInProvider extends BaseViewModal {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authServices = AuthServices();
  AppUser appUser = AppUser();
  bool isLoading = false;

  /// Authenticates the user and navigates to the Todo screen if successful
  Future<void> loginUser(BuildContext context, AppUser appUser) async {
    try {
      isLoading = true;
      notifyListeners();
      final user = await authServices.getUserByEmailAndPassword(
        appUser.email ?? '',
        appUser.password ?? '',
      );

      Future.delayed(Duration(seconds: 2), () {
        // Your code here
        print('Delayed function executed');
      });

      isLoading = false;
      notifyListeners();
      if (user != null) {
        // Save login state and user ID in shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('loggedInUserId', user.appUserId!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );

        // Navigate to the Todo screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TodoScreen(userId: user.appUserId!),
          ),
        );
      } else {
        // Show invalid credentials error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    } catch (e) {
      // Show error message
      setState(ViewState.idle);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during login: $e')),
      );
    }
  }
//
}
