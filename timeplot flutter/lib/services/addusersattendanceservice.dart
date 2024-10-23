
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeplot_flutter/screens/appbar.dart';
import 'package:timeplot_flutter/services/sharedpreferences.dart';

final shareddata = SharedPref();

SharedPreferences? prefs;

class Addusersattendance{

// Access environment variables
 final String? Ip = dotenv.env['ENVIRONMENT']! =='dev' ? dotenv.env['LOCAL_IP']!:dotenv.env['SERVER_IP']!;

   Future userAttendance(String employeeId, String symbol,String WFH,context, ) async {
  print("DailyLog"+ employeeId+symbol+WFH);
 print('Local IP: $Ip');
final token = await shareddata.getpatdata();
var Token=token.accesstoken; 
   print("+++++"+Token);

   final  response = await  http.post(Uri.parse ("$Ip/stashook/markAttendance"),
  //  "http://192.168.31.45:3007/timesheet/addusersattendance"
  headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': ' $Token',
            },
    body: jsonEncode({
              'employeeId': employeeId,
              'symbol': symbol,
              'mode':WFH,
              
            }),
            
   );    
   print("check");
    var result = json.decode(response.body);
    print(response.statusCode);    
if (response.statusCode == 200){
  print("check1");
   showdialog(context,result['message']);
  print("addattendance Sucess");
    }
else {   
  showdialog(context,result['message']);     
      print(" Invalid  ");
      }
            // return response.body;
  }

 
}