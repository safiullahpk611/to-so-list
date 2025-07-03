import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/core/models/app_user.dart';
import 'package:to_do_list/core/models/base_view_model.dart';
import 'package:to_do_list/core/services/auth_services.dart';
import 'package:to_do_list/core/services/view_state.dart';
import 'package:to_do_list/ui/screens/todo/todo_screen.dart';

class SignUpProvider extends BaseViewModal {
  final formKey = GlobalKey<FormState>();
  final appUser = AppUser();
  final authServices = AuthServices();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> userSignUp(BuildContext context, AppUser user) async {
    try {
      user.appUserId = "";
      setState(ViewState.busy);

      final userInsertResult = await authServices.insertUser(user);

      setState(ViewState.idle);

      if (userInsertResult != null) {
        final newUserId = userInsertResult.user!.appUserId!;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('loggedInUserId', newUserId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User registered successfully')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TodoScreen(userId: newUserId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User already registered with this email')),
        );
      }
    } catch (e) {
      setState(ViewState.idle);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
