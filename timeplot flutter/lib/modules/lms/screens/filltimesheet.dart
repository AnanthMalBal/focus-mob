import 'dart:async';
import 'package:flutter/material.dart';
import 'package:focusontime/screens/CommonShimmer.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:focusontime/screens/colors.dart';
import 'package:focusontime/screens/logo_loader.dart';
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
  // var _itemProcess = [];
  List<Map<String, dynamic>> _itemProcess = [];
  List<Map<String, dynamic>>? _itemTimesheet;
  Map<String, dynamic> _itemTimeMarked = {};
  List<Map<String, dynamic>> _itemDailyLog = [];
  String? empId;
  var actualTimeController = TextEditingController();
  var descriptionController = TextEditingController();
  var billTypeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
  String divisionId = "Dev";
  bool _isLoading = true;

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
    _loadData();
  }

  @override
  void dispose() {
    actualTimeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

// for getproject
  Future<void> getproject(String divisionId) async {
    print("projectid:" + divisionId);
    final resultProject =
        await timesheetservice.getProjectId(divisionId, context);
    print("data:" + resultProject.toString());
    for (var project in resultProject) {
      String projectId = project['projectId'];
      print("Calling getprocess with projectId: $projectId");

      // Call the getprocess function with the projectId
      // await getprocess(projectId);
    }
    setState(() {
      _itemProject = resultProject;
    });
    print("itemproject" + _itemProject.toString());
  }

// for getprocess
  Future<void> getprocess(String projectId) async {
    print("String projectId:" + projectId);
    final resultProcess =
        await timesheetservice.getProcessId(projectId, context);
    print("dataprocess:" + resultProcess.toString());
    setState(() {
      _itemProcess = resultProcess;
    });
    print("itemProcess" + _itemProcess.toString());
  }

// for getTimesheet
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

// for getMarkedAttendance
  Future<void> getMarkedAttendance(String date) async {
    print("MarkedAttendance:" + date);
    final resultTimeMarked =
        await timesheetservice.fetchMarkedAttendance(date, context);
    print(" resultTimeMarked:" + resultTimeMarked.toString());
    setState(() {
      _itemTimeMarked = resultTimeMarked;
    });
    print("_itemTimeMarked: $_itemTimeMarked");
  }

// for getUsersDailyLog
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
    // to display workinghours
    double? workingHoursDouble;
    if (_itemTimeMarked != null && _itemTimeMarked!['workingHours'] is String) {
      workingHoursDouble = double.tryParse(_itemTimeMarked!['workingHours']);
    }
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
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: _isLoading
           ? Center( // ✅ Ensures the loader is centered on the entire screen
            child: LogoLoader(
        size: 100.0, // Customize size
       
       
      ),
           )
           :SingleChildScrollView(
            // ✅ Allows scrolling & prevents overflow
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey, // Assign Form Key
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                         _buildHeader(),
                      SizedBox(height: 10),
                       
                      _buildProjectDropdown(),
                      SizedBox(height: 10),
                      _buildProcessDropdown(),
                      SizedBox(height: 10),
                      _buildTimePicker(),
                      SizedBox(height: 10),
                      _buildDescriptionField(),
                      SizedBox(height: 10),
                      _buildAddButton(),
                      SizedBox(height: 10),
                      _buildFilledTimeSheet(totalTime),
                      SizedBox(height: 10),
                      _buildProjectEntries(
                        _itemDailyLog,
                        deleteLogByAutoId, // Define your delete function as needed
                      ),
                      SizedBox(height: 10),
                      _buildSubmitButton(
                        isSubmitButtonEnabled,
                        updateUserTimesheet, // Function to update timesheet
                      )
                    ]),
                    
                ),
              ),
            ),
          ),
        );
  }

  // UI Components
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Header
        Container(
          padding: EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
          ),
          child: Text(
            "TimeSheet on Date ${widget.date.toString().split(" ")[0]}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 10),

        // Total Working Hours Section
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Total Working Hours : ",
                      style: TextStyle(
                        color: AppColors.borderColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _itemTimeMarked?['workingHours'] ?? 'N/A',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ],
          ),
        ),

        // TimeSheet Title + Bill Type
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Timesheet Title
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.borderColor.withOpacity(0.1),
                      ),
                      child: Text(
                        "TimeSheet",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),

                  // Bill Type Box
                  SizedBox(
                    width: 100,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppColors.borderColor.withOpacity(0.1),
                      ),
                      child: Text(
                        billTypeController.text.isNotEmpty
                            ? billTypeController.text
                            : "No Bill",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

// for project
  Widget _buildProjectDropdown() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text("Project",
              style: TextStyle(
                color: AppColors.borderColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              )),
        ),
        SizedBox(width: 5),
        Expanded(
          child: DropdownButtonFormField<String>(
            hint: Text(_itemProject.isEmpty ? "No data available" :"Select"),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey), // Normal border
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey, width: 2), // Blue when focused
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.red, width: 2), // Red on error
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.red, width: 2), // Red when focused on error
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            value: newProjectData, // ✅ Corrected placement
            onChanged: (String? value) {
              setState(() {
                newProjectData = value!;
                print("Project selected: $newProjectData");
                getprocess(newProjectData!);
              });
            },
            items: _itemProject.map((value) {
              return DropdownMenuItem<String>(
                value: value['projectId'].toString(),
                child: Text(value['projectName'].toString()),
              );
            }).toList(),
            validator: (value) =>
                value == null ? 'Please select a project' : null,
          ),
        ),
      ],
    );
  }


  Widget _buildProcessDropdown() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text("Process",
              style: TextStyle(
                color: AppColors.borderColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              )),
        ),
        SizedBox(width: 5),
        Expanded(
          child: DropdownButtonFormField<String>(
            hint: Text(_itemProcess.isEmpty ? "Select":"Select"),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey), // Normal border
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey, width: 2), // Blue when focused
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.red, width: 2), // Red on error
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.red, width: 2), // Red when focused on error
              ),
            ),
            autovalidateMode:
                AutovalidateMode.onUserInteraction, // ✅ Moved here
            value: _itemProcess.isEmpty ? null :newProcessData,
            onChanged: _itemProcess.isEmpty
              ? null // ❌ Disable dropdown if API fails
              :
            (String? value) {
              setState(() {
                newProcessData = value!;
                print("Process selected: $newProcessData");

                final selectedProcess = _itemProcess.firstWhere(
                  (process) => process["processId"].toString() == value,
                  orElse: () => {"billType": ""}, // Default if not found
                );

                // Update the billTypeController based on the selected process
                billTypeController.text = selectedProcess["billType"] ?? "";
              });
            },
            items: _itemProcess.isEmpty
              ? [] // ❌ Empty dropdown if no data
              :
            _itemProcess.map((value) {
              return DropdownMenuItem<String>(
                value: value['processId'].toString(),
                child: Text(value['processName'].toString()),
              );
            }).toList(),
            validator: (value) =>
                value == null ? 'Please select a process' : null,
          ),
        ),
      ],
    );
  }

