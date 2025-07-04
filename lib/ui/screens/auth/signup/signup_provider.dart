import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/core/models/app_user.dart';
import 'package:to_do_list/core/models/base_view_model.dart';
import 'package:to_do_list/core/services/auth_services.dart';
import 'package:to_do_list/core/services/view_state.dart';
import 'package:to_do_list/core/utils/snack_bar.dart';
import 'package:to_do_list/ui/screens/auth/sign_in/sign_in.dart';
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
  bool isLoading = false;
  Future<void> userSignUp(BuildContext context, AppUser user) async {
    try {
      user.appUserId = "";
      isLoading = true;
      notifyListeners();
      final resultSucess = await authServices.insertUser(user);
      Future.delayed(Duration(seconds: 2), () {
        // Your code here
        print('Delayed function executed');
      });
      isLoading = false;
      notifyListeners();
      if (resultSucess) {
       
        final prefs = await SharedPreferences.getInstance();
        //  print("new user id${newUserId}");
        await prefs.setBool('isLoggedIn', true);
    

        CustomSnackBar.show(
          context,
          message: "User registered successfully!",
          type: SnackBarType.success,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SignInScreen(),
          ),
        );
      } else {
        CustomSnackBar.show(
          context,
          message: "User already registered!",
          type: SnackBarType.warning,
        );
      }
    } catch (e) {
      setState(ViewState.idle);
      CustomSnackBar.show(
        context,
        message: 'Error during sign up: $e',
        type: SnackBarType.error,
      );
    }
  }

//
}
