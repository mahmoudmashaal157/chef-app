import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chef_app/models/dish_model.dart';
import 'package:chef_app/network/local/cache_helper/cache_helper.dart';
import 'package:chef_app/shared/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());

  static LayoutCubit get(context)=>BlocProvider.of(context);

  int curIndex=0;
  String? category="Desserts";
  var picker= ImagePicker();
  File? image;
  String? imageURL;

  void changeBottomNavBarIndex(int index){
    curIndex=index;
    emit(BottomNavBarIndexChange());
  }

  void changeDropDownItem(String value){
    category = value;
    emit(DropDownItemChanged());
  }

  Future<void>imagePicker()async{
    final pickedFile= await picker.getImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      image = File(pickedFile.path);
      emit(ImageSelectedSuccss());
    }
    else {
      print("No image selected");
    }
  }

  void insertNewFood({
  required String dishName,
    required String description,
    required String category,
    required String date,
}){
    if (image==null){
      emit(AddDishWithoutImageLoading());
      DishModel dish = DishModel(null, category, description, dishName,date);
      FirebaseFirestore.instance.collection('Users')
          .doc(uId).collection('dishs').doc().set(dish.toMap()).then((value) {
            emit(AddDishWithoutImageSuccessfully());
      }).catchError((Error){
        emit(AddDishWithoutImageError());
        print(Error);
      });
    }
    else{
      emit(AddDishWithImageLoading());
      FirebaseStorage.instance
          .ref().child("dishsImage/${Uri.file(image!.path).pathSegments.last}")
          .putFile(image!).then((value) {
            value.ref.getDownloadURL().then((value) {
              imageURL=value;

              DishModel dish = DishModel(imageURL, category, description, dishName,date);
              FirebaseFirestore.instance.collection('Users')
                  .doc(uId).collection('dishs').doc().set(dish.toMap()).then((value) {
                emit(AddDishWithImageSuccessfully());
              }).catchError((Error){
                emit(AddDishWithImageError());
                print(Error);
              });
            });
      }).catchError((error){
        print("Uploading image Error");
      });
    }
  }

  void logOut(){
    FirebaseAuth.instance.signOut().then((value) {
      Cache_Helper.sharedPreferences.remove("uId");
      print(Cache_Helper.getData(key: 'uId'));
      uId =null;
    });
  }






}
