import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:focusontime/modules/lms/screens/applyleave.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:focusontime/services/sharedpreferences.dart';
import 'package:http/http.dart' as http;

final shareddata = SharedPref();
class ApplyLeaveService {



//   Future <List<dynamic>> getLeaveType(context) async {
//     print("fetching Leavetype");

// final token = await shareddata.getpatdata();
// var Token=token.accesstoken; 
//    print("+++++"+Token);
//    final String leaveTypeUrl = dotenv.env['levetypeUrl']!;
// print("+++++"+Token);
//     final response = (await http.post
//      (Uri.parse(leaveTypeUrl),
//     // (Uri.parse('$Ip/stashook/getLeaveTypeList'),
//     headers: {
//           'Content-Type':'application/json;charset=UTF-8',
//           'Authorization':'$Token',
//         },
//          body: json.encode({}),
//     ));
//      List<dynamic>dataLeaveType = json.decode(response.body);
    
//     print("LeaveType" + dataLeaveType.toString());
//     return dataLeaveType;
//   }

Future<List<dynamic>> getLeaveType( context) async {
  print("Fetching Leave Types...");

  final token = await shareddata.getpatdata();
  if (token == null || token.accesstoken == null) {
    throw Exception("Access token is null. Please check authentication.");
  }
  var Token = token.accesstoken;
  print("Token: $Token");

  final String? leaveTypeUrl = dotenv.env['levetypeUrl'];
  if (leaveTypeUrl == null) {
    throw Exception("Leave type URL is not set in environment variables.");
  }

  try {
    final response = await http.post(
      Uri.parse(leaveTypeUrl),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': '$Token',
      },
      body: json.encode({}), 
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      
      List<dynamic> decodedResponse = json.decode(response.body);

     
      if (decodedResponse is List) {
        return decodedResponse;
      } else {
        throw Exception("Unexpected response format: Expected a JSON array.");
      }
    } else {
      throw Exception(
          "Failed to fetch leave types. Status: ${response.statusCode}, Body: ${response.body}");
    }
  } catch (e) {
    print("Error fetching leave types: $e");
    rethrow;
  }
}

  Future applyLeave( String symbol,
      String fromDate, String toDate, String reason, context) async {
    print("DailyLog" +        
        symbol +
        fromDate +
        toDate +
        reason);

final token = await shareddata.getpatdata();
var Token=token.accesstoken; 
   print("+++++"+Token);
   final String? applyLeaveUrl = dotenv.env['applyleaveUrl']!;

    final response = await http.post(Uri.parse(applyLeaveUrl!),
     
       headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': '$Token',
            },
      
      body:jsonEncode ({
        
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
      // showdialog(context, result['message']);
       showSnackbar(context, result['message'], isSuccess: true); // Success Snackbar
      print("Request leave Sucess");
    } else {
      // showdialog(context, result['message']);
       showSnackbar(context, result['message'], isSuccess: false); // Success Snackbar
      print(" Invalid  ");
    }
    // return response.body;
  }

 

  Future getLeaveList(int page,int perPage,String sort,String firstDate,String lastDate, context) async {
    print("fetchapplyleavelist:");

    final token = await shareddata.getpatdata();
var Token=token.accesstoken; 
   print("+++++____"+Token);

  
    final String? leaveHistoryUrl = dotenv.env['searchLeaveUrl']!;
    if (leaveHistoryUrl == null) {
    print("Error: URL is not found in environment variables.");
    return [];
  }

    final response = (await http.post
    (Uri.parse(leaveHistoryUrl),
             headers: {
          'Content-Type':'application/json;charset=UTF-8',
          'Authorization':'$Token',
        }, 
        body:jsonEncode ({
        
        "fromDate": firstDate,
         "toDate": lastDate,
         "page": page.toString(),
         "perPage": perPage.toString(),
          "sort":sort
      }),
        ));
        
   if (response.statusCode == 200) {
    // Decode the response body
    var listData = json.decode(response.body);

    // Check if 'data' exists and is not null
    if (listData['data'] != null && listData['data'] is List) {
      List<dynamic> leaveList = listData['data']; // Use 'data' instead of 'result'
      print("leavelistdata: $leaveList");
      return leaveList;
    } 
   }
    // List<dynamic> leaveList = listData['result'];
    // // print("listdata" + leaveList.toString());
    // print("leavelistdata" + leaveList.toString());
    // return leaveList;
  }

  Future cancelLeaveList(String leaveId, context) async {
print ("cancelLeave:"+leaveId);
final token = await shareddata.getpatdata();
var Token=token.accesstoken; 
   print("+++++"+Token);



    print("cancelid"+leaveId);

    final String? cancelLeavehistoryUrl = dotenv.env['cancelLeaveUrl'];
    if (cancelLeavehistoryUrl == null) {
    print("Error: URL is not found in environment variables.");
    return [];
  }
    final response = await http.post(
       Uri.parse(cancelLeavehistoryUrl),
      
       headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': '$Token',
            },
        // jsonEncode
        body: jsonEncode ({
          'leaveId': leaveId,
          "comments":"No Needed at present {$leaveId}"

        }));
         print(response.statusCode);
    var result=json.decode(response.body);
    if (response.statusCode == 200) {
      // showdialog(context, "Leave Cancelled");
      showSnackbar(context, result['message'], isSuccess: true);
        print("LeaveCancled  ");
    }else{
 showSnackbar(context, result['message'], isSuccess: false); // Success Snackbar
      print(" Invalid  ");
    }
  }
}
