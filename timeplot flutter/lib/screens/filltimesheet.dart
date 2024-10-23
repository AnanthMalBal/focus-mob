import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeplot_flutter/screens/appbar.dart';
import 'package:timeplot_flutter/screens/colors.dart';
import 'package:timeplot_flutter/services/sharedpreferences.dart';
import 'package:timeplot_flutter/services/timesheetservice.dart';
import 'package:intl/intl.dart';

final shareddata = SharedPref();

enum SampleItem { itemOne, itemTwo, itemThree }

SharedPreferences? prefs;
// List<dynamic> _itemsProject = [];

class FillTimeSheet extends StatefulWidget {
  final DateTime date;
  // const FillTimeSheet({super.key, required this.date});
  FillTimeSheet({required this.date});

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
  var _itemProject = [];
  var _itemProcess = [];
  var _itemTimesheet = [];
  List<dynamic> _itemTimeMarked = [];
  List<dynamic> _itemDailyLog = [];
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
  TimeOfDay? selectedTime;
  String actualTimeInMinutes = '';
  int? B = 0;
  int? NBNP = 0;
  int? NBP = 0;
  int totalNBNPMinutesInt = 0;
  int totalBMinutesInt = 0;
  int totalNBPMinutesInt = 0;
 

  int autoId = 0;

  @override
  void initState() {
    // user = widget.date;
    String date = widget.date.toString().split(" ")[0];
    print("date" + date);
    super.initState();
    transferdata();
    getproject();
    getprocess();
    getTimesheet(date);
    //  getUsersDailyLog();
    // loadTotalMinutes();
  }

