import 'package:bloc/bloc.dart';
import 'package:chef_app/models/user_model.dart';
import 'package:chef_app/network/local/cache_helper/cache_helper.dart';
import 'package:chef_app/shared/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  static SignUpCubit get(context) => BlocProvider.of(context);

  IconData suffixPasswordIcon = Icons.visibility;
  bool isPassword = true;
  bool lowerCase = false;
  bool upperCase=false;
  bool length = false;
  bool number =false;
  bool showPasswordPoints=false;
  String image = "https://images.emojiterra.com/google/android-11/512px/1f9cd.png";

    changePasswordVisibilty(){
    isPassword = !isPassword;
    if(!isPassword)
      suffixPasswordIcon = Icons.visibility_off;

    else
      suffixPasswordIcon =Icons.visibility;

      emit(PasswordVisibilty());
  }

  void _lowerCaseCheck(String s) {
    if (s.contains(RegExp(r'[a-z]'))) {
      lowerCase = true;
      emit(LowerColorState());
    }
    else {
      lowerCase = false;
      emit(LowerColorState());
    }
  }

  void _upperCaseCheck(String s){
    if (s.contains(RegExp(r'[A-Z]'))) {
      upperCase = true;
      emit(LowerColorState());
    }
    else {
      upperCase = false;
      emit(LowerColorState());
    }
  }

  void  _lengthCaseCheck(String s) {
    if (s.length > 8) {
      length = true;
      emit(LowerColorState());
    }
    else {
      length = false;
      emit(LowerColorState());
    }
  }

  void _digitCaseCheck(String s) {
    if (s.contains(RegExp(r'[0-9]'))) {
      number = true;
      emit(LowerColorState());
    }
    else {
      number = false;
      emit(LowerColorState());
    }
  }

  checkPassword (String value){
      showPasswordPoints=true;
      emit(ShowPointsState());
    _lowerCaseCheck(value);
    _upperCaseCheck(value);
    _lengthCaseCheck(value);
    _digitCaseCheck(value);
  }

  void SignUp({
  required String email,
    required String password,
    required String name,
    required String phone,
}){
      emit(SignUpLoadingState());
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        Cache_Helper.SetData(key: 'uId', value: value.user!.uid);
        uId = value.user!.uid;
        emit(SignUpSuccessState());
        createUser(email: email, name: name, phone: phone, id: value.user!.uid);
      }).catchError((error){
        emit(SignUpErrorState(error));
        print(error);
      });
  }

  void createUser ({
  required String email,
    required String name,
    required String phone,
    required String id,
}){
      emit(CreateUserLoadingState());
       var user = UserModel(
         name:name,
         email:email,
         phone:phone,
         uId:id,
         image: image
       );
       FirebaseFirestore.instance.collection("Users")
      .doc(id).get().then((value) {
        if(value.id!=null){
          FirebaseFirestore.instance.collection("Users").doc(id).set(user.toMap()).then((value) {
            emit(CreateUserSuccessState());
            Cache_Helper.SetData(key: "uId", value: id);
            uId=id;
            print("Create User Success");
          }).catchError((Error){
            emit(CreateUserErrorState(Error.toString()));
            print(Error.toString());
          });
        }
       });


  }



}
