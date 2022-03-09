import 'package:chef_app/layout/home.dart';
import 'package:chef_app/modules/sign_up/cubit/sign_up_cubit.dart';
import 'package:chef_app/shared/components/components.dart';
import 'package:chef_app/shared/constants/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emialController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    //SignUpCubit cubit = SignUpCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: BlocProvider(
        create: (context) => SignUpCubit(),
        child: BlocConsumer<SignUpCubit,SignUpState>(
          listener: (context, state) {
            if(state is CreateUserSuccessState){
              showToast("User Created Successfully");
              navigateAndReplacement(context: context, Screen: HomeScreen());
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Text (
                      "SignUp",
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),

                    ),
                    const SizedBox(height: 20,),
                    nameFormField(),
                    emailFormField(),
                    phoneFormField(),
                    passwordFormField(context),
                    if(SignUpCubit.get(context).showPasswordPoints)
                    passwordChecks(context),
                    confirmPasswordFormField(),
                    SizedBox(height: 15,),
                    signUpButton(context),
                    SizedBox(height: 10,),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget nameFormField() {
    return textFormFieldOfUserData(
      hint: "Name",
      validation: (value) {
        if (value.isEmpty) {
          return "name shouldn't be empty ";
        }
        return null;
      },
      controller: nameController,
      keyboardTybe: TextInputType.name,
      prefixIcon: Icons.person,
    );
  }

  Widget emailFormField() {
    return textFormFieldOfUserData(
      hint: "Email",
      validation: (value) {
        if (value.isEmpty) {
          return "Email shouldn't be empty ";
        }
        if(!EmailValidator.validate(value)){
          return "this mail isn't valid";
        }
        return null;
      },
      controller: emialController,
      keyboardTybe: TextInputType.emailAddress,
      prefixIcon: Icons.email,
    );
  }

  Widget phoneFormField() {
    return textFormFieldOfUserData(
      hint: "Phone",
      validation: (value) {
        if (value.isEmpty) {
          return "Phone shouldn't be empty ";
        }
        return null;
      },
      controller: phoneController,
      keyboardTybe: TextInputType.phone,
      prefixIcon: Icons.phone,
    );
  }

  Widget passwordFormField(context) {
    return textFormFieldOfUserDataPassword(
        hint: "Password",
        validation: (value) {
          if (value == null) {
            return "Password shouldn't be empty ";
          }
          if(SignUpCubit.get(context).lowerCase==false){return " ";}
          if(SignUpCubit.get(context).upperCase==false){return " ";}
          if(SignUpCubit.get(context).number==false){return " ";}
          if(SignUpCubit.get(context).length==false){return " ";}
          return null;
        },
        controller: passwordController,
        keyboardTybe: TextInputType.visiblePassword,
        isPassword: SignUpCubit.get(context).isPassword,
        prefixIcon: Icons.lock,
        suffixIcon: SignUpCubit.get(context).suffixPasswordIcon,
        onsuffixPressed:(){
          SignUpCubit.get(context).changePasswordVisibilty();
        },
      onChange:(value) {
          SignUpCubit.get(context).checkPassword(value);
      },
    );
  }

  Widget confirmPasswordFormField() {
    return textFormFieldOfUserData(
      hint: "Confirm Password",
      validation: (value) {
        if (value.isEmpty) {
          return "Confirmation Password shouldn't be empty ";
        }
        if(value != passwordController.text){
          return "Password doesn't match";
        }
        return null;
      },
      controller: confirmPasswordController,
      keyboardTybe: TextInputType.visiblePassword,
      isPassword: true,
      prefixIcon: Icons.lock,
    );
  }

  Widget signUpButton(context) {
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
            SignUpCubit.get(context).SignUp(email: emialController.text,
                password: passwordController.text,
                name: nameController.text,
                phone: phoneController.text
            );
          }
        },
        child: Text("Sign Up",
          style: elevatedButtonTextColor,
        ),
      ),
    );
  }

  Widget passwordChecks (context){
    return Row(
      children: [
        SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(SignUpCubit.get(context).lowerCase==false)
              Row(
                children: [
                  Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                        color:Colors.red[800],
                        shape: BoxShape.circle
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text("LowerCase Letter",
                    style: TextStyle(
                      color: Colors.red[800],
                    ),
                  ),
                ],
              ),
            if(SignUpCubit.get(context).upperCase==false)
              Row(
                children: [
                  Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                        color:Colors.red[800],
                        shape: BoxShape.circle
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text("Uppercase Letter",
                    style: TextStyle(
                      color: Colors.red[800],
                    ),
                  ),
                ],
              ),
            if(SignUpCubit.get(context).length==false)
              Row(
                children: [
                  Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                        color: Colors.red[800],
                        shape: BoxShape.circle
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text("8 Characters",
                    style: TextStyle(
                      color: Colors.red[800],
                    ),
                  ),
                ],
              ),
            if(SignUpCubit.get(context).number==false)
              Row(
                children: [
                  Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                        color:Colors.red[800],
                        shape: BoxShape.circle
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text("Digit",
                    style: TextStyle(
                      color: Colors.red[800],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }


}
