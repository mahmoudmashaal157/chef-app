import 'package:chef_app/modules/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:chef_app/shared/components/components.dart';
import 'package:chef_app/shared/constants/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {},
        builder: (context, state) {
          ForgotPasswordCubit cubit = ForgotPasswordCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                title: Text("Reset Password"),
              ),
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    textFormFieldOfUserData(hint: "Email",
                        validation: (value) {
                          if (value.isEmpty) {
                            return "email couldn't be empty";
                          }
                          if (!EmailValidator.validate(value)) {
                            return "email isn't true";
                          }
                          return null;
                        },
                        controller: emailController,
                        keyboardTybe: TextInputType.emailAddress
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            cubit.forgotPasswordRequest(email: emailController
                                .text);
                            cubit.changeTextFlag();
                          }
                        },
                        child: Text("Request",
                            style: elevatedButtonTextColor
                        )
                    ),
                    SizedBox(height: 50,),
                    if(ForgotPasswordCubit
                        .get(context)
                        .textFlag == true)
                      Text("Check your mail",
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ],
                ),
              )
          );
        },
      ),
    );
  }
}
