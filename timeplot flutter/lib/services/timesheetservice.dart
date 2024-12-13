import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:timeplot_flutter/screens/appbar.dart';

class TimeSheetService {
  Future <List<Map<String, dynamic>>> getProjectId(String id,context) async {
    print("ProjectId:"+id);
     final token = await shareddata.getpatdata();
    if (token == null || token.accesstoken == null) {
      throw Exception("Access token is null. Please check authentication.");
    }
    var Token = token.accesstoken;
    print("Token: $Token");
    final String? getProjectListUrl = dotenv.env['projectListUrl'];
    if (getProjectListUrl == null) {
      throw Exception("Leave type URL is not set in environment variables.");
    }
    try {
      final response = await http.post(
        Uri.parse(getProjectListUrl),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': '$Token',
        },
        body: json.encode({"divisionId" : id, }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body project: ${response.body}");

       if (response.statusCode == 200) {
      List<dynamic> decodedResponse = json.decode(response.body);

      if (decodedResponse is List) {
        return decodedResponse.cast<Map<String, dynamic>>(); // Cast to List<Map<String, dynamic>>
      } else {
        throw Exception("Unexpected response format: Expected a JSON array.");
      }
    } else {
      throw Exception(
          "Failed to fetch timesheet data. Status: ${response.statusCode}, Body: ${response.body}");
    }
    } catch (e) {
      print("Error fetching leave types: $e");
      rethrow;
    }

    // final response = (await http
    //     .get(Uri.parse('http://192.168.31.45:3007/timesheet/getProjectList')));
    // List<dynamic> dataProjectId = await json.decode(response.body);
    // print("projectId****" + dataProjectId.toString());
    // return dataProjectId;
  }

  Future <List<Map<String, dynamic>>>getProcessId( String id, context) async {
    print("ProcessId:"+id);
    final token = await shareddata.getpatdata();
    if (token == null || token.accesstoken == null) {
      throw Exception("Access token is null. Please check authentication.");
    }
    var Token = token.accesstoken;
    print("Token: $Token");
    final String? getProcessListUrl = dotenv.env['processListUrl'];
    if (getProcessListUrl == null) {
      throw Exception("Leave type URL is not set in environment variables.");
    }
    try {
      final response = await http.post(
        Uri.parse(getProcessListUrl),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': '$Token',
        },
        body: json.encode({"projectId" : id, }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body process: ${response.body}");

       if (response.statusCode == 200) {
      List<dynamic> decodedResponse = json.decode(response.body);

      if (decodedResponse is List) {
        return decodedResponse.cast<Map<String, dynamic>>(); // Cast to List<Map<String, dynamic>>
      } else {
        throw Exception("Unexpected response format: Expected a JSON array.");
      }
    } else {
      throw Exception(
          "Failed to fetch timesheet data. Status: ${response.statusCode}, Body: ${response.body}");
    }
    } catch (e) {
      print("Error fetching leave types: $e");
      rethrow;
    }



    // final response = (await http
    //     .get(Uri.parse('http://192.168.31.45:3007/timesheet/getProcessList')));
    // List<dynamic> dataProcessId = await json.decode(response.body);
    // print("projectId====" + dataProcessId.toString());
    // return dataProcessId;
  }

  Future <List<Map<String, dynamic>>> fetchTimesheet(String date, context) async {
    print("Timesheet:" + date);
    final token = await shareddata.getpatdata();
    if (token == null || token.accesstoken == null) {
      throw Exception("Access token is null. Please check authentication.");
    }
    var Token = token.accesstoken;
    print("Token: $Token");
    final String? getTimesheetUrl = dotenv.env['timesheetUrl'];
    if (getTimesheetUrl == null) {
      throw Exception("Leave type URL is not set in environment variables.");
    }
    try {
      final response = await http.post(
        Uri.parse(getTimesheetUrl),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': '$Token',
        },
        body: json.encode({"fromDate": date, "toDate": date}),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

       if (response.statusCode == 200) {
      List<dynamic> decodedResponse = json.decode(response.body);

      if (decodedResponse is List) {
        return decodedResponse.cast<Map<String, dynamic>>(); // Cast to List<Map<String, dynamic>>
      } else {
        throw Exception("Unexpected response format: Expected a JSON array.");
      }
    } else {
      throw Exception(
          "Failed to fetch timesheet data. Status: ${response.statusCode}, Body: ${response.body}");
    }
    } catch (e) {
      print("Error fetching leave types: $e");
      rethrow;
    }

    // final response = (await http.get(Uri.parse(
    //     'http://192.168.31.45:3007/timesheet/getTimesheetId?markedTime=' +
    //         date.toString())));
    // //
    // List<dynamic> dataTimesheetId = await json.decode(response.body);
    // print("TimesheetId++++" + dataTimesheetId.toString());
    // return dataTimesheetId;
  }

  Future userDailyLog(String projectId, String processId, String timesheetId,
      String actualTime, String description,  String date, context) async {
    print("addDailyLog:" +
        projectId +
        processId +
        timesheetId +
        actualTime +
        description +
         date);

         final token = await shareddata.getpatdata();
var Token=token.accesstoken; 
   print("+++++"+Token);
final String addDailyLogUrl = dotenv.env['addDailylogUrl']!;


    final response = await http.post(
      Uri.parse(addDailyLogUrl),
      headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': '$Token',
        },
      body: json.encode({
        'projectId': projectId,
        'processId': processId,
        'timesheetId': timesheetId,
        // 'billType': bill,
        'actualTime': actualTime,
        'description': description,
        "attendanceDate": date,
      }),
    );
    print("check");
    print(response.statusCode);
    var result = json.decode(response.body);
    
    if (response.statusCode == 200) {
      print("check1");
      // showdialog(context, "Added Sucessfully");
      showSnackbar(context, result['message'], isSuccess: true);
      print("add timesheet Sucess");
    } else {
      print(" Invalid  ");
      showSnackbar(context, result['message'], isSuccess: false);
    }
    // return response.body;
  }

  Future<Map<String, dynamic>> fetchMarkedAttendance( String date,context) async {
    print("fetch mark attendance:"+date);
    final token = await shareddata.getpatdata();
    if (token == null || token.accesstoken == null) {
      throw Exception("Access token is null. Please check authentication.");
    }
    var Token = token.accesstoken;
    print("Token: $Token");
    final String? getMarkedAttendanceUrl = dotenv.env['markedAttendanceUrl'];
    if (getMarkedAttendanceUrl == null) {
      throw Exception("Leave type URL is not set in environment variables.");
    }

    try {
      final response = await http.post(
        Uri.parse(getMarkedAttendanceUrl),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': '$Token',
        },
        body: json.encode({"attendanceDate": date }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        if (decodedResponse is Map<String, dynamic>) {
          return decodedResponse;
        } else {
          throw Exception(
              "Unexpected response format: Expected a JSON object.");
        }
      } else {
        throw Exception(
            "Failed to fetch marked attendance. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching leave types: $e");
      rethrow;
    }
    // final response = (await http.get(Uri.parse(
    //     'http://192.168.31.45:3007/timesheet//getmarkedtime?employeeId=' +
    //         empid +
    //         "&date=" +
    //         date.toString())));
    // var listData = json.decode(response.body.toString());
    // List<dynamic> dataMarkedTime = listData['result'];
    // print("TimesheetId++++" + dataMarkedTime.toString());
    // return dataMarkedTime;
  }

  Future <List<Map<String, dynamic>>> getDailyLog(dynamic id, context) async {
    print("getDailyLog" + id.toString());
    final token = await shareddata.getpatdata();
    if (token == null || token.accesstoken == null) {
      throw Exception("Access token is null. Please check authentication.");
    }
    var Token = token.accesstoken;
    print("Token: $Token");
    final String? dailyLogUrl = dotenv.env['getDailyLogUrl'];
    if (dailyLogUrl  == null) {
      throw Exception("Leave type URL is not set in environment variables.");
    }
 try {
      final response = await http.post(
        Uri.parse(dailyLogUrl ),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': '$Token',
        },
        body: json.encode({
           "timesheetId" : id
        }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body getdailylog: ${response.body}");

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

         if (decodedResponse is List) {
        return decodedResponse.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
            "Unexpected response format: Expected a JSON array.");
      }
      } else {
        throw Exception(
            "Failed to fetch marked attendance. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching leave types: $e");
      rethrow;
    }

    // final response = (await http.get(Uri.parse(
    //     'http://192.168.31.45:3007/timesheet//getUsersDailyLog?timesheetId=' +
    //         id.toString())));
    // print('API Response: ${response.body}');
    // final listDailyLog = json.decode(response.body.toString());
    // // List<dynamic> dataDailyLog = listDailyLog['result'];
    // print("dailylog++++" + listDailyLog.toString());
    // return listDailyLog;
  }

  Future updateTimesheet( String timesheetId, int hoursBillable, int hoursNBNP, int hoursNBP,
     context) async {
    print("updatetimesheet:" +
        hoursBillable.toString() +
        hoursNBNP.toString() +
        hoursNBP.toString()+timesheetId.toString());

final token = await shareddata.getpatdata();
var Token=token.accesstoken; 
   print("+++++"+Token);
final String updateTimesheetUrl = dotenv.env['updateUsertimesheetUrl']!;
    final response = await http.post(
      Uri.parse(updateTimesheetUrl),
         headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': '$Token',
        },
      body: json.encode({
        'timesheetId': timesheetId,
        'hoursBillable': hoursBillable.toString(),
        'hoursNBNP': hoursNBNP.toString(),
        'hoursNBP': hoursNBP.toString(),
        
      }),
    );
    print("check");
    print(response.statusCode);
    var result = json.decode(response.body);
    if (response.statusCode == 200) {
      print("check1");
      // showdialog(context, "update Sucessfully");
       showSnackbar(context, result['message'], isSuccess: true);
      print("update timesheet Sucess");
    } else {
       showSnackbar(context, result['message'], isSuccess: false);
      print(" Invalid  ");
    }
    // return response.body;
  }

  Future deleteTimesheet(String autoId, context) async {
    print("autoid" + autoId);
final token = await shareddata.getpatdata();
    if (token == null || token.accesstoken == null) {
      throw Exception("Access token is null. Please check authentication.");
    }
    var Token = token.accesstoken;
    print("Token: $Token");
    final String? deleteDailyLogUrl = dotenv.env['deleteDailylogUrl'];
    if (deleteDailyLogUrl  == null) {
      throw Exception("Leave type URL is not set in environment variables.");
    }

    final response = await http.post(
      Uri.parse(deleteDailyLogUrl),
       headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': '$Token',
        },
      body: json.encode({
        'autoId': autoId,
      }),
    );
    print("check");
    print(response.statusCode);
    var result=json.decode(response.body);
    print("result:"+result.toString());
    if (response.statusCode == 200) {
      print("check1");
      // showdialog(context, "delete Sucessfully");
      showSnackbar(context, result['message'], isSuccess: true); 
      print("delete Sucess");
    } else {
      showSnackbar(context, result['message'], isSuccess: true); 
      print(" Invalid  ");
    }
  }
}
