import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:fl_chart/fl_chart.dart';

class Reportscreen extends StatefulWidget {
  // const Reportscreen({super.key});
  final List<Map<String, dynamic>> resultMenu;

  const Reportscreen({super.key, required this.resultMenu}); 

  @override
  State<Reportscreen> createState() => _ReportscreenState();
}



// class _ReportscreenState extends State<Reportscreen> {
//   List<dynamic> leaveData = [];
//   List<dynamic> dailyLogEntryData = [];

//   Future<void> readReportJson() async {
//     final String response = await rootBundle.loadString('jsonfile/db.json');
//     final Map<String, dynamic> data = json.decode(response);

//     setState(() {
//       leaveData = data["leave"] ?? [];
//       dailyLogEntryData = data["dailyLogEntry"] ?? [];
//     });

//     print("leaveData: $leaveData");
//     print("dailyLogEntryData: $dailyLogEntryData");
//   }

//   @override
//   void initState() {
//     super.initState();
//     readReportJson();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:  CommonAppBar(
//         menuItems: widget.resultMenu,
//          title: "Reports",
//         showProfile: true,
//         // showProfile: true,
//         // // onProfileTap: () {
//         // //   print('Profile tapped!');

//         // },
     
//        ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Text("Leave Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               leaveData.isEmpty
//                   ? CircularProgressIndicator()
//                   : SizedBox(height: 300, child: BarChartWidget(leaveData, "leave")),
//               SizedBox(height: 20),
//               Text("Daily Log Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               dailyLogEntryData.isEmpty
//                   ? CircularProgressIndicator()
//                   : SizedBox(height: 300, child: BarChartWidget(dailyLogEntryData, "dailyLogEntry")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BarChartWidget extends StatelessWidget {
//   final List<dynamic> data;
//   final String dataType;

//   BarChartWidget(this.data, this.dataType);

//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         barGroups: data
//             .asMap()
//             .entries
//             .map(
//               (entry) => BarChartGroupData(
//                 x: entry.key,
//                 barRods: [
//                   BarChartRodData(
//                     toY: entry.value[dataType].toDouble(),
//                     color: Colors.blue,
//                     width: 16,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ],
//               ),
//             )
//             .toList(),
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 int index = value.toInt();
//                 if (index >= 0 && index < data.length) {
//                   return Text(data[index]["name"], style: TextStyle(fontSize: 12));
//                 }
//                 return Text('');
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _ReportscreenState extends State<Reportscreen> {
  List<dynamic> leaveData = [];
  List<dynamic> dailyLogEntryData = [];

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

  @override
  void initState() {
    super.initState();
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
        child: leaveData.isEmpty || dailyLogEntryData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Leave Chart
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

                    // Daily Log Chart
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

// 📊 Leave Report Chart (Leave Taken, Days Present, Holidays)
class LeaveBarChart extends StatelessWidget {
  final List<dynamic> leaveData;

  LeaveBarChart(this.leaveData);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: leaveData.asMap().entries.map((entry) {
          int index = entry.key;
          var data = entry.value;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data["leave"].toDouble(),
                color: Colors.blue, // Leave Taken
                width: 10,
                borderRadius: BorderRadius.circular(4),
              ),
              BarChartRodData(
                toY: data["daysPresent"].toDouble(),
                color: Colors.green, // Days Present
                width: 10,
                borderRadius: BorderRadius.circular(4),
              ),
              BarChartRodData(
                toY: data["holiday"].toDouble(),
                color: Colors.orange, // Holidays
                width: 10,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true,
          reservedSize: 40,
          )),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < leaveData.length) {
                  return Text(leaveData[index]["name"], style: TextStyle(fontSize: 10));
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

// 📊 Daily Log Chart (Daily Log Entries, Missed Days)
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
                  return Text(dailyLogEntryData[index]["name"], style: TextStyle(fontSize: 10));
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