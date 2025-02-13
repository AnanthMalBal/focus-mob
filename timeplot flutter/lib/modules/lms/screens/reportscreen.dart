import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:focusontime/services/reportservice.dart';
import 'package:focusontime/services/sharedpreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
final shareddata = SharedPref();
SharedPreferences? prefs;
class Reportscreen extends StatefulWidget {
  // const Reportscreen({super.key});
  final List<Map<String, dynamic>> resultMenu;

  const Reportscreen({super.key, required this.resultMenu}); 

  @override
  State<Reportscreen> createState() => _ReportscreenState();
}
class _ReportscreenState extends State<Reportscreen> {
  List<dynamic> leaveData = [];
  List<dynamic> dailyLogEntryData = [];
  // List<dynamic> employeesById = [];
  Map<String, dynamic>? employeesById;
  final ReportService reportservice = ReportService();
  String? empId;

  void transferdata() async {
    final empData = await shareddata.getpatdata();
    setState(() {
      empId = empData.userId;
      
      print("idreport" + empId.toString());
    });
   fetchEmployeesById(empId);
    
  }

  Future<void> readReportJson() async {
    final String response = await rootBundle.loadString('jsonfile/db.json');
    final Map<String, dynamic> data = json.decode(response);

    setState(() {
      leaveData = data["leave"] ?? [];
      dailyLogEntryData = data["dailyLogEntry"] ?? [];
    });

    print("leaveData: $leaveData");
    print("dailyLogEntryData: $dailyLogEntryData");
  }

 Future<void> fetchEmployeesById(empId) async {
  print("empIdReport: $empId");
    try {
      Map<String, dynamic>? data = await reportservice.fetchReportById(empId);
      setState(() {
        employeesById = data;
      });
       print("employeesById: $employeesById");
    } catch (e) {
      print("Error fetching employees: $e");
    }
  }

  @override
  void initState() {
    super.initState();
     transferdata();
    readReportJson();
   
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        menuItems: widget.resultMenu,
         title: "Reports",
        showProfile: true,
        // showProfile: true,
        // // onProfileTap: () {
        // //   print('Profile tapped!');

        // },
     
       ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: leaveData.isEmpty || dailyLogEntryData.isEmpty || employeesById == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Employee Pie Chart
                    Text(
                      "Employee Report: ${employeesById?['empId'] ?? 'Unknown'}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    // 🎨 Color Explanation for Employee Pie Chart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LegendIndicator(color: Colors.blue, text: "Leave"),
                        SizedBox(width: 10),
                        LegendIndicator(color: Colors.green, text: "Days Present"),
                        SizedBox(width: 10),
                        LegendIndicator(color: Colors.orange, text: "Holidays"),
                      ],
                    ),
                    SizedBox(height: 300, child: EmployeePieChart(employeesById!)),

                    SizedBox(height: 20),

                    // Leave GroupBarChart
                    Text(
                      "Leave Report",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                     SizedBox(height: 5),

                  // 🎨 Color Explanation for Leave Chart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LegendIndicator(color: Colors.blue, text: "Leave Taken"),
                      SizedBox(width: 10),
                      LegendIndicator(color: Colors.green, text: "Days Present"),
                      SizedBox(width: 10),
                      LegendIndicator(color: Colors.orange, text: "Holidays"),
                    ],
                  ),
                    SizedBox(height: 300, child: LeaveBarChart(leaveData)),

                    SizedBox(height: 20),

                    // Daily Log GroupBarChart
                    Text(
                      "Daily Log Report",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                  // 🎨 Color Explanation for Daily Log Chart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LegendIndicator(color: Colors.purple, text: "Daily Log Entries"),
                      SizedBox(width: 10),
                      LegendIndicator(color: Colors.red, text: "Missed Days"),
                    ],
                  ),
                    SizedBox(height: 300, child: DailyLogBarChart(dailyLogEntryData)),
                  ],
                ),
              ),
      ),
    );
  }
}


// PieChart  employeeId Leave Report Chart (Leave Taken, Days Present, Holidays)

class EmployeePieChart extends StatelessWidget {
  final Map<String, dynamic> employeeData;

