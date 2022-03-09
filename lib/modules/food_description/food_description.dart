import 'package:chef_app/modules/chef_food/cubit/chef_food_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodDescription extends StatelessWidget {
  final int index ;
  FoodDescription({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Description"),
      ),
      body: BlocProvider(
        create: (context) => ChefFoodCubit(),
        child: buildFoodDescription(),
      ),
    );
    buildFoodDescription();
  }

  Widget buildFoodDescription() {
    return Builder(
      builder: (context) {
        ChefFoodCubit.get(context).getChefFoods();
        return BlocConsumer<ChefFoodCubit, ChefFoodState>(
          listener: (context, state) {},
          builder: (context, state) {
            ChefFoodCubit cubit = ChefFoodCubit.get(context);
            if(state is GetChefFoodSuccessfully)
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 400,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "${cubit.myFoods[index].image}"),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("${cubit.myFoods[index].dishName}",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${cubit.myFoods[index].description}",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
            else
              return Center(child: CircularProgressIndicator());
          },
        );
      }
    );
  }
}
