import 'dart:async';
import 'package:flutter/material.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:focusontime/screens/colors.dart';
import 'package:focusontime/services/sharedpreferences.dart';
import 'package:focusontime/services/timesheetservice.dart';
import 'package:shared_preferences/shared_preferences.dart';


final shareddata = SharedPref();

enum SampleItem { itemOne, itemTwo, itemThree }

SharedPreferences? prefs;

class FillTimeSheet extends StatefulWidget {
  final DateTime date;
  // const FillTimeSheet({super.key, required this.date});
  final List<Map<String, dynamic>> resultMenu;

  FillTimeSheet({
    required this.date,
    required this.resultMenu,
  });

  @override
  State<FillTimeSheet> createState() => _FillTimeSheetState();
}

List<String> list = <String>['Select', 'Two', 'Three', 'Four'];
String dropdownValue = list.first;

class _FillTimeSheetState extends State<FillTimeSheet> {
  SampleItem? selectedMenu;
  final TimeSheetService timesheetservice = TimeSheetService();

  String? newProcessData;
  var newProjectData;
  var newTimesheetData;
  List<Map<String, dynamic>> _itemProject = [];
  var _itemProcess = [];
  List<Map<String, dynamic>>? _itemTimesheet;
  Map<String, dynamic> _itemTimeMarked = {};
  List<Map<String, dynamic>> _itemDailyLog = [];
  String? empId;
  var actualTimeController = TextEditingController();
  var descriptionController = TextEditingController();
  var billTypeController = TextEditingController();
  List<double> filledTimes = [];
  double totalTime = 0.0;
  double totalTime1 = 0;
  List<String> projectDataList = [];
  List<double> individualTotalTimes = [];
  String workingHours = '0';
  bool isAddButtonDisabled = false;
  bool isSubmitButtonDisabled = false;
  bool isSubmitButtonEnabled = false;

  String timesheetId = '';
  String tsDate = '';
  TimeOfDay? selectedTime;
  String actualTimeInMinutes = '';
  int? B = 0;
  int? NBNP = 0;
  int? NBP = 0;
  int totalNBNPMinutesInt = 0;
  int totalBMinutesInt = 0;
  int totalNBPMinutesInt = 0;
  int autoId = 0;
  var roles;
  String divisionId = "DEV";

  @override
  void initState() {
    // user = widget.date;
    String date = widget.date.toString().split(" ")[0];
    print("date" + date);
    super.initState();
    transferdata();
    getproject(divisionId);

    getTimesheet(date);
    getMarkedAttendance(date);
    //  getUsersDailyLog();
  }

