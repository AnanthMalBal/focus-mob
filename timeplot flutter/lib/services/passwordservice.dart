import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:focusontime/screens/changepassword_modal.dart';
// import 'package:focusontime/screens/changepassword_modal.dart';
import 'package:focusontime/services/sharedpreferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final shareddata = SharedPref();

SharedPreferences? prefs;


class PasswordService {
  sendEamil(String email, BuildContext context) async {
    print("Email" + email);
    final token = await shareddata.getpatdata();
var Token=token.authToken; 
   print("+++++"+Token);
    final String forgetpasswordUrl = dotenv.env['forgetPasswordUrl']!;
    final response = await http.post(
      Uri.parse(forgetpasswordUrl),
      headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': '$Token',
            },
      body: jsonEncode({
        'emailId': email,
      }),
    );
    if (response.statusCode == 200) {
       final responseData = jsonDecode(response.body);
      print("responseData:$responseData ");
       // Extract data from the response JSON
      String passwordToken = responseData["passwordtoken"];
      String firstPart = responseData["firstPart"];
      String expiresInMinutes = responseData["expiresInMinutes"];
      String messageType = responseData["message"]["type"];
      String messageInfo = responseData["message"]["info"];
      print("messageInfo:$messageInfo ");

// Store data in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("passwordToken", passwordToken);
      
     // Show success message
    
    // showdialog(context,messageInfo);
      //  ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(messageInfo)),     
      //  );
      // **Close the modal before showing success dialog**
      Navigator.pop(context);
      ChangePasswordModal(context);
     
    } else {
       final responseData = jsonDecode(response.body);
       String messageInfo = responseData["message"]["info"];
      print("messageInfo:$messageInfo ");
       showdialog(context,messageInfo);
      //  ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Failed to verify email. Try again!")),
      // );
    }
  }


updatePassword(String otp, String password, BuildContext context) async{
   
  print("otp:$otp,password:$password");
   final token = await shareddata.getpatdata();
var Token=token.passwordToken; 
   print("+++++"+Token);
    final String changePasswordUrl = dotenv.env['changepasswordUrl']!;
    final response = await http.post(
      Uri.parse(changePasswordUrl),
      headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': '$Token',
            },
      body: jsonEncode({
        'password': password,
        "otp":otp
      }),
    );
    
 // Check the status code of the response first
  print("Status code: ${response.statusCode}");

  if (response.statusCode == 200) {
    // Decode the response body
    final responseData = jsonDecode(response.body);
    print("responseData: $responseData");

    // Check if the response type is 'success'
    if (responseData["type"] == "success") {
      // **Close the modal before showing success dialog**
      Navigator.pop(context);
      // Show dialog with the success message
      showdialog(context, responseData["info"]);
     
     
      
    } else {
      // If "type" is not success, show an error dialog
      showdialog(context, "Failed to update password: ${responseData["info"]}");
    }
  }

}

}
