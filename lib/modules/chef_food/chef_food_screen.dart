import 'package:chef_app/modules/food_description/food_description.dart';
import 'package:chef_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chef_app/modules/chef_food/cubit/chef_food_cubit.dart';

class ChefFoodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChefFoodCubit(),
      child: Builder(
          builder: (context) {
        ChefFoodCubit.get(context).getChefFoods();
        print("BuildFinsihed");
        return BlocConsumer<ChefFoodCubit, ChefFoodState>(
          listener: (context, state) {},
          builder: (context, state) {
            ChefFoodCubit cubit = ChefFoodCubit.get(context);
            if(state is ! GetChefFoodLoading)
            return Scaffold(
                appBar: AppBar(
                  title: cubit.showSearchBarFlag == false
                      ? Text("My Foods")
                      : TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Search"
                    ),
                    onChanged: (value) {
                      //cubit.search(searchValue: value);
                      cubit.search(searchValue: value);
                    },
                  ),
                  actions: [
                    cubit.showSearchBarFlag == false
                        ? IconButton(
                            onPressed: () {
                              cubit.showAndHideSearchBar();
                            },
                            icon: Icon(Icons.search))
                        : IconButton(
                            onPressed: () {
                              cubit.showAndHideSearchBar();
                              cubit.search(searchValue: "");
                            },
                            icon: Icon(Icons.cancel))
                  ],
                ),
                body: buildListView(context));
            return Center(child: CircularProgressIndicator());
          },
        );
      }),
    );
  }

  Widget buildFoodItem(
      index, context, String imageURL, String dishName, String category) {
    return Dismissible(
      key: UniqueKey(),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        child: InkWell(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage("$imageURL"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Center(
                        child: Text(
                          "$dishName",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "$category",
                        style: TextStyle(color: Colors.grey[500], fontSize: 15),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            navigateTo(context: context, Screen: FoodDescription(index: index));
          },
        ),
      ),
      onDismissed: (direction) {
        ChefFoodCubit.get(context).deleteDish(dishName: dishName);
      },
      background: Container(
        alignment: AlignmentDirectional.centerStart,
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: 50,
        ),
      ),
      secondaryBackground: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: 50,
        ),
      ),
    );
  }

  Widget buildListView(context) {
    return BlocConsumer<ChefFoodCubit, ChefFoodState>(
      listener: (context, state) {},
      builder: (context, state) {
        ChefFoodCubit cubit = ChefFoodCubit.get(context);
        return RefreshIndicator(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return buildFoodItem(
                      index,
                      context,
                      cubit.myFoods[index].image.toString(),
                      cubit.myFoods[index].dishName.toString(),
                      cubit.myFoods[index].category.toString());
                },
                separatorBuilder: (context, index) {
                  return Container();
                },
                itemCount: cubit.myFoods.length),
            onRefresh: () {
              cubit.refresh();
              return Future.delayed(
                Duration(seconds: 2),
              );
            });
      },
    );
  }
}
