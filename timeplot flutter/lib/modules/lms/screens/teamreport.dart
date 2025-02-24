import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:focusontime/screens/logo_loader.dart';

class TeamReport extends StatefulWidget {
  // const TeamReport({super.key});
  final List<Map<String, dynamic>> resultMenu;

  const TeamReport({super.key, required this.resultMenu});

  @override
  State<TeamReport> createState() => _TeamReportState();
}

class _TeamReportState extends State<TeamReport> {
  List<dynamic> leaveData = [];
  List<dynamic> dailyLogEntryData = [];
  bool _isLoading = true;

  Future<void> readReportJson() async {
    setState(() {
      _isLoading = true; // ✅ Start loading
    });
    final String response = await rootBundle.loadString('jsonfile/db.json');
    final Map<String, dynamic> data = json.decode(response);
    if (mounted) {
      setState(() {
        leaveData = data["leave"] ?? [];
        dailyLogEntryData = data["dailyLogEntry"] ?? [];
        _isLoading = false;
      });
    }

    print("leaveData: $leaveData");
    print("dailyLogEntryData: $dailyLogEntryData");
    if (mounted) {
      setState(() {
        _isLoading = false; // ✅ Stop loading even if there is an error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    readReportJson();
  }

  Future<void> _loadData() async {
  if (mounted) {
    setState(() {
      _isLoading = true; // ✅ Ensure UI updates before loading starts
    });
  }

  await Future.delayed(Duration(seconds: 2)); // Simulate API call
  await readReportJson(); // ✅ Fetch actual data

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
      leaveData.clear(); // ✅ Clear old data before reloading
      dailyLogEntryData.clear();
    });
  }

  await readReportJson(); // ✅ Fetch fresh data

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
        child: _isLoading
            ? Center(
                child: LogoLoader(size: 80.0),
              )
            // ignore: unnecessary_null_comparison
            : (leaveData == null || dailyLogEntryData == null) // ✅ Fixed condition
                ?  Center(child: LogoLoader(size: 80.0))
                : (leaveData!.isEmpty && dailyLogEntryData!.isEmpty)
                ? Center(child: Text("No data available"))
                : SingleChildScrollView(
                   physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Leave Report
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            "Leave Report",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),

                        // 🎨 Color Explanation for Leave Chart
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LegendIndicator(
                                color: Colors.blue, text: "Leave Taken"),
                            SizedBox(width: 10),
                            LegendIndicator(
                                color: Colors.green, text: "Days Present"),
                            SizedBox(width: 10),
                            LegendIndicator(
                                color: Colors.orange, text: "Holidays"),
                          ],
                        ),
                        SizedBox(height: 300, child: LeaveBarChart(leaveData)),

                        SizedBox(height: 20),

                        // Daily Log Report
                        Text(
                          "Daily Log Report",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),

                        // 🎨 Color Explanation for Daily Log Chart
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LegendIndicator(
                                color: Colors.purple,
                                text: "Daily Log Entries"),
                            SizedBox(width: 10),
                            LegendIndicator(
                                color: Colors.red, text: "Missed Days"),
                          ],
                        ),
                        SizedBox(
                            height: 300,
                            child: DailyLogBarChart(dailyLogEntryData)),
                      ],
                    ),
                  ),
      ),
    );
  }
}

//  📊 GroupBarChart Leave Report Chart (Leave Taken, Days Present, Holidays)
class LeaveBarChart extends StatelessWidget {
  final List<dynamic> leaveData;

  LeaveBarChart(this.leaveData);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Add scrolling
      scrollDirection: Axis.horizontal, // Allow horizontal scrolling
      child: SizedBox(
        width: leaveData.length *
            50, // Adjust width dynamically based on the number of bars
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
          leftTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
          )),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < dailyLogEntryData.length) {
                  return Text(dailyLogEntryData[index]["name"] ?? "Unknown",
                      style: TextStyle(fontSize: 10));
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
