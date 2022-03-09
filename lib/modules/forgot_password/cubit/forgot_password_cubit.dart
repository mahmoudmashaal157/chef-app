import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'forgot_passwprd_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswprdInitial());

  bool textFlag=false;

  static ForgotPasswordCubit get (context)=>BlocProvider.of(context);

  void forgotPasswordRequest({required String email}){
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: email).then((value) {
      emit(ForgotPasswordRequestSuccessfully());
    }).catchError((error){
      emit(ForgotPasswordRequestError());
    });
  }

  void changeTextFlag(){
    textFlag=true;
    emit(ChangeTextFlag());
  }



}
