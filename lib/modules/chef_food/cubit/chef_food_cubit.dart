import 'package:bloc/bloc.dart';
import 'package:chef_app/models/dish_model.dart';
import 'package:chef_app/shared/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'chef_food_state.dart';

class ChefFoodCubit extends Cubit<ChefFoodState> {
  ChefFoodCubit() : super(ChefFoodInitial());

  static ChefFoodCubit get(context)=>BlocProvider.of(context);

  List<DishModel>myFoods =[];
  List<DishModel>myFoodsCloneDatabase =[];
  List<DishModel>myFoodsSearch=[];
  bool showSearchBarFlag =false;


  void getChefFoods(){
    myFoods=[];
      emit(GetChefFoodLoading());
      FirebaseFirestore.instance
          .collection("Users")
          .doc(uId)
          .collection("dishs")
          .orderBy("date")
          .get()
          .then((value) {
            print(value.size);
        value.docs.forEach((element) {
          myFoods.add(DishModel.fromJson(element.data()));

        });
        myFoodsCloneDatabase = myFoods;
        emit(GetChefFoodSuccessfully());
      }).catchError((error) {
        emit(GetChefFoodError());
        print(error.toString());
      });
  }
  void deleteDish({
  required String dishName
}){
    FirebaseFirestore.instance
        .collection("Users")
        .doc(uId)
        .collection("dishs")
        .where("dishName",isEqualTo: dishName)
        .get()
        .then((value) {
          FirebaseFirestore.instance.collection("Users")
              .doc(uId)
              .collection("dishs")
              .doc(value.docs.first.id)
              .delete().then((value) {
                emit(DeleteDishSuccessfully());
                myFoods=[];
                getChefFoods();
          }).catchError((error){
            emit(DeleteDishError());
            print(error.toString());
          });
    }).catchError((error){

    });
  }
  void refresh(){
    getChefFoods();
  }

  void showAndHideSearchBar(){
    showSearchBarFlag=!showSearchBarFlag;
    emit(ShowAndHideSearchBarState());
  }

  void search ({required String searchValue}){
    if(searchValue=="" || searchValue.isEmpty){
      myFoods = myFoodsCloneDatabase;
      emit(FilterDataSuccessfully());
    }
    myFoodsSearch = myFoods
        .where((string) => string.dishName.toString().toLowerCase().contains(searchValue.toLowerCase()))
        .toList();
    myFoods = myFoodsSearch;
    emit(FilterDataSuccessfully());
  }



}
