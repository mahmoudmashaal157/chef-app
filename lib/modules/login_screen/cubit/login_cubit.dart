import 'package:bloc/bloc.dart';
import 'package:chef_app/modules/sign_up/cubit/sign_up_cubit.dart';
import 'package:chef_app/network/local/cache_helper/cache_helper.dart';
import 'package:chef_app/shared/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context)=>BlocProvider.of(context);

  IconData suffixPasswordIcon = Icons.visibility;
  bool isPassword = true;
  changePasswordVisibilty(){
    isPassword = !isPassword;
    if(!isPassword)
      suffixPasswordIcon = Icons.visibility_off;

    else
      suffixPasswordIcon =Icons.visibility;

    emit(LoginPasswordVisibilty());
  }


  void login({
  required String email,
    required String password
}){
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
      Cache_Helper.SetData(key: 'uId', value: value.user!.uid);
      uId = value.user!.uid;
      emit(LoginSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(LoginErrorState());
    });
  }

  void signInWithGoogle(context) async {
    emit(LoginWithGoogleLoadingState());
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    var x = await FirebaseAuth.instance.signInWithCredential(credential);
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {

      SignUpCubit.get(context).createUser(
          email: value.user!.email.toString(),
          name: value.user!.displayName.toString(),
          phone: value.user!.phoneNumber.toString(),
          id: value.user!.uid.toString());
      emit(LoginSuccessState());
    }).catchError((error){
      emit(LoginWithGoogleErrorState());
    });
    print(x.user!.displayName);

  }
}
