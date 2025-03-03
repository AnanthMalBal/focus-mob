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
  List<Map<String, dynamic>> myLeaveReport=[];
  List<Map<String, dynamic>> myDailyLogReport=[];
  final ReportService reportservice = ReportService();
  String? empId;
  bool _isLoading = true;
  DateTime? startDate;
  DateTime? endDate;
  List<String>?  roles;
  String employee ="";
  String? empType ;

  @override
  void initState() {
    super.initState();
    
    transferdata();
  }



// fetch Data from local sharedpreferences
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

    String employee = (roles != null && roles!.length > 1) ? roles![0] : "";

    print("Employee: $employee");

    empType = (employee == "Employee") ? "emp" : (employee.isNotEmpty ? employee : "Default");

    print("empType: $empType");
    main();
  });

  setState(() {
    _isLoading = false;
  });
}

// method fetch from api by employeeId
  // Future<void> fetchEmployeesById(String? empId) async {
  //   if (empId == null) return;
  //   print("Fetching report for empId: $empId");

  //   try {
  //     Map<String, dynamic>? data = await reportservice.fetchReportById(empId);
  //     setState(() {
  //       employeesById = data;
  //     });
  //     print("employeesById: $employeesById");
  //   } catch (e) {
  //     print("Error fetching employees: $e");
  //   }
  // }
// method for currentDate and 1week from currentDate
Future<void> main() async {
  DateTime currentDate = DateTime.now();
  DateTime oneWeekLater = currentDate.add(Duration(days: 7));

  String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
  String formattedOneWeekLater = DateFormat('yyyy-MM-dd').format(oneWeekLater);
   await fetchMyReport(empType, formattedCurrentDate, formattedOneWeekLater);

  print("Current Date: $formattedCurrentDate");
  print("One Week Later: $formattedOneWeekLater");
}

//  method to fetch from api
  Future<void> fetchMyReport(String? empType,String? startDate, String? endDate) async {
   print("date:$empType,$startDate,$endDate");
  List<Map<String, dynamic>> employees = await reportservice.myLeaveReport(empType,startDate,endDate);
  List<Map<String, dynamic>> employeesDailyLog = await reportservice.myDailyLogReport(empType,startDate,endDate);
   setState(() {
    myLeaveReport = employees; // Store data in state
    myDailyLogReport = employeesDailyLog;
  });
 print("✅ Employee Report Fetched: ${myLeaveReport} records");
 print("✅ Employee Report Fetched: ${myDailyLogReport} records");
  }


// method for date picker

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

    print("Formatted startDate: $formattedStartDate, Formatted endDate: $formattedEndDate");

    await fetchMyReport(empType, formattedStartDate, formattedEndDate);
   
  } catch (e) {
    print("ERROR: $e");
  }

  setState(() {
    // _isLoading = false;
  });
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
    //     myLeaveReport.clear();
    // myDailyLogReport.clear();
      });
    }
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        menuItems: widget.resultMenu,
        title: 'MyReport',
        showProfile: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData, 
       
        child: _isLoading
              ? Center(
                  child: LogoLoader(size: 80.0), // ✅ Your custom loading widget
                )
              :
        SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // datePicker
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickDateRange(context),
                      icon: const Icon(Icons.date_range),
                      label: const Text("Pick Date Range"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    ),
                  ],
                ),
              ),
              /// ✅ Show Loader while Data is Loading
          // _isLoading
          //     ? Center(
          //         child: LogoLoader(size: 80.0), // ✅ Your custom loading widget
          //       )
          //     :
              myLeaveReport.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Text(
                            "Employee Attendance Report: ${myLeaveReport[0]['empId'] ?? 'Unknown'}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          // ✅ Legend Indicators Below Pie Chart
                           Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LegendIndicator(color: Colors.blue, text: "Leave"),
                              SizedBox(width: 10),
                              LegendIndicator(color: Colors.green, text: "Present Days"),
                              SizedBox(width: 10),
                              LegendIndicator(color: Colors.orange, text: "Holidays"),
                            ],
                          ),
                          SizedBox(height: 10),
                          PieChartWidget(myLeaveReport),
                          SizedBox(height: 10),
                          Text(
                            "Employee Daily Log Report: ${myLeaveReport[0]['empId'] ?? 'Unknown'}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                           DailyLogPieChart(myDailyLogReport),
                          
                        ],
                      ),
                    )
                  : Text("No employee data found.", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

// PieChart  employeeId Leave Report Chart (Leave Taken, Days Present, Holidays)

// class EmployeePieChart extends StatelessWidget {
//   final Map<String, dynamic> employeeData;

//   EmployeePieChart(this.employeeData);

//   @override
//   Widget build(BuildContext context) {
//     return PieChart(
//       PieChartData(
//         sections: [
//           PieChartSectionData(
//             value: (employeeData["leave"] ?? 0).toDouble(),
//             color: Colors.blue,
//             // title: 'Leave (${employeeData["leave"]})',
//             radius: 50,
//             titleStyle: TextStyle(
//                 fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           PieChartSectionData(
//             value: (employeeData["daysPresent"] ?? 0).toDouble(),
//             color: Colors.green,
//             // title: 'Days Present (${employeeData["daysPresent"]})',
//             radius: 50,
//             titleStyle: TextStyle(
//                 fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           PieChartSectionData(
//             value: (employeeData["holiday"] ?? 0).toDouble(),
//             color: Colors.orange,
//             // title: 'Holidays (${employeeData["holiday"]})',
//             radius: 50,
//             titleStyle: TextStyle(
//                 fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ],
//         borderData: FlBorderData(show: false),
//         sectionsSpace: 4, // Space between sections
//         centerSpaceRadius: 30, // Empty space in the center
//       ),
//     );
//   }
// }

// ✅ Pie Chart Widget for Leave
class PieChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> employees;

  PieChartWidget(this.employees);

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) {
      return Center(child: Text("No data available"));
    }

    var empData = employees[0];
    int leaveDays = empData['leaveDays'] ?? 0;
    int presentDays = empData['presentDays'] ?? 0;
    int holidays = empData['holiday'] ?? 0;

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: leaveDays.toDouble(),
              color: Colors.blue,
              title: '$leaveDays',
              titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              value: presentDays.toDouble(),
              color: Colors.green,
              title: '$presentDays',
              titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              value: holidays.toDouble(),
              color: Colors.orange,
              title: '$holidays',
              titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
          sectionsSpace: 2, // Spacing between sections
          centerSpaceRadius: 40, // Adjust to fit labels inside
        ),
      ),
    );
  }
}

