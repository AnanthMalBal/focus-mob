import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:focusontime/screens/logo_loader.dart';
import 'package:focusontime/services/reportservice.dart';
import 'package:focusontime/services/sharedpreferences.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final shareddata = SharedPref();
SharedPreferences? prefs;

class TeamReport extends StatefulWidget {
  // const TeamReport({super.key});
  final List<Map<String, dynamic>> resultMenu;

  const TeamReport({super.key, required this.resultMenu});

  @override
  State<TeamReport> createState() => _TeamReportState();
}

class _TeamReportState extends State<TeamReport> {
  List<Map<String, dynamic>> teamLeaveData = [];
  List<Map<String, dynamic>> teamDailyLogData = [];
  final ReportService reportservice = ReportService();
  bool _isLoading = true;
  DateTime? startDate;
  DateTime? endDate;
  String? empType;
  String? empId;
  List<String>? roles;

  // Future<void> readReportJson() async {
  //   setState(() {
  //     _isLoading = true; // ✅ Start loading
  //   });
  //   final String response = await rootBundle.loadString('jsonfile/db.json');
  //   final Map<String, dynamic> data = json.decode(response);
  //   if (mounted) {
  //     setState(() {
  //       leaveData = data["leave"] ?? [];
  //       dailyLogEntryData = data["dailyLogEntry"] ?? [];
  //       _isLoading = false;
  //     });
  //   }

  //   print("leaveData: $leaveData");
  //   print("dailyLogEntryData: $dailyLogEntryData");
  //   if (mounted) {
  //     setState(() {
  //       _isLoading = false; // ✅ Stop loading even if there is an error
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    transferdata();
    // readReportJson();
  }

  // fetch Data from local sharedpreferences
// void transferdata() async {
//   setState(() {
//     _isLoading = true; // Start loading
//   });

//   final empData = await shareddata.getpatdata();

//   setState(() {
//     empId = empData.userId;
//     roles = empData.roles; // ✅ Assign roles as List<String> (Not as a String!)

//     print("idreport: $empId");
//     print("idreportroles: $roles");

//     // ✅ Extract "Employee" safely
//     String employee = (roles != null && roles!.isNotEmpty) ? roles![1] : "";

//     print("Employee: $employee");

//     // ✅ Store "emp" if employee is "Employee"
//      empType = (employee == "Admin") ? "Admin" : employee;

//     print("empType: $empType");
//   });

//   // fetchEmployeesById(empId);

//   setState(() {
//     _isLoading = false; // Stop loading after fetching data
//   });
// }

  void transferdata() async {
    setState(() {
      _isLoading = true;
    });

    final empData = await shareddata.getpatdata();

    setState(() {
      empId = empData.userId;
      roles = empData.roles;

      print("idreport: $empId");
      print("idreportroles: $roles");

      String employee = (roles != null && roles!.length > 1) ? roles![1] : "";

      print("Employee: $employee");

      // empType = (employee == "Admin") ? "Admin" : (employee.isNotEmpty ? employee : "Default");
      if (employee == "Admin") {
        empType = "Admin";
      } else if (employee == "TeamLader") {
        // Fix the typo from "TeamLader" to "TeamLeader" if needed
        empType = "teamLead"; // Convert TeamLader to teamLead
      } else {
        empType = employee.isNotEmpty ? employee : "Default";
      }

      print("empType: $empType");

      print("empType: $empType");
    });

    setState(() {
      _isLoading = false;
    });
  }

//  method to fetch from api
  Future<void> fetchTeamReport(
      String? empType, String? startDate, String? endDate) async {
    print("date:$empType,$startDate,$endDate");
    List<Map<String, dynamic>> teamLeave =
        await reportservice.myLeaveReport(empType, startDate, endDate);
    List<Map<String, dynamic>> teamDailyLog =
        await reportservice.myDailyLogReport(empType, startDate, endDate);
    setState(() {
      teamLeaveData = teamLeave; // Store data in state
      teamDailyLogData = teamDailyLog;
    });
    print(
        "✅ Employee Report Fetched: ${teamLeaveData}, ${teamLeaveData} records");
    print("✅ Employee Daily Report Fetched:  ${teamLeaveData} records");
  }

