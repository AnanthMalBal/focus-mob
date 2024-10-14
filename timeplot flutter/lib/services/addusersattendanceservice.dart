
import 'package:http/http.dart' as http;
import 'package:timeplot_flutter/screens/appbar.dart';

class Addusersattendance{
   Future userAttendance(String employeeId, String symbol,String WFH,context, ) async {
  print("DailyLog"+ employeeId+symbol+WFH);
 
   final  response = await  http.post(Uri.parse ("http://192.168.31.45:3007/timesheet/addusersattendance"),
    body: ({
              'employeeId': employeeId,
              'symbol': symbol,
              'mode':WFH,
              
            }),
            
   );    
   print("check");
    print(response.statusCode);    
if (response.statusCode == 200){
  print("check1");
   showdialog(context, "Added Sucessfully");
  print("addattendance Sucess");
    }
else {        
      print(" Invalid  ");
      }
            // return response.body;
  }

 
}