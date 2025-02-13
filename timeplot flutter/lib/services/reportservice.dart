
import 'dart:convert';

import 'package:http/http.dart' as http;
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

}