  @override
  void dispose() {
    actualTimeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> getproject() async {
    print("projectid");
    final resultProject = await timesheetservice.getProjectId(context);
    print("data:" + resultProject.toString());
    setState(() {
      _itemProject = resultProject;
    });
    print("itemproject" + _itemProject.toString());
  }

  Future<void> getprocess() async {
    print("processid");
    final resultProcess = await timesheetservice.getProcessId(context);
    print("data:" + resultProcess.toString());
    setState(() {
      _itemProcess = resultProcess;
    });
    print("itemProcess" + _itemProcess.toString());
  }

  Future<void> getTimesheet(String date) async {
    print("itemTimesheet");
    final resultTimesheet =
        await timesheetservice.getTimesheetId(date, context);
    // widget.date.toString().split(" ")[0]
    print("data:" + resultTimesheet.toString());
    setState(() {
      _itemTimesheet = resultTimesheet;
    });
    timesheetId = _itemTimesheet[0]['timesheetId'];
    print("extracttimesheet" + timesheetId);
    getUsersDailyLog();
  }

  Future<void> getTimeMarked(String empId, String date) async {
    print("TimeMarked" + empId + date);
    final resultTimeMarked =
        await timesheetservice.getMarkedTime(empId, date, context);
    // widget.date.toString().split(" ")[0]
    print(" resultTimeMarked:" + resultTimeMarked.toString());
    setState(() {
      _itemTimeMarked = resultTimeMarked;
    });
    print("_itemTimeMarked" + _itemTimeMarked.toString());
  }

  Future<void> getUsersDailyLog() async {
    print("DailyLog");
    // deleteLogByAutoId(int autoId)
    final resultDailyLog =
        await timesheetservice.getDailyLog(timesheetId, context);
    // widget.date.toString().split(" ")[0]
    print("data:" + resultDailyLog.toString());

    setState(() {
      _itemDailyLog = resultDailyLog;
    });

    // // Calculate total time in minutes
    // totalTime = _itemDailyLog.fold(0.0, (sum, log) {
    //   double minutes = double.tryParse(log['actualTime'].toString()) ??
    //       0; // Get actual time in minutes
    //   return sum + minutes; // Sum up the actual time
    // });
    

    // print('Total time calculated: $totalTime');

// Ensure _itemDailyLog is a list and iterate through it
    if (_itemDailyLog != null && _itemDailyLog is List) {
      // Initialize variables for B and NBP minutes
       double totalBMinutes = 0.0;
      double totalNBPMinutes = 0.0;
      double  totalNBNPMinutes = 0.0;
      // Calculate total time in minutes and categorize into B and NBP
      totalTime = _itemDailyLog.fold(0.0, (sum, log) {
        double minutes = double.tryParse(log['actualTime'].toString()) ?? 0;

        // Categorize minutes based on billType
        if (log['billType'] == 'B') {
          totalBMinutes += minutes;
        } else if (log['billType'] == 'NBP') {
          totalNBPMinutes += minutes;
        }else{
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
    // Map<String, int> totalMinutes = await shareddata.getTotalMinutes();
    // print("Total minutes loaded.");
    setState(() {
      empId = empData.userId;
      print("id" + empId.toString());
      // totalNBNPMinutes = 0;
      // totalNBPMinutes = 0;
      // totalBMinutes = 0;
      // totalNBNPMinutes = totalMinutes['totalNBNPMinutes']!;
      // totalNBPMinutes = totalMinutes['totalNBPMinutes']!;
      // totalBMinutes = totalMinutes['totalBMinutes']!;
    });
    getTimeMarked(empId.toString(), widget.date.toString().split(" ")[0]);
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime;

    if (_itemTimeMarked.isNotEmpty) {
      var item = _itemTimeMarked[0];

      DateTime dateTime = DateTime.parse(item['markedTime']);
      formattedTime = DateFormat('hh:mm a').format(dateTime);

      workingHours = item['WorkingHours'];
    } else {
      print('No time entries found.');

      formattedTime = 'N/A';
    }
    double? workingHoursDouble = double.tryParse(workingHours);
    double workingHoursInMinutes = (workingHoursDouble ?? 0) * 60;
    double width = 200;
    bool isAddButtonDisabled =
        workingHoursInMinutes > 0 && totalTime >= workingHoursInMinutes;
    bool isSubmitButtonEnabled = totalTime == workingHoursInMinutes;

    return Scaffold(
        appBar: CommonAppBar(
          menuItems: ['Welcome', 'Logout'],
          title: 'TimeSheet',
          showProfile: true,
          // onProfileTap: () {
          //   print('Profile tapped!');
          // },
        ),
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
                                      Text('$workingHours'.toString(),
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
                                      // Text("Sign In : ",
                                      //     style: TextStyle(
                                      //       color: AppColors.borderColor,
                                      //       fontSize: 15,
                                      //       fontWeight: FontWeight.w500,
                                      //     )),
                                      // Text('$formattedTime',
                                      //     style: TextStyle(
                                      //       color: AppColors.textColor,
                                      //       fontSize: 15,
                                      //       fontWeight: FontWeight.w500,
                                      //     )),
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
                                       color:
                                        AppColors.borderColor.withOpacity(0.1),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.29,
                                        child: Text("TimesheetId : ",
                                            style: TextStyle(
                                              color: AppColors.borderColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ),
                                      SizedBox(width: 10),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          // height:40,
                                          child: DropdownMenu<String>(
                                            // initialSelection: list.first,
                                            hintText: "Select TimesheetId",
                                            width: width,
                                            requestFocusOnTap: true,
                                            enableFilter: true,
                                            onSelected: (String? value) {
                                              setState(() {
                                                newTimesheetData = value!;
                                                print("newTimesheetData" +
                                                    newTimesheetData);
                                              });
                                            },
                                            dropdownMenuEntries: _itemTimesheet
                                                .map<DropdownMenuEntry<String>>(
                                                    (value) {
                                              return DropdownMenuEntry<String>(
                                                  value: value['timesheetId']
                                                      .toString(),
                                                  label: value['timesheetId']
                                                      .toString());
                                            }).toList(),
                                          ))
                                    ],
                                  ),
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
                                              newProcessData!,
                                              newProjectData,
                                              newTimesheetData,
                                              actualTimeInMinutes,
                                              descriptionController.text,
                                              billTypeController.text);

                                          // actualTimeController.clear();
                                          // descriptionController.clear();
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
                                            //                   Text("Filled Time Sheet : ",
                                            //                       style: TextStyle(
                                            //                         color: AppColors.textColor,
                                            //                         fontSize: 20,
                                            //                       )),
                                            //                   SizedBox(
                                            //                     width: 10,
                                            //                   ),
                                            //                    // Display each filled time entry
                                            // ...filledTimes.map((time) => Padding(
                                            //       padding: const EdgeInsets.only(top: 5.0),
                                            //       child: Row(
                                            //         children: [
                                            //           Text("${time.toStringAsFixed(2)} hr",
                                            //               style: TextStyle(
                                            //                 color: Colors.blue,
                                            //                 fontSize: 16,
                                            //               )),
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

                                        // Text("00:00 hr ",
                                        //     style: TextStyle(
                                        //       color: Colors.blue,
                                        //       fontSize: 20,
                                        //     )),
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
                                    autoId = _itemDailyLog[index]['autoId'];
                                    return ListTile(
                                      title:
                                          Text('Project: ${log['processId']}'),
                                      subtitle:
                                          Text('Process: ${log['projectId']}'),
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
                                                '${log['actualTime']} min',
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
  void addDailgLog(String newProcessData, String newProjectData,
      String newTimesheetData, String time, String description,String bill) async {
    await timesheetservice.userDailyLog(newProcessData, newProjectData,
        newTimesheetData, time, description,bill, context);
    await getUsersDailyLog();

    //  double minutes = double.tryParse(time) ?? 0;

    setState(() {
      // filledTimes.add(minutes); // Add to the list
      // totalTime += minutes; // Update total time
      // Check if totalTime exceeds workingHours
      double? workingHoursDouble = double.tryParse(workingHours);
      double workingHoursInMinutes = (workingHoursDouble ?? 0) * 60;
      print("Total Time: $totalTime");
      print("Working Hours in Minutes: $workingHoursInMinutes");
      // Set the button states
      // this.isAddButtonDisabled = isAddButtonDisabled;
      // this.isSubmitButtonDisabled = !isSubmitButtonEnabled; // Submit button is enabled only if total time equals working hours

      // Show alert if total time exceeds working hours
      if (totalTime > workingHoursInMinutes) {
        showAlert(
          "Warning" ,
          "Total time (${totalTime.toStringAsFixed(2)}) exceeds working hours (${workingHoursInMinutes.toStringAsFixed(2)} minutes).",context
        );
      }
    });
    actualTimeController.clear();
    descriptionController.clear();
  }

  Future updateUserTimesheet() async {
    print("timesheet");
    await timesheetservice.updateTimesheet(
        totalBMinutesInt, totalNBNPMinutesInt, totalNBPMinutesInt, timesheetId, context);
  }

// Save total minutes
  // void saveTotalMinutes() async {
  //   await shareddata.storeTotalMinutes(
  //       totalNBNPMinutes, totalNBPMinutes, totalBMinutes);
  //   print("Total minutes saved!");
  // }

  deleteLogByAutoId(int autoId) async {
    await timesheetservice.deleteTimesheet(autoId, context);
    getUsersDailyLog();
  }

  
}
