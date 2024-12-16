import 'package:focusontime/model/employeedetails.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPref {
  Future setdata(EmployeeDetails employeeDetails) async {
    final preferences = await SharedPreferences.getInstance();
    
    await preferences.setString('userId', employeeDetails.userId);
     await preferences.setStringList('roles', employeeDetails.roles);
    await preferences.setString('accesstoken', employeeDetails.accesstoken);
    await preferences.setString('message', employeeDetails.message);
     await preferences.setString('userName', employeeDetails.userName);
    
    //print(patientDetails.userId+"inside shared set" + preferences.getString('userId').toString());
  }
  Future<EmployeeDetails> getpatdata() async {
    final preferences = await SharedPreferences.getInstance();
    
    final userId = preferences.getString('userId');
    final roles = preferences.getStringList('roles')?? [];;
    final accesstoken = preferences.getString('accesstoken');
    final message = preferences.getString('message');
    final userName = preferences.getString('userName');
   
    // print("inside shared get" + accesstoken.toString());
    return EmployeeDetails(
                          
                          userId:userId.toString(),
                          roles:roles,
                          accesstoken: accesstoken.toString(),
                          message: message.toString(),
                            userName: userName.toString(),
                          
                          );
  }


  
}