import 'package:flutter/material.dart';
import 'package:to_do_list/core/models/app_user.dart';
import 'package:to_do_list/core/models/base_view_model.dart';

class SignInProvider extends BaseViewModal {
  AppUser appUser = AppUser();
  final formKey = GlobalKey<FormState>(); // ✅ Add this line
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
}
