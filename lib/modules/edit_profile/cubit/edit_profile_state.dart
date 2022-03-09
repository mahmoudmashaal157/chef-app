part of 'edit_profile_cubit.dart';

@immutable
abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class GetUserDataSuccessfully extends EditProfileState{}

class GetUserDataError extends EditProfileState{}

class GetUserDataLoading extends EditProfileState{}

class UpdateUserDataSuccessfully extends EditProfileState{}

class UpdateUserDataError extends EditProfileState{}

class UpdateUserDataLoading extends EditProfileState{}

class GetUserPostsSuccess extends EditProfileState{}

class PickProfileImageSuccessfully extends EditProfileState{}

class UploadImageSuccessfully extends EditProfileState{}
