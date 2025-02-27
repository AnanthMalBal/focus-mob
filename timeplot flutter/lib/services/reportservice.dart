
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:focusontime/services/sharedpreferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final shareddata = SharedPref();

SharedPreferences? prefs;
class ReportService {

Future<Map<String, dynamic>?> fetchReportById(String empId) async {
  print("empIdReportservice: $empId");
    final response = await http.get(Uri.parse('http://192.168.31.45:3000/leave?empId=$empId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.isNotEmpty ? data.first : null;
    } else {
      throw Exception("Failed to load employee");
    }
  }

Future<List<Map<String, dynamic>>> myLeaveReport(String? empType,String? startDate,String? endDate) async {
print("myLeave: $empType,$startDate,$endDate");
 final token = await shareddata.getpatdata();
var Token=token.authToken; 
   print("+++++"+Token);

 final String leaveReportUrl = dotenv.env['myLeaveReportUrl']!;
  try {
    final response = await http.post(
      Uri.parse(leaveReportUrl),
     headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': '$Token',
            },
      body: jsonEncode({
        "empType": empType,
        "fromDate": startDate,
        "toDate": endDate
        }), // 🔹 Send employee ID in the request body
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      // ✅ Extract only the first list (Employee Data)
      if (jsonResponse.isNotEmpty && jsonResponse[0] is List) {
        List<Map<String, dynamic>> employeeList = List<Map<String, dynamic>>.from(jsonResponse[0]);
        return employeeList;
      }
    } else {
      print("Error: ${response.statusCode}");
    }
  } catch (e) {
    print("Exception: $e");
  }

  return []; // Return empty list if an error occurs
}

Future<List<Map<String, dynamic>>> myDailyLogReport(String? empType,String? startDate,String? endDate) async {
print("mydaily: $empType,$startDate,$endDate");
 final token = await shareddata.getpatdata();
var Token=token.authToken; 
   print("+++++"+Token);

 final String dailyLogUrl = dotenv.env['myDailyReportUrl']!;
  try {
    final response = await http.post(
      Uri.parse(dailyLogUrl),
     headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': '$Token',
            },
      body: jsonEncode({
        "empType": empType,
        "fromDate": startDate,
        "toDate": endDate
        }), // 🔹 Send employee ID in the request body
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      // ✅ Extract only the first list (Employee Data)
      if (jsonResponse.isNotEmpty && jsonResponse[0] is List) {
        List<Map<String, dynamic>> employeeList = List<Map<String, dynamic>>.from(jsonResponse[0]);
        return employeeList;
      }
    } else {
      print("Error: ${response.statusCode}");
    }
  } catch (e) {
    print("Exception: $e");
  }

  return []; // Return empty list if an error occurs
}






}