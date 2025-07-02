import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/core/models/app_user.dart';
import 'package:to_do_list/core/models/base_view_model.dart';
import 'package:to_do_list/core/services/auth_services.dart';
import 'package:to_do_list/core/services/database_services.dart';
import 'package:to_do_list/core/services/view_state.dart';

class SignInProvider extends BaseViewModal {
  AppUser appUser = AppUser();
  final formKey = GlobalKey<FormState>(); // ✅ Add this line
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DatabaseServices dbHelper = DatabaseServices();
  AuthServices authServices = AuthServices();
//user signin
  Future<void> handleSignIn(AppUser appuser) async {
    if (formKey.currentState!.validate()) {
      print("calling signing ${appuser.email} ${appuser.password}");
    }
  }
  ////////////////////login

  Future<void> loginUser(BuildContext context, AppUser appUser) async {
    try {
      setState(ViewState.busy);
      final user = await authServices.getUserByEmailAndPassword(
          appUser.email.toString(), appUser.password.toString());
      Future.delayed(Duration(seconds: 3));
      setState(ViewState.idle);
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Login successful')),
        );
        // Navigate to home screen or store login info in SharedPreferences
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Invalid email or password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error during login: $e')),
      );
    }
  }
//
}
