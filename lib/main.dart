import 'package:chef_app/layout/cubit/layout_cubit.dart';
import 'package:chef_app/modules/sign_up/cubit/sign_up_cubit.dart';
import 'package:chef_app/modules/welcome_page/welcome_page.dart';
import 'package:chef_app/network/local/cache_helper/cache_helper.dart';
import 'package:chef_app/shared/bloc_observer/bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'layout/home.dart';
import 'shared/constants/constants.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Cache_Helper.sharedprefInstance();
  uId = Cache_Helper.getData(key: "uId");
  print(uId);
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();

  runApp( MyApp(uId:uId.toString()));
}

class MyApp extends StatelessWidget {
  final String uId;
  MyApp({required this.uId});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers:[
        BlocProvider<LayoutCubit>(create:(_)=>LayoutCubit()),
        BlocProvider<SignUpCubit>(create:(_)=>SignUpCubit()),
      ] ,
        child: MaterialApp(
          theme: ThemeData(
            primaryColor:mainColor,
            accentColor: mainColor,
            colorScheme: ThemeData().colorScheme.copyWith(
              primary: Colors.black,
              secondary: mainColor,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(mainColor),

                )
            ),
            appBarTheme:AppBarTheme(
                color: Color(0xffE4D8C8),
                titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                actionsIconTheme: IconThemeData(
                    color: Colors.black
                )
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: mainColor,
              selectedItemColor: selectedItemColor,

            ),
            primaryIconTheme: IconThemeData(
                color: Colors.black
            ),
            iconTheme: IconThemeData(
                color: mainColor
            ),
            inputDecorationTheme: InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                ),
                floatingLabelStyle: TextStyle(
                    color: Colors.black
                )
            ),
          ),
          debugShowCheckedModeBanner: false,
          home :startWidget(),
        ),
    );

  }

  Widget startWidget(){
    if(uId=="null"){
      return WelcomePage();
    }
  else return HomeScreen();
  }

}

