import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:focusontime/modules/lms/screens/applyleave.dart';
import 'package:http/http.dart' as http;


class HolidayService {
   Future fetchLeaveColor( String date, context) async {
    print("getcolor:"+ date);
     final token = await shareddata.getpatdata();
     var Token = token.authToken;
  print("Token: $Token");
  final String? leaveColourUrl = dotenv.env['leavecolourUrl'];
    final response = (await http.post(Uri.parse(
        leaveColourUrl! ),
        headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': '$Token',
    },
    body: json.encode({ "selectedDate": date}), // Assuming the request body is empty
  )
        );

    List<dynamic> data = json.decode(response.body);
    print("resultcolour" + data.toString());
    print("resultcolour1" + data[1].toString());
    return data;

  }


//  Future<Map<String, dynamic>> fetchLeaveColor(String date, context) async {
//   print("Fetching leave color for date: $date");

//   final token = await shareddata.getpatdata();
//   var Token = token.accesstoken; 
//   print("+++++" + Token);
  
//   if (token == null || token.accesstoken == null) {
//     throw Exception("Access token is null. Please check authentication.");
//   }
  
//   print("Token retrieved successfully.");

//   final String? leaveColorUrl = dotenv.env['leavecolourUrl'];
//   if (leaveColorUrl == null) {
//     throw Exception("Leave color URL is not configured in environment variables.");
//   }

//   try {
//     final response = await http.post(
//       Uri.parse(leaveColorUrl),
//       headers: {
//         'Content-Type': 'application/json;charset=UTF-8',
//         'Authorization': '$Token',
//       },
//       body: json.encode({"selectedDate": date}),
//     );

//     print("Response Status Code: ${response.statusCode}");
//     print("Response Body colour: ${response.body}");

//     if (response.statusCode == 200) {
//       final decodedResponse = json.decode(response.body);
      
//       // Check if the response is a nested list
//       if (decodedResponse is List && decodedResponse.isNotEmpty) {
//         List<dynamic> outerList = decodedResponse;

//         // Assuming the first item in the list is the data you need
//         List<dynamic> leaveData = outerList[0];

//         // Return the data as a Map<String, dynamic>
//         return {"leaveData": leaveData};
//       } else {
//         throw Exception("Unexpected response format: Expected a nested list.");
//       }
//     } else {
//       throw Exception(
//         "Failed to fetch leave color. Status: ${response.statusCode}, Body: ${response.body}",
//       );
//     }
//   } catch (e) {
//     print("Error occurred: $e");
//     rethrow; // Re-throw the exception for further handling if needed
//   }
// }

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
  // Future getLeaveBalance(String empid, context) async {

  //   print("Fetching Leave balance...");

  //   final response = (await http.get(Uri.parse(
  //       'http://192.168.31.45:3007/timesheet/getLeaveBalance?empid=' +
  //           empid.toString())));
  //   List<dynamic> dataBalance = json.decode(response.body.toString());
  //   print("LMS" + dataBalance.toString());
  //   return dataBalance;
  // }

Future<Map<String, dynamic>> getLeaveBalance( context) async {
  print("Fetching Leave Balance...");

  final token = await shareddata.getpatdata();
  if (token == null || token.authToken == null) {
    throw Exception("Access token is null. Please check authentication.");
  }
  var Token = token.authToken;
  print("Token: $Token");

  final String? leaveBalanceUrl = dotenv.env['leavebalanceUrl'];

  final response = await http.post(
    Uri.parse(leaveBalanceUrl!),
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': '$Token',
    },
    body: json.encode({}), // Assuming the request body is empty
  );

  print("Response Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    Map<String, dynamic> decodedResponse = json.decode(response.body);

    // Check if the response is an object (Map)
    if (decodedResponse is Map<String, dynamic>) {
      return decodedResponse;
    } else {
      throw Exception("Unexpected response format: Expected a JSON object.");
    }
  } else {
    throw Exception(
      "Failed to fetch leave balance. Status: ${response.statusCode}, Body: ${response.body}",
    );
  }
}

}
  

