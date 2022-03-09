import 'package:chef_app/layout/cubit/layout_cubit.dart';
import 'package:chef_app/modules/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:chef_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:chef_app/shared/components/components.dart';
import 'package:chef_app/shared/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileCubit(),
      child: buildProfile(context),
    );
  }

  Widget buildProfile(context) {
    return Builder(
      builder: (context) {
        EditProfileCubit.get(context).getUserData();
        return BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {},
          builder: (context, state) {
            EditProfileCubit cubit = EditProfileCubit.get(context);
            if(cubit.posts!=null)
            return Column(
              children: [
                Container(
                  width: 500,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "${cubit.userData!.image}"),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Name : ${cubit.userData!.name.toString()}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20,),
                Text("Posts : ${cubit.posts}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        navigateTo(context: context, Screen: EditProfileScreen());
                      },
                      child: Text("Edit",
                        style: elevatedButtonTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
            else return Center(child: CircularProgressIndicator());
          },
        );
      }
    );
  }
}
