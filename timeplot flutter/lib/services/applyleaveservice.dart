import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:timeplot_flutter/screens/appbar.dart';

class ApplyLeaveService {

final String? Ip = dotenv.env['ENVIRONMENT']! =='dev' ? dotenv.env['LOCAL_IP']!:dotenv.env['SERVER_IP']!;

  Future getLeaveType(context) async {
    print("Leavetype");

final token = await shareddata.getpatdata();
var Token=token.accesstoken; 
   print("+++++"+Token);

    final response = (await http.get
    // (Uri.parse('http://192.168.31.45:3007/timesheet/getLeaveType')));
    (Uri.parse('$Ip/stashook/getLeaveTypeList'),
    headers: {
          'contentType':'application/json;charset=UTF-8',
          'Authorization':'$Token',
        }
    ));
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

final token = await shareddata.getpatdata();
var Token=token.accesstoken; 
   print("+++++"+Token);

    final response = await http.post(
      // Uri.parse("http://192.168.31.45:3007/users/addusersleave"),
      Uri.parse("$Ip/stashook/applyLeave"),
       headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': ' $Token',
            },
      body:jsonEncode ({
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
    var result=json.decode(response.body);
    if (response.statusCode == 200) {
      print("check1");
      showdialog(context, result['message']);
      print("Request leave Sucess");
    } else {
      showdialog(context, result['message']);
      print(" Invalid  ");
    }
    // return response.body;
  }

 

  Future getLeaveList(String empid, context) async {

    final token = await shareddata.getpatdata();
var Token=token.accesstoken; 
   print("+++++"+Token);

    print("Leavelist" + empid);

    final response = (await http.get
    (Uri.parse('http://192.168.31.45:3007/users/userleavelist?employeeId=' +
            empid.toString()),
             headers: {
          'contentType':'application/json;charset=UTF-8',
          'Authorization':'$Token',
        }));
    var listData = json.decode(response.body.toString());
    List<dynamic> leaveList = listData['result'];
    // print("listdata" + leaveList.toString());
    print("listdata" + leaveList.toString());
    return leaveList;
  }

  Future cancelLeaveList(String leaveId, context) async {

final token = await shareddata.getpatdata();
var Token=token.accesstoken; 
   print("+++++"+Token);
    print("cancelid"+leaveId);
    final response = await http.post(
      Uri.parse("$Ip/stashook/cancelLeave"),
       headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': ' $Token',
            },
        // Uri.parse("http://192.168.31.45:3007/users/userleavecancel"),
        body: jsonEncode ({'leaveId': leaveId}));
    if (response.statusCode == 200) {
      showdialog(context, "Leave Cancelled");
    }
  }
}
