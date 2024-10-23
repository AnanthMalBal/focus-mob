 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeplot_flutter/screens/appbar.dart';
// import 'package:timeplot_flutter/screens/login.dart';
import 'package:timeplot_flutter/screens/welcome.dart';
import 'package:timeplot_flutter/services/sharedpreferences.dart';

 final shareddata = SharedPref();

SharedPreferences? prefs;


class LoginService{

//  final String localIp = '${dotenv.env['LOCALLOGIN_IP'] }';
final String? Ip = dotenv.env['ENVIRONMENT']! =='dev' ? dotenv.env['LOCALLOGIN_IP']!:dotenv.env['SERVER_IP']!;

  Future login(String username, String password,context) async {
  print("Login"+ username   +password);
 print('Local IP: $Ip');
   final  response = await  http.post(Uri.parse ("$Ip/stashook/login"),
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
       print("result"+result['user']['userId']);
      
 Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => welcomeScreen(),
            ));
       showdialog(context, result['message']);   
  }
   
else {
        
      print(" Invalid Login ");
      showdialog(context, result['message']); 
      }

   
      
            return response.body;

  }

  Future<dynamic> setToken(dynamic value) async {
    prefs = await SharedPreferences.getInstance();
   // print("value"+value);
   
    prefs!.setString('accesstoken',value['accesstoken']);
     prefs!.setString('userId',value['user']['userId']);
    prefs!.setString('message',value['message']);
    
    

    return prefs;
  }

  Future getToken() async {
    prefs = await SharedPreferences.getInstance();
    print( prefs!.getString(('accesstoken') ));
     print( prefs!.getString(('userId') ));
  //  print( "gettoken:"+ prefs!.getInt(('appId') ).toString());
     prefs!.getString(('accesstoken'));
     prefs!.getString('userId');
     
 
    return prefs;
   

  }



  
}