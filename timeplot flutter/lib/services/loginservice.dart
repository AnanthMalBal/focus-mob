 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timeplot_flutter/screens/login.dart';
import 'package:timeplot_flutter/screens/welcome.dart';
import 'package:timeplot_flutter/services/sharedpreferences.dart';

 final shareddata = SharedPref();

SharedPreferences? prefs;


class LoginService{


  Future login(String username, String password,context) async {
  print("Login"+ username   +password);
 
   final  response = await  http.post(Uri.parse ("http://192.168.31.45:3007/auth/auth"),
    body: ({
              'username': username,
              'password': password,
            }),
            
   );
    print("check");
    var result = json.decode(response.body);
     setToken(result);
// var result = json.decode(response.body);
  
if (response.statusCode == 200){
  print("check1");
  
  print("Login Sucess");
  
      print("response"+response.body);
      // var result = json.decode(response.body);
      // loginData=result;
      print("result"+result['Empid']);
 Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => welcomeScreen(),
            ));
          
  }
else {
        
      print(" Invalid Login ");
      }

   
      
            return response.body;

  }

  Future<dynamic> setToken(dynamic value) async {
    prefs = await SharedPreferences.getInstance();
   // print("value"+value);
   
    prefs!.setString('accesstoken',value['accesstoken']);
    prefs!.setString('Empid',value['Empid']);
    prefs!.setString('message',value['message']);
    
    

    return prefs;
  }

  Future getToken() async {
    prefs = await SharedPreferences.getInstance();
   // print( prefs!.getString(('accesstoken') ));
  //  print( "gettoken:"+ prefs!.getInt(('appId') ).toString());
     prefs!.getString(('accesstoken'));
      prefs!.getString('Empid');
     
 
    return prefs;
   

  }



  
}