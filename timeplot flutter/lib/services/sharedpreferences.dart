import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeplot_flutter/model/employeedetails.dart';

class SharedPref {
  Future setdata(EmployeeDetails employeeDetails) async {
    final preferences = await SharedPreferences.getInstance();
    
    await preferences.setString('Empid', employeeDetails.Empid);
    await preferences.setString('accesstoken', employeeDetails.accesstoken);
    await preferences.setString('message', employeeDetails.message);
    
    //print(patientDetails.userId+"inside shared set" + preferences.getString('userId').toString());
  }
  Future<EmployeeDetails> getpatdata() async {
    final preferences = await SharedPreferences.getInstance();
    
    final Empid = preferences.getString('Empid');
    final accesstoken = preferences.getString('accesstoken');
    final message = preferences.getString('message');
   
    //print("inside shared get" + preferences.getInt('userId'));
    return EmployeeDetails(
                          
                          Empid:Empid.toString(),
                          accesstoken: accesstoken.toString(),
                          message: message.toString(),
                          
                          );
  }

// Store total minutes for NBNP, NBP, and B
  Future<void> storeTotalMinutes(int totalNBNPMinutes, int totalNBPMinutes, int totalBMinutes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalNBNPMinutes', totalNBNPMinutes);
    await prefs.setInt('totalNBPMinutes', totalNBPMinutes);
    await prefs.setInt('totalBMinutes', totalBMinutes);
  }

  // Retrieve total minutes for NBNP, NBP, and B
  Future<Map<String, int>> getTotalMinutes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    int totalNBNPMinutes = prefs.getInt('totalNBNPMinutes') ?? 0;
    int totalNBPMinutes = prefs.getInt('totalNBPMinutes') ?? 0;
    int totalBMinutes = prefs.getInt('totalBMinutes') ?? 0;

    return {
      'totalNBNPMinutes': totalNBNPMinutes,
      'totalNBPMinutes': totalNBPMinutes,
      'totalBMinutes': totalBMinutes,
    };
  }
  
}