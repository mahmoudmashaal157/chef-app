import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class Cache_Helper {
  static late SharedPreferences sharedPreferences;

  static sharedprefInstance ()async{
     sharedPreferences = await SharedPreferences.getInstance();
  }
  static Future<bool>SetData({
    required String key,
    required value,
}){
    if(value is int){
     return sharedPreferences.setInt(key, value);
    }
    else if(value is String){
      return sharedPreferences.setString(key, value);
    }
    else if (value is bool){
     return  sharedPreferences.setBool(key, value);
    }
    else {
     return sharedPreferences.setDouble(key, value);
    }
  }

  static getData({required String key}){
    return sharedPreferences.get(key);
  }



}