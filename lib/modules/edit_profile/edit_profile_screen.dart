import 'package:chef_app/modules/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:chef_app/shared/components/components.dart';
import 'package:chef_app/shared/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: BlocProvider(
        create: (context) => EditProfileCubit(),
        child: buildEditProfile(),
      ),
    );
  }

  Widget buildEditProfile() {
    return Builder(
      builder: (context) {
        EditProfileCubit cubit = EditProfileCubit.get(context);
        cubit.getUserData();
        return BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {},
          builder: (context, state) {
            EditProfileCubit cubit = EditProfileCubit.get(context);
            if(cubit.userData!=null){
              nameController.text=cubit.userData!.name.toString();
              emailController.text =cubit.userData!.email.toString();
              phoneController.text=cubit.userData!.phone.toString();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          width: 400,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: cubit.image==null? NetworkImage(
                                  "${cubit.userData!.image}")
                              :FileImage(cubit.image!)as ImageProvider,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            cubit.pickImage();
                          },
                          icon: Icon(Icons.camera_alt, size: 30,),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person,),
                        ),

                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email,),
                        ),

                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone,),
                        ),

                      ),
                    ),
                    SizedBox(height: 20,),
                    state is! UpdateUserDataLoading?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              cubit.updateUserData(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  email: emailController.text);
                            },
                            child: Text("Done",
                              style: elevatedButtonTextColor,
                            )
                        ),
                      ),
                    )
                    :Center(child: CircularProgressIndicator()),
                  ],
                ),
              );
            }
            else return Center(child: CircularProgressIndicator());
          },
        );
      }
    );
  }
}