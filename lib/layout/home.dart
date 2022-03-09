import 'package:chef_app/layout/cubit/layout_cubit.dart';
import 'package:chef_app/modules/chef_food/chef_food_screen.dart';
import 'package:chef_app/modules/chef_food/cubit/chef_food_cubit.dart';
import 'package:chef_app/modules/login_screen/login_screen.dart';
import 'package:chef_app/modules/profile/profile_screen.dart';
import 'package:chef_app/shared/components/components.dart';
import 'package:chef_app/shared/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  String dropDownButtonValue = "Desserts";
  var dishNameController = TextEditingController();
  var descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChefFoodCubit(),
      child: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {},
        builder: (context, state) {
          LayoutCubit cubit = LayoutCubit.get(context);
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: cubit.curIndex == 0 ? ChefFoodScreen() : ProfileScreen(),
            appBar: cubit.curIndex==1?AppBar(
              title: (cubit.curIndex == 1 ?Text("Profile"):null),
              actions: [
                if (cubit.curIndex != 0)
                  TextButton(
                      onPressed: () {
                        cubit.logOut();
                        navigateAndReplacement(
                            context: context, Screen: LoginScreen());
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )),
              ],
            ):null,
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
              currentIndex: cubit.curIndex,
              onTap: (value) {
                cubit.changeBottomNavBarIndex(value);
              },
            ),
            floatingActionButton:
                cubit.curIndex == 0 ? floatingActionButtonAdd(context) : null,
          );
        },
      ),
    );
  }

  Widget floatingActionButtonAdd(context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: addFood(context),
            );
          },
          constraints: BoxConstraints(
              minHeight: double.infinity, minWidth: double.infinity),
          isScrollControlled: true,
        );
      },
      child: Icon(
        Icons.add,
        color: Colors.black,
      ),
    );
  }

  Widget addFood(context) {
    LayoutCubit cubit = LayoutCubit.get(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 60,
          ),
          BlocConsumer<LayoutCubit, LayoutState>(
            listener: (context, state) {},
            builder: (context, state) {
              return InkWell(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: cubit.image == null
                          ? AssetImage("assets/images/add.jpg")
                          : FileImage(cubit.image!) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  cubit.imagePicker();
                  print("tabbed");
                },
              );
            },
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
              controller: dishNameController,
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  label: Text("Dish Name"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fastfood_outlined)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: TextFormField(
              controller: descriptionController,
              textDirection: TextDirection.rtl,
              maxLines: null,
              minLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                label: Text("Description"),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          BlocConsumer<LayoutCubit, LayoutState>(
            listener: (context, state) {
              if (state is AddDishWithImageSuccessfully ||
                  state is AddDishWithoutImageSuccessfully) {
                showToast("Dish Added Successfully");
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Container(
                    width: 300,
                    height: 60,
                    child: DropdownButton(
                      value: LayoutCubit.get(context).category,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: mainColor,
                      ),
                      items: <String>['Desserts', 'Salts']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (String? value) {
                        dropDownButtonValue = value!;
                        LayoutCubit.get(context).changeDropDownItem(value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  state is! AddDishWithImageLoading &&
                          state is! AddDishWithoutImageLoading
                      ? Container(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                cubit.insertNewFood(
                                    dishName: dishNameController.text,
                                    description: descriptionController.text,
                                    category: dropDownButtonValue,
                                    date: DateTime.now().toString());
                                cubit.image = null;
                                dishNameController.text = "";
                                descriptionController.text = "";
                              },
                              child: Text(
                                "Add",
                                style: elevatedButtonTextColor,
                              )),
                        )
                      : Center(child: CircularProgressIndicator()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
