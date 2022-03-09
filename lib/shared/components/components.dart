import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget textFormFieldOfUserData({
  required String hint,
  IconData? prefixIcon,
  IconData? suffixIcon,
  required  validation(String value),
  bool isPassword = false,
  required TextEditingController controller,
  required TextInputType keyboardTybe,
   Function? onsuffixPressed,

}){
  return Padding(
    padding: const EdgeInsets.only(bottom: 15,right: 20,left: 20,top: 10),
    child: Container(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardTybe,
        obscureText: isPassword,
        decoration: InputDecoration(
          label: Text(hint),
          border: OutlineInputBorder(),
          prefixIcon: prefixIcon != null? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon !=null ? IconButton(icon:Icon(suffixIcon),onPressed: (){
            onsuffixPressed!();
            },
            ) : null,
        ),
        validator: (value) =>validation(value!)

      ),
    ),
  );
}

Widget textFormFieldOfUserDataPassword({
  required String hint,
  IconData? prefixIcon,
  IconData? suffixIcon,
  required  validation(String value),
  bool isPassword = false,
  required TextEditingController controller,
  required TextInputType keyboardTybe,
  Function? onsuffixPressed,
   required onChange(value),

}){
  return Padding(
    padding: const EdgeInsets.only(bottom: 15,right: 20,left: 20,top: 10),
    child: Container(
      width: double.infinity,
      child: TextFormField(
          controller: controller,
          keyboardType: keyboardTybe,
          obscureText: isPassword,
          decoration: InputDecoration(
            label: Text(hint),
            border: OutlineInputBorder(),
            prefixIcon: prefixIcon != null? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon !=null ? IconButton(icon:Icon(suffixIcon),onPressed: (){
              onsuffixPressed!();
            },
            ) : null,
          ),
          validator: (value) =>validation(value!),
        onChanged: (value) {
          onChange(value);
        },

      ),
    ),
  );
}

void navigateTo({required BuildContext context, required Widget Screen}){
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Screen;
  },));
}

void navigateAndReplacement({required BuildContext context, required Widget Screen}){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    return Screen;
  },));
}

 showToast (String msg){
   Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}