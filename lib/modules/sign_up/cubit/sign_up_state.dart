part of 'sign_up_cubit.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class PasswordVisibilty extends SignUpState{}

class LowerColorState extends SignUpState{}

class UpperColorState extends SignUpState{}

class ShowPointsState extends SignUpState{}

class SignUpLoadingState extends SignUpState{}

class SignUpSuccessState extends SignUpState{}

class SignUpErrorState extends SignUpState{
  final String error ;
  SignUpErrorState(this.error);
}

class CreateUserLoadingState extends SignUpState{}

class CreateUserSuccessState extends SignUpState{}

class CreateUserErrorState extends SignUpState{
  final String error ;
  CreateUserErrorState(this.error);
}



