import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/core/enums/view_state.dart';
import 'package:to_do_list/ui/screens/auth/sign_in/sign_in_provider.dart';
import 'package:to_do_list/ui/screens/auth/signup/signup.dart';
import 'package:to_do_list/ui/widgets/auth_custom_form.dart';
import 'package:to_do_list/ui/widgets/button.dart';

import 'package:to_do_list/ui/widgets/custom_text_field.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInProvider>(
      create: (_) => SignInProvider(),
      child: Consumer<SignInProvider>(
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "ToDo Master",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
                    child: LayoutBuilder(builder: (context, constraints) {
                  double width = constraints.maxWidth;
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: width > 600
                          ? 500
                          : double.infinity, // wider for desktop
                    ),
                    child: AuthFormContainer(
                      child: Form(
                        key: model.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Welcome Back",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Please sign in to your account",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Email field
                            CustomTextField(
                              hintText: 'Email',
                              keyBoardType: TextInputType.emailAddress,
                              obscureText: false,
                              onChanged: (val) {
                                model.appUser.email = val;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(
                                        r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 24),

                            // Password field

                            CustomTextField(
                              hintText: 'Password',
                              keyBoardType: TextInputType.visiblePassword,
                              obscureText: true,
                              onChanged: (val) {
                                model.appUser.password = val;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 32),

                            // Gradient Sign In Button
                            GradientButtonWithIcon(
                                onPressed: () {
                                  model.loginUser(context, model.appUser);
                                },
                                icon: model.isLoading
                                    ? Icons.circle
                                    : Icons.login,
                                label:
                                    model.isLoading ? 'loading...' : 'Sign In'),

                            const SizedBox(height: 24),

                            // Sign up link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account? "),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => Signup()),
                                    );
                                  },
                                  child: const Text("Sign Up"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
              ),
            ),
          );
        },
      ),
    );
  }
}