// datepicker method
  Future<void> _pickDateRange(BuildContext context) async {
    print("DEBUG: _pickDateRange() called");

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (picked == null) {
      print("DEBUG: No date range was selected.");
      return;
    }

    setState(() {
      startDate = picked.start;
      endDate = picked.end;
      // _isLoading = true;
    });

    print("DEBUG: Dates selected - startDate: $startDate, endDate: $endDate");

    try {
      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate!);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate!);

      print(
          "Formatted startDate: $formattedStartDate, Formatted endDate: $formattedEndDate");

      await fetchTeamReport(empType, formattedStartDate, formattedEndDate);
    } catch (e) {
      print("ERROR: $e");
    }

    setState(() {
      // _isLoading = false;
    });
  }

  Future<void> _loadData() async {
    if (mounted) {
      setState(() {
        _isLoading = true; // ✅ Ensure UI updates before loading starts
      });
    }

    await Future.delayed(Duration(seconds: 2)); // Simulate API call
    

    if (mounted) {
      setState(() {
        _isLoading = false; // ✅ Hide loader after loading
      });
    }
  }

  Future<void> _refreshData() async {
    if (mounted) {
      setState(() {
        _isLoading = true; // ✅ Ensure UI updates before refresh
        teamLeaveData.clear(); // ✅ Clear old data before reloading
        teamDailyLogData.clear();
      });
    }

  

    if (mounted) {
      setState(() {
        _isLoading = false; // ✅ Hide loader after refresh
      });
    }
  }

  @override
  Widget build(BuildContext context) {  

    return Scaffold(
      appBar: CommonAppBar(
        menuItems: widget.resultMenu,
        title: "Team Report",
        showProfile: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // 📅 Date Picker
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickDateRange(context),
                      icon: const Icon(Icons.date_range),
                      label: const Text("Pick Date Range"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                    ),
                  ],
                ),
              ),

              // 📊 Leave Report
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Leave Report",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (teamLeaveData.isNotEmpty) ...[
                SizedBox(height: 10),
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
                SizedBox(height: 300, child: TeamLeaveBarChart(teamLeaveData)),
              ] else ...[
                SizedBox(height: 10),
                Text(
                  "No employee data found.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],

              SizedBox(height: 20),

              // 📊 Daily Log Report
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Daily Log Report",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (teamDailyLogData.isNotEmpty) ...[
                SizedBox(height: 10),

                // 🎨 Color Explanation for Daily Log Chart
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LegendIndicator(
                            color: Colors.blue, text: "Leave Taken"),
                        SizedBox(width: 5),
                        LegendIndicator(
                            color: Colors.green, text: "Days Present"),
                        SizedBox(width: 5),
                        LegendIndicator(color: Colors.orange, text: "Holidays"),
                      ],
                    ),
                    SizedBox(height: 5), // Space between rows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LegendIndicator(
                            color: Colors.purple, text: "Daily Log Entries"),
                        SizedBox(width: 5),
                        LegendIndicator(color: Colors.red, text: "Missed Days"),
                      ],
                    ),
                  ],
                ),

                SizedBox(
                    height: 300, child: TeamDailyLogBarChart(teamDailyLogData)),
              ] else ...[
                SizedBox(height: 10),
                Text(
                  "No employee data found.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

//  📊 GroupBarChart Leave Report Chart (Leave Taken, Days Present, Holidays)
class TeamLeaveBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> teamLeaveData;

  TeamLeaveBarChart(this.teamLeaveData);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: SizedBox(
        width: teamLeaveData.length * 100, // Adjust width dynamically
        height: 300,
        child: BarChart(
          BarChartData(
            maxY: 60, // Adjust based on your max values
            barGroups: teamLeaveData.asMap().entries.map((entry) {
              int index = entry.key;
              var data = entry.value;

              print("Employee: ${data["userName"]}, Leave Days: ${data["leaveDays"]}"); // Debugging

              return BarChartGroupData(
                x: index, // Ensure x-axis values are unique
                barRods: [
                  BarChartRodData(
                    // Hidden base bar to ensure group is always drawn
                    toY: 0.1,
                    color: Colors.transparent,
                    width: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  BarChartRodData(
                    toY: (data["leaveDays"] ?? 0).toDouble(),
                    color: Colors.blue, // Leave Days
                    width: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  BarChartRodData(
                    toY: (data["presentDays"] ?? 0).toDouble(),
                    color: Colors.green, // Present Days
                    width: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  BarChartRodData(
                    toY: (data["holiday"] ?? 0).toDouble(),
                    color: Colors.orange, // Holidays
                    width: 12,
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
                    if (index >= 0 && index < teamLeaveData.length) {
                      return Text(
                        teamLeaveData[index]["userName"] ?? "Unknown",
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
// class TeamLeaveBarChart extends StatelessWidget {
//   final List<Map<String, dynamic>> teamLeaveData;

//   TeamLeaveBarChart(this.teamLeaveData);

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal, // Enable horizontal scrolling
//       child: SizedBox(
//         width: teamLeaveData.length * 100, // Adjust width dynamically
//         height: 300,
//         child: BarChart(
//           BarChartData(
//             maxY: 60,
//             barGroups: teamLeaveData.asMap().entries.map((entry) {
//               int index = entry.key;
//               var data = entry.value;

//               return BarChartGroupData(
//                 x: index,
//                 barRods: [
//                   BarChartRodData(
//                     toY: (data["leaveDays"] ?? 0).toDouble(),
//                     color: Colors.blue, // Leave Days
//                     width: 12,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   BarChartRodData(
//                     toY: (data["presentDays"] ?? 0).toDouble(),
//                     color: Colors.green, // Present Days
//                     width: 12,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   BarChartRodData(
//                     toY: (data["holiday"] ?? 0).toDouble(),
//                     color: Colors.orange, // Holidays
//                     width: 12,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ],
//               );
//             }).toList(),
//             titlesData: FlTitlesData(
//               leftTitles: AxisTitles(
//                 sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//               ),
//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget: (value, meta) {
//                     int index = value.toInt();
//                     if (index >= 0 && index < teamLeaveData.length) {
//                       return Text(
//                         teamLeaveData[index]["userName"] ?? "Unknown",
//                         style: TextStyle(fontSize: 10),
//                       );
//                     }
//                     return Text('');
//                   },
//                   reservedSize: 40,
//                 ),
//               ),
//             ),
//             borderData: FlBorderData(show: false),
//             gridData: FlGridData(show: true),
//           ),
//         ),
//       ),
//     );
//   }
// }

// 📊 GroupBarChart Daily Log Chart (Daily Log Entries, Missed Days)

class TeamDailyLogBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> teamDailyLogData;

  TeamDailyLogBarChart(this.teamDailyLogData);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: SizedBox(
        width: teamDailyLogData.length * 100, // Adjust width dynamically
        height: 300, // Increased height for better visibility
        child: BarChart(
          BarChartData(
            maxY: 60, // Adjust based on your max values
            barGroups: teamDailyLogData.asMap().entries.map((entry) {
              int index = entry.key;
              var data = entry.value;

              print(
                  "Employee: ${data["userName"]}, Leave Days: ${data["leaveDays"]}"); // Debugging

              return BarChartGroupData(
                x: index, // Ensure x-axis values are unique
                barRods: [
                  BarChartRodData(
                    // Hidden base bar to ensure group is always drawn
                    toY: 0.1,
                    color: Colors.transparent,
                    width: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                    if ((data["leaveDays"] ?? 0) > 0)
                  BarChartRodData(
                    toY: data["leaveDays"].toDouble(),
                    color: Colors.blue,
                    width: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  // if ((data["dailylogEntry"] ?? 0) > 0)
                  BarChartRodData(
                    toY: data["dailylogEntry"].toDouble(),
                    color: Colors.purple,
                    width: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  // if ((data["missedDays"] ?? 0) > 0)
                  BarChartRodData(
                    toY: data["missedDays"].toDouble(),
                    color: Colors.red,
                    width: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),

                  // if ((data["presentDays"] ?? 0) > 0)
                  BarChartRodData(
                    toY: data["presentDays"].toDouble(),
                    color: Colors.green,
                    width: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  // if ((data["holiday"] ?? 0) > 0)
                  BarChartRodData(
                    toY: data["holiday"].toDouble(),
                    color: Colors.orange,
                    width: 12,
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
                    if (index >= 0 && index < teamDailyLogData.length) {
                      return Text(
                        teamDailyLogData[index]["userName"] ?? "Unknown",
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
