import 'dart:ui';

import 'package:chef_app/layout/home.dart';
import 'package:chef_app/modules/forgot_password/forgot_password_screen.dart';
import 'package:chef_app/modules/login_screen/cubit/login_cubit.dart';
import 'package:chef_app/modules/sign_up/cubit/sign_up_cubit.dart';
import 'package:chef_app/modules/sign_up/sign_up_screen.dart';
import 'package:chef_app/shared/components/components.dart';
import 'package:chef_app/shared/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emialController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            showToast("Logged in Successfully");
            navigateAndReplacement(context: context, Screen: HomeScreen());
          }
          if (state is LoginErrorState) {
            showToast("invalid email or password");
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: mainColor,
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: SafeArea(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(70),
                              bottomRight: Radius.circular(70),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: const Text(
                              "Le Chef",
                              style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Petmoss'),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          emailFormField(),
                          passwordFormField(context),
                          ForgotPasswordText(context),
                          loginButton(context, state),
                          SizedBox(
                            height: 10,
                          ),
                          signUpText(context),
                          SizedBox(
                            height: 10,
                          ),
                          state is! LoginWithGoogleLoadingState || state is! CreateUserLoadingState ?
                          Center(child: signInWithGoogleButton(context)):
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Center(child: CircularProgressIndicator(),),
                          ),
                        ],
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

  Widget emailFormField() {
    return textFormFieldOfUserData(
      hint: "Email",
      validation: (value) {
        if (value.isEmpty) {
          return "Email shouldn't be empty ";
        }
        return null;
      },
      controller: emialController,
      keyboardTybe: TextInputType.emailAddress,
      prefixIcon: Icons.email,
    );
  }

  Widget passwordFormField(context) {
    return textFormFieldOfUserData(
        hint: "Password",
        validation: (value) {
          if (value.isEmpty) {
            return "Password shouldn't be empty ";
          }
          return null;
        },
        controller: passwordController,
        keyboardTybe: TextInputType.visiblePassword,
        isPassword: LoginCubit.get(context).isPassword,
        prefixIcon: Icons.lock,
        suffixIcon: LoginCubit.get(context).suffixPasswordIcon,
        onsuffixPressed: () {
          LoginCubit.get(context).changePasswordVisibilty();
        });
  }

  Widget loginButton(context, state) {
    if (state is! LoginLoadingState)
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                LoginCubit.get(context).login(
                    email: emialController.text,
                    password: passwordController.text);
                print("asas");
              }
            },
            child: Text(
              "Login",
              style: elevatedButtonTextColor,
            )),
      );
    else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget signUpText(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          const Text(
            " Don't have an account?",
            style: TextStyle(fontSize: 18),
          ),
          TextButton(
            onPressed: () {
              navigateTo(context: context, Screen: SignUpScreen());
            },
            child: Text(
              "Sign Up",
              style: TextStyle(fontSize: 20, color: blueColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget ForgotPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextButton(
          onPressed: () {
            navigateTo(context: context, Screen: ForgotPasswordScreen());
          },
          child: const Text(
            "Forgot Password",
            style: TextStyle(color: blueColor),
          )),
    );
  }

  Widget signInWithGoogleButton(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color:Colors.blueAccent),
              color: Colors.blueAccent
            ),
            width: MediaQuery.of(context).size.width*0.5,
            height: 50,
            child: Row(
              children: [
                Container(
                    color: Colors.white,
                    child: Image.asset("assets/images/google_icon.png")),
                SizedBox(width: 5,),
                Text("Sign in with Google",
                style: TextStyle(
                  color: Colors.white
                ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          LoginCubit.get(context).signInWithGoogle(context);
        },
      ),
    );
  }
}