// for timepicker

  Widget _buildTimePicker() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            "Time",
            style: TextStyle(
              color: AppColors.borderColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(), // Default to the current time
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat: true, // Use 24-hour format
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedTime != null) {
                // Convert the picked time into total minutes
                int totalMinutes = pickedTime.hour * 60 + pickedTime.minute;
                setState(() {
                  actualTimeController.text = totalMinutes.toString();
                  actualTimeInMinutes = actualTimeController.text;
                });
                print("Selected Time: ${actualTimeController.text} minutes");
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: actualTimeController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: "Select",
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Normal border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey, width: 2), // Blue when focused
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.red, width: 2), // Red on error
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.red,
                        width: 2), // Red when focused on error
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                ),
                style: TextStyle(fontSize: 14),
                validator: (value) =>
                    value!.isEmpty ? 'Please select a time' : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

// for description
  Widget _buildDescriptionField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            "Description",
            style: TextStyle(
              color: AppColors.borderColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          child: TextFormField(
            controller: descriptionController,
            maxLines: 2,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: "Task Description",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey, width: 2), // Blue when focused
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.red, width: 2), // Red on error
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.red, width: 2), // Red when focused on error
              ),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Please enter a description' : null,
          ),
        ),
      ],
    );
  }

// for ADD Button
  Widget _buildAddButton() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
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
                        // Validate the form before calling the add function
                        if (_formKey.currentState!.validate()) {
                          
                          addDailgLog(
                            newProjectData,
                            newProcessData!,
                            timesheetId,
                            actualTimeInMinutes,
                            descriptionController.text,
                            tsDate,
                          );
                         
                        }
                      },
                child: Text(
                  "ADD",
                  style: TextStyle(
                    color: AppColors.backgroundColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//  for filledTimesheet

  Widget _buildFilledTimeSheet(double totalTime) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Divider(), // Divider for separation
                  ],
                ),
                // Display total time
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Filled TimeSheet: ",
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${totalTime.toStringAsFixed(2)} mins", // Formatting to 2 decimal places
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectEntries(List<Map<String, dynamic>> itemDailyLog,
      Function(String) deleteLogByAutoId) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.borderColor.withOpacity(0.1),
            ),
            child: Text(
              "Projects Entry:",
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 100, // Set height for the ListView
            child: itemDailyLog.isNotEmpty
                ? ListView.builder(
                    itemCount: itemDailyLog.length,
                    itemBuilder: (context, index) {
                      final log = itemDailyLog[index];
                      final autoId = log['autoId'] ?? 'Unknown ID';
                      final projectId = log['processName'] ?? 'Unknown Project';
                      final actualTime = log['actualTime'] ?? 0;

                      return ListTile(
                        title: Text(projectId),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 12.0),
                                Text(
                                  '$actualTime mins',
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Tooltip(
                              message: 'Delete log',
                              preferBelow: false,
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  deleteLogByAutoId(
                                      autoId); // Call delete function
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(child: Text('No logs available')),
          ),
        ],
      ),
    );
  }

// for submit button
  Widget _buildSubmitButton(bool isSubmitButtonEnabled, VoidCallback onSubmit) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.all(10),
                ),
                onPressed: isSubmitButtonEnabled ? onSubmit : null,
                child: Text(
                  "SUBMIT",
                  style: TextStyle(
                    color: AppColors.backgroundColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// method to add dailylog
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

      // ✅ Clear input fields
      actualTimeController.clear();
      descriptionController.clear();

      // ✅ Reset form validation to remove error messages
      if (_formKey.currentState != null) {
        _formKey.currentState!.reset();
      }
    });
  }

// method to updateUserTimesheet()
  Future updateUserTimesheet() async {
    print("timesheet");
    await timesheetservice.updateTimesheet(timesheetId, totalBMinutesInt,
        totalNBNPMinutesInt, totalNBPMinutesInt, context);
  }

// method to deleteLogByAutoId
  deleteLogByAutoId(String autoId) async {
    print("deletedailylog:" + autoId.toString());
    await timesheetservice.deleteTimesheet(autoId, context);
    getUsersDailyLog();
  }
}
