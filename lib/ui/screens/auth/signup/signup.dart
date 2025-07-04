import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/ui/screens/auth/sign_in/sign_in.dart';
import 'package:to_do_list/ui/screens/auth/signup/signup_provider.dart';
import 'package:to_do_list/ui/widgets/auth_custom_form.dart';

import 'package:to_do_list/ui/widgets/button.dart';
import 'package:to_do_list/ui/widgets/custom_text_field.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpProvider>(
      create: (_) => SignUpProvider(),
      child: Consumer<SignUpProvider>(
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "ToDo Master - Sign Up",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.deepPurple,
              elevation: 4,
              toolbarHeight: 60,
            ),
            backgroundColor: const Color(0xFFEFEFEF),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple,
                    Color.fromARGB(255, 26, 3, 66),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: AuthFormContainer(
                      child: Form(
                        key: model.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Create Your Account",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 32),
                            CustomTextField(
                              onChanged: (val) => model.appUser.firstName = val,
                              hintText: 'First Name',
                              keyBoardType: TextInputType.name,
                              obscureText: false,
                              validator: (value) => value.isEmpty
                                  ? "Please enter your first name"
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            CustomTextField(
                              onChanged: (val) => model.appUser.lastName = val,
                              hintText: 'Last Name',
                              keyBoardType: TextInputType.name,
                              obscureText: false,
                              validator: (value) => value.isEmpty
                                  ? "Please enter your last name"
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            CustomTextField(
                              onChanged: (val) => model.appUser.email = val,
                              hintText: 'Email',
                              keyBoardType: TextInputType.emailAddress,
                              obscureText: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your email";
                                }
                                if (!RegExp(
                                        r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                    .hasMatch(value)) {
                                  return "Please enter a valid email address";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            CustomTextField(
                              onChanged: (val) => model.appUser.password = val,
                              hintText: 'Create password',
                              keyBoardType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "ⓘ Please enter your password";
                                } else if (value.length < 8) {
                                  return "ⓘ Password must be at least 8 characters";
                                } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return "ⓘ Must contain at least 1 number";
                                } else if (!RegExp(r'[a-zA-Z]')
                                    .hasMatch(value)) {
                                  return "ⓘ Must contain at least 1 letter";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            CustomTextField(
                              onChanged: (val) =>
                                  model.appUser.confirmPassword = val,
                              hintText: 'Confirm password',
                              keyBoardType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please confirm your password";
                                } else if (value != model.appUser.password) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            GradientButtonWithIcon(
                                onPressed: () {
                                  if (model.formKey.currentState!.validate()) {
                                    model.userSignUp(context, model.appUser);
                                  }
                                },
                                icon: model.isLoading
                                    ? Icons.circle
                                    : Icons.person_add,
                                label:
                                    model.isLoading ? 'loading...' : 'SignUp'),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account? "),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SignInScreen()),
                                    );
                                  },
                                  child: const Text("Sign In"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
