import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:to_do_list/ui/screens/auth/sign_in/sign_in_provider.dart';

import 'package:to_do_list/ui/screens/auth/signup/signup.dart';

import 'package:to_do_list/ui/widgets/auth_custom_form.dart';

import 'package:to_do_list/ui/widgets/custom_text_field.dart';
import 'package:to_do_list/ui/widgets/title_bar.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInProvider>(
      create: (BuildContext context) {
        return SignInProvider();
      },
      child: Consumer<SignInProvider>(
          builder: (BuildContext context, SignInProvider model, Widget? child) {
        return Scaffold(
          backgroundColor: const Color(0xFFEFEFEF),
          body: Column(children: [
            CustomTitleBar(),
            AuthFormContainer(
                child: Form(
              key: model.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      hintText: 'Email',
                      myController: model.emailController,
                      obscureText: false,
                      keyBoardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      hintText: 'Password',
                      myController: model.passwordController,
                      obscureText: true,
                      keyBoardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (model.formKey.currentState!.validate()) {
                            // final user = await DatabaseServices.getUserByEmail(
                            //   emailController.text.trim(),
                            // );

                            // if (user == null) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text("User not found")),
                            //   );
                            // } else if (user.password != passwordController.text) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text("Incorrect password")),
                            //   );
                            // } else {
                            //   final prefs = await SharedPreferences.getInstance();
                            //   prefs.setBool('isLoggedIn', true);
                            //   prefs.setString('userEmail', user.email);

                            //   Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (_) => TodoListScreen()),
                            //   );
                            // }
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text("Sign In"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => Signup()),
                            );
                          },
                          child: const Text("Sign Up"),
                        ),
                      ],
                    )

                    //
                  ],
                ),
              ),
            ))
          ]),
        );
      }),
    );
  }
}