  @override
  void dispose() {
    actualTimeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> getproject(String divisionId) async {
    print("projectid:" + divisionId);
    final resultProject =
        await timesheetservice.getProjectId(divisionId, context);
    print("data:" + resultProject.toString());
    for (var project in resultProject) {
      String projectId = project['projectId'];
      print("Calling getprocess with projectId: $projectId");

      // Call the getprocess function with the projectId
      getprocess(projectId);
    }
    setState(() {
      _itemProject = resultProject;
    });
    print("itemproject" + _itemProject.toString());
  }

  Future<void> getprocess(String projectId) async {
    print("processid:" + projectId);
    final resultProcess =
        await timesheetservice.getProcessId(projectId, context);
    print("data:" + resultProcess.toString());
    setState(() {
      _itemProcess = resultProcess;
    });
    print("itemProcess" + _itemProcess.toString());
  }

  Future<void> getTimesheet(String date) async {
    print("Timesheet");
    final resultTimesheet =
        await timesheetservice.fetchTimesheet(date, context);
    // widget.date.toString().split(" ")[0]
    print("receiveddata:" + resultTimesheet.toString());
    if (resultTimesheet != null && resultTimesheet.isNotEmpty) {
      setState(() {
        _itemTimesheet = resultTimesheet;
        timesheetId = _itemTimesheet![0]['timesheetId'];
        tsDate = _itemTimesheet![0]['_date'];
      });
      print("Extracted Timesheet ID: $timesheetId");

      // Call next function
      getUsersDailyLog();
    }
  }

  Future<void> getMarkedAttendance(String date) async {
    print("MarkedAttendance:"+date);
    final resultTimeMarked =
        await timesheetservice.fetchMarkedAttendance(date,context);
    print(" resultTimeMarked:" + resultTimeMarked.toString());
    setState(() {
      _itemTimeMarked = resultTimeMarked;
    });
    print("_itemTimeMarked: $_itemTimeMarked");
  }

  Future<void> getUsersDailyLog() async {
    print("DailyLog");

    final resultDailyLog =
        await timesheetservice.getDailyLog(timesheetId, context);
    // widget.date.toString().split(" ")[0]
    print("data:" + resultDailyLog.toString());

    if (resultDailyLog != null && resultDailyLog is List) {
      setState(() {
        _itemDailyLog = List<Map<String, dynamic>>.from(resultDailyLog);
      });
    } else {
      print("Invalid data received or empty response.");
    }

// Ensure _itemDailyLog is a list and iterate through it
    if (_itemDailyLog != null && _itemDailyLog is List) {
      // Initialize variables for B and NBP minutes
      double totalBMinutes = 0.0;
      double totalNBPMinutes = 0.0;
      double totalNBNPMinutes = 0.0;
      // Calculate total time in minutes and categorize into B and NBP
      totalTime = _itemDailyLog.fold(0.0, (sum, log) {
        double minutes = double.tryParse(log['actualTime'].toString()) ?? 0;

        // Categorize minutes based on billType
        if (log['billType'] == 'B') {
          totalBMinutes += minutes;
        } else if (log['billType'] == 'NBP') {
          totalNBPMinutes += minutes;
        } else {
          totalNBNPMinutes += minutes;
        }

        return sum + minutes; // Sum up total minutes
      });

      // Convert double values to int
      totalBMinutesInt = totalBMinutes.toInt();
      totalNBPMinutesInt = totalNBPMinutes.toInt();
      totalNBNPMinutesInt = totalNBNPMinutes.toInt();
      // Print the categorized minutes
      // Print the categorized minutes as integers
      print('Total B Minutes: $totalBMinutesInt');
      print('Total NBP Minutes: $totalNBPMinutesInt');
      print('Total NBNP Minutes: $totalNBNPMinutesInt');
      print('Total time calculated: ${totalTime.toInt()} minutes');
    }

    print("itemDailyLog" + _itemDailyLog.toString());
  }

  void transferdata() async {
    final empData = await shareddata.getpatdata();

    setState(() {
      empId = empData.userId;
      roles = empData.roles;
      print("id" + empId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_itemTimeMarked == null || _itemTimeMarked!.isEmpty) {
      return Center(child: CircularProgressIndicator()); // Show loading state
    }
    double? workingHoursDouble =
        double.tryParse(_itemTimeMarked!['workingHours']);
    double workingHoursInMinutes = (workingHoursDouble ?? 0) * 60;
    double width = 200;
    bool isAddButtonDisabled =
        workingHoursInMinutes > 0 && totalTime >= workingHoursInMinutes;
    bool isSubmitButtonEnabled = totalTime >= workingHoursInMinutes;

    return Scaffold(
        appBar: CommonAppBar(
          menuItems: widget.resultMenu,
          title: 'MyAttendance',

          showProfile: true,
          // onProfileTap: () {
          //   print('Profile tapped!');
          // },
        ),
        // drawer: buildDrawer(context),
        body: SingleChildScrollView(
            child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              Container(
                padding: new EdgeInsets.all(10.0),
                width: 500.0,
                decoration: BoxDecoration(
                  color: AppColors.borderColor.withOpacity(0.1),
                  //  borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                    "TimeSheet on Dated:" +
                        widget.date.toString().split(" ")[0],
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: new EdgeInsets.all(10.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Total Working Hours : ",
                                          style: TextStyle(
                                            color: AppColors.borderColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Text(
                                          _itemTimeMarked!['workingHours'] ??
                                              'N/A', // Safe access,
                                          // '$workingHours',
                                          // '${item['WorkingHours']}'
                                          style: TextStyle(
                                            color: AppColors.textColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          )),

                                      // ],)
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Date: ",
                                          style: TextStyle(
                                            color: AppColors.borderColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Text(tsDate.toString().split(" ")[0],
                                          style: TextStyle(
                                            color: AppColors.textColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ]),
                                // SizedBox(
                                //   height: 15,
                                // ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     Text("Total Working Hours : ",
                                //         style: TextStyle(
                                //           color: AppColors.borderColor,
                                //           fontSize: 15,
                                //         )),
                                //     Text('$workingHours',
                                //         // '$workingHours',
                                //         // '${item['WorkingHours']}'
                                //         style: TextStyle(
                                //           color: AppColors.textColor,
                                //           fontSize: 15,
                                //           fontWeight: FontWeight.w500,
                                //         ))
                                //   ],
                                // )
                              ]),
                        ),
                      ])),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: new EdgeInsets.all(5.0),
                                  width: 500.0,
                                  // height:20.0,
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.borderColor.withOpacity(0.1),
                                    //  borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Text("Fill TimeSheet",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textColor,
                                      )),
                                ),
                              ),
                              SizedBox(width: 5),
                              SizedBox(
                                  width: 80,
                                  //  height:50,
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.borderColor
                                          .withOpacity(0.1),
                                      // border: Border.all(color:AppColors.borderColor.withOpacity(0.1)),
                                      // borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Text(
                                      billTypeController.text.isNotEmpty
                                          ? billTypeController.text
                                          : "No Bill",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors
                                              .textColor), // Custom styling
                                    ),
                                  )
                                  // TextField(
                                  //   controller: billTypeController,
                                  //   decoration: InputDecoration(
                                  //     labelText: "Billable",
                                  //     border: OutlineInputBorder(),
                                  //     contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                                  //   ),
                                  //    style: TextStyle(fontSize: 14),
                                  // ),
                                  ),
                            ])
                      ])),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: new EdgeInsets.all(5.0),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                //  crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text("SelectProject: ",
                                              style: TextStyle(
                                                color: AppColors.borderColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: DropdownMenu<String>(
                                              // initialSelection: newData,
                                              hintText: "Select Project",
                                              width: width,
                                              requestFocusOnTap: true,
                                              enableFilter: true,
                                              // label: const Text('SelectProjectId'),
                                              onSelected: (String? value) {
                                                setState(() {
                                                  newProjectData = value!;
                                                  print("projectdata" +
                                                      newProjectData);
                                                });
                                              },
                                              dropdownMenuEntries: _itemProject
                                                  .map<
                                                      DropdownMenuEntry<
                                                          String>>((value) {
                                                return DropdownMenuEntry<
                                                    String>(
                                                  value: value['projectId']
                                                      .toString(),
                                                  label: value['projectName']
                                                      .toString(),
                                                );
                                              }).toList(),
                                              // menuHeight: 200,
                                            )),
                                      ]),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text("SelectProcess: ",
                                            style: TextStyle(
                                              color: AppColors.borderColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ),
                                      SizedBox(width: 5),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          // height:40,
                                          child: DropdownMenu<String>(
                                            // initialSelection: list.first,
                                            hintText: "Select Process",
                                            width: width,
                                            requestFocusOnTap: true,
                                            enableFilter: true,
                                            onSelected: (String? value) {
                                              setState(() {
                                                newProcessData = value!;
                                                print("ProcessData" +
                                                    newProcessData!);
                                                final selectedProcess =
                                                    _itemProcess.firstWhere(
                                                  (process) =>
                                                      process["processId"] ==
                                                      value,
                                                  orElse: () => {
                                                    "billType": ""
                                                  }, // Default if not found
                                                );
                                                // Update the billTypeController based on the selected process
                                                billTypeController.text =
                                                    selectedProcess[
                                                            "billType"] ??
                                                        "";
                                              });
                                            },
                                            dropdownMenuEntries: _itemProcess
                                                .map<DropdownMenuEntry<String>>(
                                                    (value) {
                                              return DropdownMenuEntry<String>(
                                                  value: value['processId']
                                                      .toString(),
                                                  label: value['processName']
                                                      .toString());
                                            }).toList(),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   children: [
                                  //     SizedBox(
                                  //       width:
                                  //           MediaQuery.of(context).size.width *
                                  //               0.29,
                                  //       child: Text("TimesheetId : ",
                                  //           style: TextStyle(
                                  //             color: AppColors.borderColor,
                                  //             fontSize: 15,
                                  //             fontWeight: FontWeight.w500,
                                  //           )),
                                  //     ),
                                  //     SizedBox(width: 10),
                                  //     SizedBox(
                                  //         width: MediaQuery.of(context)
                                  //                 .size
                                  //                 .width *
                                  //             0.5,
                                  //         // height:40,
                                  //         child: DropdownMenu<String>(
                                  //           // initialSelection: list.first,
                                  //           hintText: "Select TimesheetId",
                                  //           width: width,
                                  //           requestFocusOnTap: true,
                                  //           enableFilter: true,
                                  //           onSelected: (String? value) {
                                  //             setState(() {
                                  //               newTimesheetData = value!;
                                  //               print("newTimesheetData" +
                                  //                   newTimesheetData);
                                  //             });
                                  //           },
                                  //           dropdownMenuEntries: _itemTimesheet != null && _itemTimesheet!.isNotEmpty
                                  //               ? _itemTimesheet!
                                  //               .map<DropdownMenuEntry<String>>(
                                  //                   (value) {
                                  //             return DropdownMenuEntry<String>(
                                  //                 value: value['timesheetId']
                                  //                     .toString(),
                                  //                 label: value['timesheetId']
                                  //                     .toString());
                                  //           }).toList() : [],
                                  //         ))
                                  //   ],
                                  // ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          child: Text("Time : ",
                                              style: TextStyle(
                                                color: AppColors.borderColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          //   flex: 1,
                                          child: GestureDetector(
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay
                                                    .now(), // Default to the current time
                                                builder: (BuildContext context,
                                                    Widget? child) {
                                                  return MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                      alwaysUse24HourFormat:
                                                          true, // 24-hour format
                                                    ),
                                                    child: child!,
                                                  );
                                                },
                                              );

                                              if (pickedTime != null) {
                                                // Convert the picked time into minutes
                                                int totalMinutes =
                                                    pickedTime.hour * 60 +
                                                        pickedTime.minute;
                                                actualTimeController.text =
                                                    totalMinutes
                                                        .toString(); // Store minutes as string
                                                actualTimeInMinutes =
                                                    actualTimeController.text;
                                                print("actualTimeController" +
                                                    actualTimeController.text +
                                                    actualTimeInMinutes);
                                              }
                                            },
                                            child: AbsorbPointer(
                                                child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              //  height: 40,
                                              child: TextField(
                                                controller:
                                                    actualTimeController,
                                                decoration: InputDecoration(
                                                    // labelText: "Working Time",
                                                    border:
                                                        OutlineInputBorder(),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4.0,
                                                            horizontal: 4.0)),
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            )),
                                          ),
                                        ),
                                      ]),
                                ])),

                        // )
                      ])),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: new EdgeInsets.all(5.0),
                          child: TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Work Description',
                            ),
                          ),
                        ),
                      ])),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: new EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  onPressed: isAddButtonDisabled
                                      ? null
                                      : () {
                                          addDailgLog(
                                              newProjectData,
                                              newProcessData!,
                                              timesheetId,
                                              actualTimeInMinutes,
                                              descriptionController.text,
                                              tsDate
                                              // billTypeController.text,
                                              );
                                        },
                                  child: Text("ADD",
                                      style: TextStyle(
                                        color: AppColors.backgroundColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ))),
                      ])),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: new EdgeInsets.all(5.0),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                //  crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            //
                                          ],
                                        ),
                                        //     )),
                                        Divider(),
                                        // Display total time
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("FilledTimeSheet: ",
                                                style: TextStyle(
                                                  color: AppColors.textColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            Text(
                                                "${totalTime.toStringAsFixed(2)} min",
                                                style: TextStyle(
                                                  color: AppColors.textColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      ])
                                ])),
                      ])),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: new EdgeInsets.all(5.0),
                          width: 500.0,
                          // height:20.0,
                          decoration: BoxDecoration(
                            color: AppColors.borderColor.withOpacity(0.1),
                            //  borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(
                            "Projects  entry:",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          height: 100, // Set height for the ListView
                          child: _itemDailyLog.isNotEmpty
                              ? ListView.builder(
                                  itemCount: _itemDailyLog.length,
                                  itemBuilder: (context, index) {
                                    final log = _itemDailyLog[index];
                                    final autoId =
                                        log['autoId'] ?? 'Unknown ID';
                                    final processId =
                                        log['processId'] ?? 'Unknown Process';
                                    final projectId =
                                        log['processName'] ?? 'Unknown Project';
                                    final actualTime = log['actualTime'] ?? 0;
                                    final billType =
                                        log['billType'] ?? 'Unknown';
                                    // final log = _itemDailyLog[index];
                                    // autoId = _itemDailyLog[index]['autoId'];
                                    return ListTile(
                                      title: Text('Project: $projectId'),
                                      // subtitle:
                                      //     Text('Process: $processId'),
                                      // \nTime: ${log['actualTime']} minutes
                                      trailing: Wrap(
                                        spacing: 8,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                  height:
                                                      12.0), // Adjust height to control space
                                              Text(
                                                '$actualTime min',
                                                style: TextStyle(
                                                  color: AppColors.textColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Tooltip(
                                          // message: "Totalminutes-" + '${log['actualTime']}',
                                          // preferBelow: false,
                                          // child: IconButton(
                                          //   icon: const Icon(Icons.lock_clock_rounded),
                                          //   color: Colors.green,
                                          //   onPressed: () {},
                                          // ),
                                          // Text(
                                          //     '${log['billType']}',
                                          //     style: TextStyle(
                                          //       color: AppColors.textColor,
                                          //       fontSize: 15,
                                          //     ),
                                          //   ),
                                          // ),

                                          Tooltip(
                                            message: 'cancel',
                                            preferBelow: false,
                                            child: IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  deleteLogByAutoId(autoId);
                                                  // Navigator.of(context).pop();
                                                }),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Text('No logs available'),
                        ),
                      ])),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: new EdgeInsets.all(5.0),
                            child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  onPressed: isSubmitButtonEnabled
                                      ? () {
                                          updateUserTimesheet();
                                        }
                                      : null,
                                  child: Text("SUBMIT",
                                      style: TextStyle(
                                        color: AppColors.backgroundColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ))),
                      ])),
            ]))));
  }

  List<String> projectEntries = [];
  void addDailgLog(String newProjectData, String newProcessData,
      String timesheetId, String time, String description, String date) async {
    await timesheetservice.userDailyLog(newProjectData, newProcessData,
        timesheetId, time, description, date, context);
    await getUsersDailyLog();   
    setState(() {
      // Safely parse workingHours to a double
      double? workingHoursDouble =
          double.tryParse(_itemTimeMarked?['workingHours'] ?? '0');
      double workingHoursInMinutes = (workingHoursDouble ?? 0) * 60;

      print("Total Time: $totalTime");
      print("Working Hours in Minutes: $workingHoursInMinutes");

      // Compare totalTime with working hours in minutes
      if (totalTime > workingHoursInMinutes) {
        showAlert(
          "Warning",
          "Total time (${totalTime.toStringAsFixed(2)} minutes) exceeds the allowed working hours (${workingHoursInMinutes.toStringAsFixed(2)} minutes).",
          context,
        );
      }
      // Enable Submit button if totalTime equals working hours
      isSubmitButtonEnabled = (totalTime >= workingHoursInMinutes);
    });
    actualTimeController.clear();
    descriptionController.clear();
  }

  Future updateUserTimesheet() async {
    print("timesheet");
    await timesheetservice.updateTimesheet(timesheetId, totalBMinutesInt,
        totalNBNPMinutesInt, totalNBPMinutesInt, context);
  }



  deleteLogByAutoId(String autoId) async {
    print("deletedailylog:" + autoId.toString());
    await timesheetservice.deleteTimesheet(autoId, context);
    getUsersDailyLog();
  }
}
