import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chef_app/models/user_model.dart';
import 'package:chef_app/shared/components/components.dart';
import 'package:chef_app/shared/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  static EditProfileCubit get(context)=>BlocProvider.of(context);

  UserModel? userData=null;
  int? posts=null;
  File? image;
  var picker = ImagePicker();
  String imageURL="https://images.emojiterra.com/google/android-11/512px/1f9cd.png";

  void getUserData(){
    emit(GetUserDataLoading());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uId)
        .get()
        .then((value) {
          userData = UserModel.fromJson(value.data()!);
          _getUserPosts();
          emit(GetUserDataSuccessfully());
    }).catchError((error){
      print(error);
      emit(GetUserDataError());
    });
  }

  void updateUserData({
  required String name,
    required String phone,
    required String email
})async{
    emit(UpdateUserDataLoading());
    if(image==null){
      FirebaseFirestore.instance
          .collection("Users")
          .doc(uId)
          .update({
        'name':name,
        'email':email,
        'phone':phone,
      }).then((value) {
        emit(UpdateUserDataSuccessfully());
        showToast("your profile updated successfully");
        getUserData();
      }).catchError((error){
        emit(UpdateUserDataError());
      });
    }
    else {
      updateWithImage(name: name, phone: phone, email: email);
    }


  }

  void _getUserPosts(){
    FirebaseFirestore.instance
        .collection("Users")
        .doc(uId)
        .collection("dishs")
        .get().then((value) {
          posts = value.size;
          print(posts);
          emit(GetUserPostsSuccess());
    });
  }

  void pickImage()async{
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if(pickedImage!=null){
      image = File(pickedImage.path);
      emit(PickProfileImageSuccessfully());
    }
    else {
      print("Profile Image Picker Error");
    }
  }

  void updateWithImage({
    required String name,
    required String phone,
    required String email
  }){
    emit(UpdateUserDataLoading());

    FirebaseStorage.instance
    .ref("profileImage/${Uri.file(image!.path).pathSegments.last}")
    .putFile(image!)
    .then((value) {
      value.ref.getDownloadURL().then((value) {
        imageURL = value;
        FirebaseFirestore.instance
            .collection("Users")
            .doc(uId)
            .update({
          'name':name,
          'email':email,
          'phone':phone,
          'image':imageURL
        }).then((value) {
          emit(UpdateUserDataSuccessfully());
          showToast("your profile updated successfully");
          getUserData();
        }).catchError((error){
          emit(UpdateUserDataError());
        });
      }).catchError((error){
        print("Error in download ImageURL");
      });
    }).catchError((error){
      print("error in uploading Image");
    });
  }


}
