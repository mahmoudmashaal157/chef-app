part of 'layout_cubit.dart';

@immutable
abstract class LayoutState {}

class LayoutInitial extends LayoutState {}

class BottomNavBarIndexChange extends LayoutState{}

class DropDownItemChanged extends LayoutState{}

class ImageSelectedSuccss extends LayoutState{}

class AddDishWithoutImageLoading extends LayoutState{}

class AddDishWithoutImageSuccessfully extends LayoutState{}

class AddDishWithoutImageError extends LayoutState{}


class AddDishWithImageLoading extends LayoutState{}

class AddDishWithImageSuccessfully extends LayoutState{}

class AddDishWithImageError extends LayoutState{}

class ShowSearchBar extends LayoutState{}

