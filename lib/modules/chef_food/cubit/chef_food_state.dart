part of 'chef_food_cubit.dart';

@immutable
abstract class ChefFoodState {}

class ChefFoodInitial extends ChefFoodState {}

class GetChefFoodSuccessfully extends ChefFoodState{}

class GetChefFoodLoading extends ChefFoodState{}

class GetChefFoodError extends ChefFoodState{}

class DeleteDishSuccessfully extends ChefFoodState{}

class DeleteDishError extends ChefFoodState{}

class ShowAndHideSearchBarState extends ChefFoodState{}

class FilterDataSuccessfully extends ChefFoodState{}
