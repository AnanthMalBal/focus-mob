import 'dart:convert';
import 'package:http/http.dart' as http;

class HolidayService {
  Future getHolidays(String id, String date, context) async {
    print("dataa" + id + date);
    final response = (await http.get(Uri.parse(
        'http://192.168.31.45:3007/timesheet/getHolidays?cdate=' +
            date.toString() +
            '&empid=' +
            id.toString())));

    List<dynamic> data = json.decode(response.body);
    print("result" + data.toString());
    return data;
//
  }

  Future getLMS(context) async {
    print("LMS");
    final response = (await http
        .get(Uri.parse('http://192.168.31.45:3007/timesheet/getLmsList')));
    List<dynamic> dataLMS = json.decode(response.body);
    print("LMS" + dataLMS.toString());
    return dataLMS;
  }

  // Future getLeaveBalance(String empid,context) async {
  //   print("LMSLeaveBalance"+empid);
  //   final response = (await http
  //       .get(Uri.parse('http://192.168.31.45:3007/timesheet/getLeaveBalance?empid='+empid.toString())));
  //   List<dynamic> dataBalance = json.decode(response.body);
  //   print("LMS" + dataBalance.toString());
  //   return dataBalance;
  // }
  Future getLeaveBalance(String empid, context) async {
    print("LMSLeaveBalance" + empid);
    final response = (await http.get(Uri.parse(
        'http://192.168.31.45:3007/timesheet/getLeaveBalance?empid=' +
            empid.toString())));
    List<dynamic> dataBalance = json.decode(response.body.toString());
    print("LMS" + dataBalance.toString());
    return dataBalance;
  }
}
