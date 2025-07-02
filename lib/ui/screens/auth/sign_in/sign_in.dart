import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/core/enums/view_state.dart';

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
          body: ModalProgressHUD(
            progressIndicator: CircularProgressIndicator(
              color: Colors.purple,
            ),
            inAsyncCall: model.state == ViewState.busy,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.deepPurple,
                const Color.fromARGB(255, 26, 3, 66)
              ])),
              child: Column(children: [
                //CustomTitleBar(),
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
                          onChanged: (val) {
                            print("email is :${val}");
                            model.appUser.email = val;
                          },
                          hintText: 'Email',
                          //  myController: model.emailController,
                          obscureText: false,
                          keyBoardType: TextInputType.emailAddress,
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
                        CustomTextField(
                          onChanged: (val) {
                            print("password is :${val}");
                            model.appUser.password = val;
                          },
                          hintText: 'Password',
                          // myController: model.passwordController,
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
                              model.loginUser(context, model.appUser);

                              // }
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
            ),
          ),
        );
      }),
    );
  }
}
