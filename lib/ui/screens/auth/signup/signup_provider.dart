import 'package:flutter/material.dart';
import 'package:to_do_list/core/models/app_user.dart';
import 'package:to_do_list/core/models/base_view_model.dart';
import 'package:to_do_list/core/services/auth_services.dart';
import 'package:to_do_list/core/services/database_services.dart';

class SignUpProvider extends BaseViewModal {
  final formKey = GlobalKey<FormState>();
  AppUser appUser = AppUser();
  DatabaseServices dbHelper = DatabaseServices();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AuthServices authServices = AuthServices();
  Future<void> userSignUp(BuildContext context, AppUser user) async {
    try {
      user.appUserId = "";
      final success = await authServices.insertUser(user);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ User registered successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ User already registered')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    }
  }
}
