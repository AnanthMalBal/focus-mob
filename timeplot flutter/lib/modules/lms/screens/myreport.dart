import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:focusontime/screens/colors.dart';
import 'package:focusontime/screens/logo_loader.dart';
import 'package:focusontime/services/reportservice.dart';
import 'package:focusontime/services/sharedpreferences.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final shareddata = SharedPref();
SharedPreferences? prefs;

class MyReport extends StatefulWidget {
  final List<Map<String, dynamic>> resultMenu;

  const MyReport({super.key, required this.resultMenu});

  @override
  State<MyReport> createState() => _MyReportState();
}

class _MyReportState extends State<MyReport> {
  Map<String, dynamic>? employeesById;
  final ReportService reportservice = ReportService();
  String? empId;
  bool _isLoading = true;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    transferdata();
  }

  void transferdata() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    final empData = await shareddata.getpatdata();
    setState(() {
      empId = empData.userId;
      print("idreport: " + empId.toString());
    });
    fetchEmployeesById(empId);
    setState(() {
      _isLoading = false; // Stop loading after fetching data
    });
  }

// method fetch from api by employeeId
  Future<void> fetchEmployeesById(String? empId) async {
    if (empId == null) return;
    print("Fetching report for empId: $empId");

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

  // for datepicker
  Future<void> _pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        _isLoading = true; // Show loading when fetching new data
      });
      print("startDate:$startDate, endDate:$endDate");
       if (empId != null) {
      await fetchEmployeesById(empId!); // ✅ Wait until data is fetched
    }
    setState(() {
      _isLoading = false; // ✅ Stop loading after fetching data
    });
    }
  }




// for loader
  Future<void> _loadData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate API call
    if (mounted) {
      setState(() {
        _isLoading = false; // Data loaded
      });
    }
  }

  Future<void> _refreshData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          menuItems: widget.resultMenu,
          title: "MyReport",
          showProfile: true,
          // showProfile: true,
          // // onProfileTap: () {
          // //   print('Profile tapped!');

          // },
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: _isLoading
              ? Center(
                  // ✅ Ensures the loader is centered on the entire screen
                  child: LogoLoader(
                    size: 80.0, // Customize size
                  ),
                )
              : SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: _isLoading
                      ? LogoLoader(size: 80.0)
                      : employeesById == null
                          ? Center(
                              child: Center(
                              child: LogoLoader(
                                size: 100.0, // Customize size
                              ),
                            ))
                          // Text("No data available"))
                          : Column(children: [
                              // Date Range Picker Button (Aligned to Right)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .end, // ✅ Aligns button to the right
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => _pickDateRange(context),
                                      icon: const Icon(Icons.date_range),
                                      label: const Text("Pick Date Range"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // for piechart
                              Container(
                                //  height: MediaQuery.of(context).size.height, // ✅ Make it full screen
                                padding: EdgeInsets.only(
                                    top: 50), // ✅ Added space at the top
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // ✅ Centers content vertically
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, // ✅ Centers content horizontally
                                    children: [
                                      // Employee Pie Chart
                                      Text(
                                        "Employee Report: ${employeesById?['empId'] ?? 'Unknown'}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      // 🎨 Color Explanation for Employee Pie Chart
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          LegendIndicator(
                                              color: Colors.blue,
                                              text: "Leave"),
                                          SizedBox(width: 10),
                                          LegendIndicator(
                                              color: Colors.green,
                                              text: "Days Present"),
                                          SizedBox(width: 10),
                                          LegendIndicator(
                                              color: Colors.orange,
                                              text: "Holidays"),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      SizedBox(
                                          height: 300,
                                          child:
                                              EmployeePieChart(employeesById!)),
                                    ]),
                              )
                            ])),
        ));
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
            titleStyle: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            value: (employeeData["daysPresent"] ?? 0).toDouble(),
            color: Colors.green,
            // title: 'Days Present (${employeeData["daysPresent"]})',
            radius: 50,
            titleStyle: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            value: (employeeData["holiday"] ?? 0).toDouble(),
            color: Colors.orange,
            // title: 'Holidays (${employeeData["holiday"]})',
            radius: 50,
            titleStyle: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
        borderData: FlBorderData(show: false),
        sectionsSpace: 4, // Space between sections
        centerSpaceRadius: 30, // Empty space in the center
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
