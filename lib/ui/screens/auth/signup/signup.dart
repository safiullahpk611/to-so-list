import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/core/services/database_services.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:to_do_list/ui/screens/auth/sign_in/sign_in.dart';
import 'package:to_do_list/ui/screens/auth/signup/signup_provider.dart';
import 'package:to_do_list/ui/widgets/auth_custom_form.dart';
import 'package:to_do_list/ui/widgets/custom_text_field.dart';
import 'package:to_do_list/ui/widgets/title_bar.dart';
import 'package:window_manager/window_manager.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpProvider>(
      create: (BuildContext context) {
        return SignUpProvider();
      },
      child: Consumer<SignUpProvider>(
          builder: (BuildContext context, SignUpProvider model, Widget? child) {
        return Scaffold(
          backgroundColor: const Color(0xFFEFEFEF),
          body: Column(
            children: [
              // Custom Title Bar
              CustomTitleBar(),

              // Main Content
              AuthFormContainer(
                  child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                          hintText: 'First Name',
                          myController: model.firstNameController,
                          obscureText: false,
                          keyBoardType: TextInputType.name,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your first name";
                            }
                          }),
                      const SizedBox(height: 24),
                      CustomTextField(
                          hintText: 'Last Name',
                          myController: model.lastNameController,
                          obscureText: false,
                          keyBoardType: TextInputType.name,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your last name";
                            }
                          }),
                      const SizedBox(height: 24),
                      CustomTextField(
                        hintText: 'Email',
                        myController: model.userEmailController,
                        obscureText: false,
                        keyBoardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your email";
                          }
                          // Use a regular expression to check if the entered email is valid
                          if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                              .hasMatch(value)) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "ⓘ Please enter your password";
                          } else if (value.length < 8) {
                            return "ⓘ Password must be at least 8 characters eg: Asdf1234";
                          } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                            return "ⓘ Password must contain at least 1 number: eg Asdf1234";
                          } else if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                            return "ⓘ Password must contain at least 1 letter eg: Asdf1234";
                          } else {
                            return null; // Validation passed
                          }
                        },
                        hintText: 'Create password',
                        myController: model.passwordController,
                        keyBoardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        hintText: 'Confirm password',
                        onChanged: (val) {
                          model.appUser.confirmPassword = val;
                        },
                        myController: model.confirmPasswordController,
                        keyBoardType: TextInputType.visiblePassword,
                        ontap: () {
                          //   createValue.setConfirmShowPass();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please confirm your password";
                          } else if (value != model.appUser.password) {
                            return "Passwords do not match";
                          } else {
                            return null; // Validation passed
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // if (model.formKey.currentState!.validate()) {

                            // }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text("SignUp"),
                          ),
                        ),
                      ),
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
                      )

                      //
                    ],
                  ),
                ),
              )),
            ],
          ),
        );
      }),
    );
  }
}
