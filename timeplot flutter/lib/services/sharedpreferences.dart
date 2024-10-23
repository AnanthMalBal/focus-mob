import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeplot_flutter/model/employeedetails.dart';

class SharedPref {
  Future setdata(EmployeeDetails employeeDetails) async {
    final preferences = await SharedPreferences.getInstance();
    
    await preferences.setString('userId', employeeDetails.userId);
    await preferences.setString('accesstoken', employeeDetails.accesstoken);
    await preferences.setString('message', employeeDetails.message);
    
    //print(patientDetails.userId+"inside shared set" + preferences.getString('userId').toString());
  }
  Future<EmployeeDetails> getpatdata() async {
    final preferences = await SharedPreferences.getInstance();
    
    final userId = preferences.getString('userId');
    final accesstoken = preferences.getString('accesstoken');
    final message = preferences.getString('message');
   
    //print("inside shared get" + preferences.getInt('userId'));
    return EmployeeDetails(
                          
                          userId:userId.toString(),
                          accesstoken: accesstoken.toString(),
                          message: message.toString(),
                          
                          );
  }


  
}