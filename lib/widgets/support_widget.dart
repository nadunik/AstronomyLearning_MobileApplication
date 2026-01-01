import 'package:flutter/material.dart';

class AppWidget{
  static TextStyle boldTextFieldStyle (){
    return TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 25.0,
              fontWeight: FontWeight.bold,);
  }
  static TextStyle lighttextFieldStyle(){
    return TextStyle(
      color: Color.fromARGB(137, 172, 164, 164), 
      fontSize: 20.0, 
      fontWeight: FontWeight.w500);
  }
}