  EmployeePieChart(this.employeeData);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: (employeeData["leave"] ?? 0).toDouble(),
            color: Colors.blue,
            // title: 'Leave (${employeeData["leave"]})',
            radius: 50,
            titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            value: (employeeData["daysPresent"] ?? 0).toDouble(),
            color: Colors.green,
            // title: 'Days Present (${employeeData["daysPresent"]})',
            radius: 50,
            titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            value: (employeeData["holiday"] ?? 0).toDouble(),
            color: Colors.orange,
            // title: 'Holidays (${employeeData["holiday"]})',
            radius: 50,
            titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
        borderData: FlBorderData(show: false),
        sectionsSpace: 4, // Space between sections
        centerSpaceRadius: 30, // Empty space in the center
      ),
    );
  }
}

// 📊 GroupBarChart Leave Report Chart (Leave Taken, Days Present, Holidays)
// class LeaveBarChart extends StatelessWidget {
//   final List<dynamic> leaveData;

//   LeaveBarChart(this.leaveData);

//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         barGroups: leaveData.asMap().entries.map((entry) {
//           int index = entry.key;
//           var data = entry.value;

//           return BarChartGroupData(
//             x: index,
//             barRods: [
//               BarChartRodData(
//                 toY: (data["leave"] ?? 0).toDouble(),
//                 color: Colors.blue, // Leave Taken
//                 width: 10,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               BarChartRodData(
//                 toY: (data["daysPresent"] ?? 0).toDouble(),
//                 color: Colors.green, // Days Present
//                 width: 10,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               BarChartRodData(
//                 toY: (data["holiday"] ?? 0).toDouble(),
//                 color: Colors.orange, // Holidays
//                 width: 10,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             ],
//           );
//         }).toList(),
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(showTitles: true,
//           reservedSize: 40,
//           )),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 int index = value.toInt();
//                 if (index >= 0 && index < leaveData.length) {
//                   return Text(leaveData[index]["empId"].toString() ?? "Unknown", style: TextStyle(fontSize: 10));
//                 }
//                 return Text('');
//               },
//                reservedSize: 40,
//             ),
//           ),
//         ),
//         borderData: FlBorderData(show: false),
//         gridData: FlGridData(show: true),
//       ),
//     );
//   }
// }
class LeaveBarChart extends StatelessWidget {
  final List<dynamic> leaveData;

  LeaveBarChart(this.leaveData);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Add scrolling
      scrollDirection: Axis.horizontal, // Allow horizontal scrolling
      child: SizedBox(
        width: leaveData.length * 50, // Adjust width dynamically based on the number of bars
        height: 300, // Fixed height
        child: BarChart(
          BarChartData(
            barGroups: leaveData.asMap().entries.map((entry) {
              int index = entry.key;
              var data = entry.value;

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: (data["leave"] ?? 0).toDouble(),
                    color: Colors.blue, // Leave Taken
                    width: 10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  BarChartRodData(
                    toY: (data["daysPresent"] ?? 0).toDouble(),
                    color: Colors.green, // Days Present
                    width: 10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  BarChartRodData(
                    toY: (data["holiday"] ?? 0).toDouble(),
                    color: Colors.orange, // Holidays
                    width: 10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < leaveData.length) {
                      return Text(
                        leaveData[index]["empId"].toString() ?? "Unknown",
                        style: TextStyle(fontSize: 10),
                      );
                    }
                    return Text('');
                  },
                  reservedSize: 40,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: true),
          ),
        ),
      ),
    );
  }
}

// 📊 GroupBarChart Daily Log Chart (Daily Log Entries, Missed Days)
class DailyLogBarChart extends StatelessWidget {
  final List<dynamic> dailyLogEntryData;

  DailyLogBarChart(this.dailyLogEntryData);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: dailyLogEntryData.asMap().entries.map((entry) {
          int index = entry.key;
          var data = entry.value;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data["dailyLogEntry"].toDouble(),
                color: Colors.purple, // Daily Log Entries
                width: 10,
                borderRadius: BorderRadius.circular(4),
              ),
              BarChartRodData(
                toY: data["missedDays"].toDouble(),
                color: Colors.red, // Missed Days
                width: 10,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,
           reservedSize: 40,
          )),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < dailyLogEntryData.length) {
                  return Text(dailyLogEntryData[index]["name"]?? "Unknown", style: TextStyle(fontSize: 10));
                }
                return Text('');
              },
               reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
      ),
    );
  }
}

class LegendIndicator extends StatelessWidget {
  final Color color;
  final String text;

  LegendIndicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}