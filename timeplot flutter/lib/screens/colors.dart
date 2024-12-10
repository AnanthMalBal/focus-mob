import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF1C8139);
  // Color.fromARGB(255, 19, 139, 23);//for all background color
  // static const Color secondaryColor = Color(0xFF03DAC6);
  // static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color backgroundColor = Colors.white;// for all text 
  static const Color textColor = Colors.black;
   static const Color borderColor = Colors.grey;
  // Add other colors as needed
  // Color.fromARGB(255, 62, 201, 118);
}
// #1C8139

TextStyle get subHeadingStyle{
  return GoogleFonts.lato (
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color:AppColors.borderColor    
    )
  );
}

TextStyle get headingStyle{
  return GoogleFonts.lato (
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,   
        color:AppColors.textColor   
    )
  );
}