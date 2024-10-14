import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:timeplot_flutter/screens/appbar.dart';

class ApplyLeaveService {
  Future getLeaveType(context) async {
    print("Leavetype");
    final response = (await http
        .get(Uri.parse('http://192.168.31.45:3007/timesheet/getLeaveType')));
    List<dynamic> dataLeaveType = json.decode(response.body);
    print("LMS" + dataLeaveType.toString());
    return dataLeaveType;
  }

  Future applyLeave(String employeeId, double noOfDays, String symbol,
      String fromDate, String toDate, String reason, context) async {
    print("DailyLog" +
        employeeId +
        noOfDays.toString() +
        symbol +
        fromDate +
        toDate +
        reason);

    final response = await http.post(
      Uri.parse("http://192.168.31.45:3007/users/addusersleave"),
      body: ({
        'employeeId': employeeId,
        'noOfDays': noOfDays.toString(),
        'symbol': symbol,
        'fromDate': fromDate,
        'toDate': toDate,
        'reason': reason
      }),
    );
    print("check");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("check1");
      showdialog(context, "RequestLeaveadded");
      print("Request leave Sucess");
    } else {
      print(" Invalid  ");
    }
    // return response.body;
  }

 

  Future getLeaveList(String empid, context) async {
    print("Leavelist" + empid);
    final response = (await http.get(Uri.parse(
        'http://192.168.31.45:3007/users/userleavelist?employeeId=' +
            empid.toString())));
    var listData = json.decode(response.body.toString());
    List<dynamic> leaveList = listData['result'];
    // print("listdata" + leaveList.toString());
    print("listdata" + leaveList.toString());
    return leaveList;
  }

  Future cancelLeaveList(String leaveId, context) async {
    print("cancelid"+leaveId);
    final response = await http.post(
        Uri.parse("http://192.168.31.45:3007/users/userleavecancel"),
        body: {'leaveId': leaveId});
    if (response.statusCode == 200) {
      showdialog(context, "Leave Cancelled");
    }
  }
}