// // ✅ Legend Indicator Widget for Leave
class LegendIndicator extends StatelessWidget {
  final Color color;
  final String text;

  const LegendIndicator({Key? key, required this.color, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}

// ✅ Pie Chart Widget for DailyLog
class DailyLogPieChart extends StatelessWidget {
  final List<Map<String, dynamic>> myDailyLogReport;

  DailyLogPieChart(this.myDailyLogReport);

  @override
  Widget build(BuildContext context) {
    if (myDailyLogReport.isEmpty) {
      return Center(child: Text("No Data Available"));
    }

    /// Get First Employee Data (If list has multiple employees, you can loop)
    final employeeData = myDailyLogReport[0];

    int leaveDays = employeeData['leaveDays'] ?? 0;
    int presentDays = employeeData['presentDays'] ?? 0;
    int holidays = employeeData['holiday'] ?? 0;
    int missedDays = employeeData['missedDays'] ?? 0;
    int dailyLogEntry = employeeData['dailylogEntry'] ?? 0;

    return Column(
      children: [
        /// **Legend for the Pie Chart (Two Rows)**
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LegendIndicator(color: Colors.blue, text: "Leave"),
                  SizedBox(width: 10),
                  LegendIndicator(color: Colors.green, text: "Present"),
                  SizedBox(width: 10),
                  LegendIndicator(color: Colors.orange, text: "Holidays"),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LegendIndicator(color: Colors.red, text: "Missed Days"),
                  SizedBox(width: 10),
                  LegendIndicator(color: Colors.purple, text: "Daily Log"),
                ],
              ),
            ],
          ),
        ),

        /// **Pie Chart**
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: leaveDays.toDouble(),
                  color: Colors.blue,
                  title: '$leaveDays',
                  titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                PieChartSectionData(
                  value: presentDays.toDouble(),
                  color: Colors.green,
                  title: '$presentDays',
                  titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                PieChartSectionData(
                  value: holidays.toDouble(),
                  color: Colors.orange,
                  title: '$holidays',
                  titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                PieChartSectionData(
                  value: missedDays.toDouble(),
                  color: Colors.red,
                  title: '$missedDays',
                  titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                PieChartSectionData(
                  value: dailyLogEntry.toDouble(),
                  color: Colors.purple,
                  title: '$dailyLogEntry',
                  titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ],
    );
  }
}



/// **Legend Indicator Widget** for DailyLog
class LegendIndicatorDailyLog extends StatelessWidget {
  final Color color;
  final String text;

  LegendIndicatorDailyLog({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}