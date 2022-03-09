part of 'forgot_password_cubit.dart';

@immutable
abstract class ForgotPasswordState {}

class ForgotPasswprdInitial extends ForgotPasswordState {}

class ForgotPasswordRequestSuccessfully extends ForgotPasswordState{}

class ForgotPasswordRequestError extends ForgotPasswordState{}

class ChangeTextFlag extends ForgotPasswordState{}

