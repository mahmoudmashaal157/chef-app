import 'package:carousel_slider/carousel_slider.dart';
import 'package:chef_app/modules/login_screen/login_screen.dart';
import 'package:chef_app/shared/components/components.dart';
import 'package:chef_app/shared/constants/constants.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<String>images=[
    "assets/images/chef.jpg",
    "assets/images/chef 2.jpg",
    "assets/images/chef3.jpg"
  ];
  List<String>texts=[
    "Welcome to Our Chef App",
    "can't wait! share your delicious meals",
    "let's do it"
  ];
  CarouselController buttonCarouselController = CarouselController();
  int curindex= 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CarouselSlider.builder(
                carouselController: buttonCarouselController,
                  itemCount: 3,
                  itemBuilder: (context, index, realIndex) {
                    return buildSilderItem(index);
                  },
                options: CarouselOptions(
                  initialPage: 0,
                  height: double.infinity,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  onPageChanged: (index, reason) {
                    curindex=index;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: (){
                          setState(() {
                            buttonCarouselController.previousPage(duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            );
                          });
                        },
                        child: Text("Previous",
                          style: elevatedButtonTextColor,
                        ),

                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: (){
                          if(curindex==2){
                            navigateAndReplacement(context: context, Screen: LoginScreen());
                          }
                          setState(() {
                            buttonCarouselController.nextPage(
                                duration: Duration(milliseconds: 300),curve: Curves.easeInOut
                            );
                          });
                        },
                        child: Text("Next",
                        style: elevatedButtonTextColor,
                        ),

                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSilderItem (index){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height:300,
         width: double.infinity,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(15),
           image: DecorationImage(
             image: AssetImage("${images[index]}"),
             fit: BoxFit.fill,
           )
         ),
        ),
        Text(
          "${texts[index]}",
          style: TextStyle(
            fontSize: 20,
            fontWeight:FontWeight.bold
          ),
        ),
      ],
    );
  }
}
