import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:focusontime/modules/lms/screens/welcome.dart';
import 'package:focusontime/services/menuservice.dart';
import 'package:focusontime/services/sharedpreferences.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

// import 'package:timeplot_flutter/screens/login.dart';


final shareddata = SharedPref();

SharedPreferences? prefs;
 final MenuService menuservice = MenuService();

class LoginService {
//  final String localIp = '${dotenv.env['LOCALLOGIN_IP'] }';
  // final String? Ip = dotenv.env['ENVIRONMENT']! == 'dev'
  //     ? dotenv.env['LOCALLOGIN_IP']!
  //     : dotenv.env['SERVER_IP']!;

  Future login(String username, String password, BuildContext context) async {
    print("Login" + username + password);
    final String loginUrl = dotenv.env['loginUrl']!;

    // Check if loginUrl is available
    // if (loginUrl == null || loginUrl.isEmpty) {
    //   print("Error: login URL is not defined or empty.");
    //   return;
    // }
    final response = await http.post(
      Uri.parse(loginUrl),
      body: ({
        'username': username,
        'password': password,
      }),
    );
    print("check");
    var result = json.decode(response.body);
    setToken(result);
// var result = json.decode(response.body);
  
    if (response.statusCode == 200) {
      print("check1");

      print("Login Sucess");

      print("response" + response.body);
      // var result = json.decode(response.body);
      // loginData=result;
       print("token: " + result['accesstoken']);
      print("result" + result['user']['userId']);
      String token = result['accesstoken'];
      List<dynamic> roles = result['user']['roles'];  // roles is now a List

    // Ensure roles is a comma-separated string when passing to getMenu
    String rolesString = roles.join(',');  
       // Fetch the menu items using getMenu
              List<Map<String, dynamic>> menuItems = await LoginService().getMenu(token,rolesString);

              // Check if menuItems is not empty before navigating
              if (menuItems.isNotEmpty) {
              
                // Navigate to the WelcomeScreen and pass the menuItems as a parameter
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => welcomeScreen(resultMenu: menuItems ),  // Pass menuItems here
                  ),
                );
              }
      return result['message'];
    } else {
      print(" Invalid Login ");
      //  showdialog(context, result['message']);
      return result['message'];
    }

    //  return response.body;
  }

  // Future<dynamic> setToken(dynamic value) async {
  //   prefs = await SharedPreferences.getInstance();
  //   // print("value"+value);

  //   prefs!.setString('accesstoken', value['accesstoken']);
  //   prefs!.setString('userId', value['user']['userId']);
  //   prefs!.setStringList('roles', value['user']['roles']);
  //   prefs!.setString('message', value['message']);

  //   return prefs;
  // }
  Future<void> setToken(Map<String, dynamic> value) async {
    final preferences = await SharedPreferences.getInstance();

    // Convert roles to List<String>
    List<String> roles = List<String>.from(value['user']['roles']);

    // Store the roles in SharedPreferences
    await preferences.setStringList('roles', roles);

    // Optionally, store other data as well
     preferences.setString('userId', value['user']['userId']);
    await preferences.setString('accesstoken', value['accesstoken']);
    await preferences.setString('message', value['message']);
     await preferences.setString('userName', value['user']['userName']);

    // Print to check
    // print("Stored roles: $roles");
  }

  Future getToken() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs!.getString(('accesstoken')));
    print(prefs!.getString(('userId')));
    //  print( "gettoken:"+ prefs!.getInt(('appId') ).toString());
    prefs!.getString(('accesstoken'));
    prefs!.getString('userId');
     prefs!.getString('userName');
    prefs!.getStringList('roles');

    return prefs;
  }

Future<List<Map<String, dynamic>>> getMenu(String token, String roles) async {
    print("tokenroles: $token $roles");
    try {
      // Fetch the menu items using the MenuService
      List<Map<String, dynamic>> resultMenu = await menuservice.fetchMenuItems(token, roles);
      print("resultMenu: $resultMenu");
      // Log menu names dynamically
    for (var menu in resultMenu) {
      print("Menu Name: ${menu['menuName']}");
    }
      return resultMenu;
    } catch (e) {
      print('Error fetching menu items: $e');
      return [];  // Return an empty list if an error occurs
    }
  }

}
