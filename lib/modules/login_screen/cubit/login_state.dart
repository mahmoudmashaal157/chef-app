part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState{}

class LoginSuccessState extends LoginState{}

class LoginErrorState extends LoginState{}

class LoginPasswordVisibilty extends LoginState{}

class LoginWithGoogleLoadingState extends LoginState{}

class LoginWithGoogleSuccessfullyState extends LoginState{}

class LoginWithGoogleErrorState extends LoginState{}



