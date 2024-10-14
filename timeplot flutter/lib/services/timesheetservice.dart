import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:timeplot_flutter/screens/appbar.dart';

class TimeSheetService {
  Future getProjectId(context) async {
    print("ProjectId");
    final response = (await http
        .get(Uri.parse('http://192.168.31.45:3007/timesheet/getProjectList')));
    List<dynamic> dataProjectId = await json.decode(response.body);
    print("projectId****" + dataProjectId.toString());
    return dataProjectId;
  }

  Future getProcessId(context) async {
    print("ProcessId");
    final response = (await http
        .get(Uri.parse('http://192.168.31.45:3007/timesheet/getProcessList')));
    List<dynamic> dataProcessId = await json.decode(response.body);
    print("projectId====" + dataProcessId.toString());
    return dataProcessId;
  }

  Future getTimesheetId(String date, context) async {
    print("TimesheetId" + date);
    final response = (await http.get(Uri.parse(
        'http://192.168.31.45:3007/timesheet/getTimesheetId?markedTime=' +
            date.toString())));
    //
    List<dynamic> dataTimesheetId = await json.decode(response.body);
    print("TimesheetId++++" + dataTimesheetId.toString());
    return dataTimesheetId;
  }

  Future userDailyLog(String projectId, String processId, String timesheetId,
      String actualTime, String description,String bill, context) async {
    print("DailyLog" +
        projectId +
        processId +
        timesheetId +
        actualTime +
        description+
        bill);

    final response = await http.post(
      Uri.parse("http://192.168.31.45:3007/users/addusersdailylog"),
      body: ({
        'projectId': projectId,
        'processId': processId,
        'timesheetId': timesheetId,
        'billType':bill,
        'actualTime': actualTime,
        'description': description,
        
      }),
    );
    print("check");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("check1");
      showdialog(context, "Added Sucessfully");
      print("add timesheet Sucess");
    } else {
      print(" Invalid  ");
    }
    // return response.body;
  }

  Future getMarkedTime(String empid, String date, context) async {
    print("MarkedTime" + date + empid);
    final response = (await http.get(Uri.parse(
        'http://192.168.31.45:3007/timesheet//getmarkedtime?employeeId=' +
            empid +
            "&date=" +
            date.toString())));
    var listData = json.decode(response.body.toString());
    List<dynamic> dataMarkedTime = listData['result'];
    print("TimesheetId++++" + dataMarkedTime.toString());
    return dataMarkedTime;
  }


Future getDailyLog(dynamic id,  context) async {
    print("DailyLog" + id.toString());
    final response = (await http.get(Uri.parse(
        'http://192.168.31.45:3007/timesheet//getUsersDailyLog?timesheetId='
          +id .toString()
             )));
            print('API Response: ${response.body}');
    final listDailyLog = json.decode(response.body.toString());
    // List<dynamic> dataDailyLog = listDailyLog['result'];
    print("dailylog++++" + listDailyLog.toString());
    return listDailyLog;
  }



Future updateTimesheet(int hoursBillable, int hoursNBNP, int hoursNBP, String timesheetId,
       context) async {
    print("updatetimesheet" +
        hoursBillable.toString() +
         hoursNBNP .toString()+
        hoursNBP .toString()
        );

    final response = await http.post(
      Uri.parse("http://192.168.31.45:3007/timesheet/updateUserTimesheet"),
      body: ({
        'hoursBillable': hoursBillable.toString(),
        'hoursNBNP': hoursNBNP.toString(),
        'hoursNBP': hoursNBP.toString(),
       'timesheetId':timesheetId
      }),
    );
    print("check");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("check1");
      showdialog(context, "update Sucessfully");
      print("update timesheet Sucess");
    } else {
      print(" Invalid  ");
    }
    // return response.body;
  }


Future deleteTimesheet(int autoId, context)async{
  print("autoid" +
        autoId.toString()      
        );
        final response = await http.delete(
      Uri.parse("http://192.168.31.45:3007/timesheet/deleteUserDailyLog"),
      body: ({
        'autoId': autoId.toString(),
        
      }),
    );
     print("check");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("check1");
      showdialog(context, "delete Sucessfully");
      print("delete Sucess");
    } else {
      print(" Invalid  ");
    }
}

}
