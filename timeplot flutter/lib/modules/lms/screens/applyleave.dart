import 'package:flutter/material.dart';
import 'package:focusontime/modules/lms/screens/leavelist.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:focusontime/screens/colors.dart';
import 'package:focusontime/services/applyleaveservice.dart';
import 'package:focusontime/services/getholidaysservice.dart';
import 'package:focusontime/services/sharedpreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';


final shareddata = SharedPref();

enum SampleItem { itemOne, itemTwo, itemThree }

SharedPreferences? prefs;
List<Map<String, dynamic>> _itemsBalance = [];

class Applyleave extends StatefulWidget {
  // const Applyleave({super.key});
  final List<Map<String, dynamic>> resultMenu; 

  Applyleave({
    required this.resultMenu,
  });

  @override
  State<Applyleave> createState() => _ApplyleaveState();
}

List<String> list = <String>['Select', 'Two', 'Three', 'Four'];
String dropdownValue = list.first;

class _ApplyleaveState extends State<Applyleave> {
  SampleItem? selectedMenu;
  var newLeaveType;
  var newLeaveFor;
  var newTimesheetData;
  TextEditingController dateinputFrom = TextEditingController();
  TextEditingController dateinputTo = TextEditingController();
  TextEditingController reasoncontroller = TextEditingController();
  List<dynamic> _leaveTypes = [];
  final ApplyLeaveService applyleaveservice = ApplyLeaveService();
  final HolidayService leaveservice = HolidayService();
  var empId;
  var roles;

  void transferdata() async {
    final empData = await shareddata.getpatdata();
    setState(() {
      empId = empData.userId;
      roles = empData.roles;
      print("id" + empId.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchLeaveTypes();
    _getBalanceLeave(context);
    transferdata();
  }

  

  Future<void> _fetchLeaveTypes() async {
    print("Fetching Leave Types in ApplyLeaveService...");

    try {
      List<dynamic> resultLeaveType =
          await applyleaveservice.getLeaveType(context);
      print("Fetched Leave Types: $resultLeaveType");

      setState(() {
        _leaveTypes = resultLeaveType;
      });
    } catch (e) {
      print("Error fetching leave types: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = 260;
    return Scaffold(
        appBar: CommonAppBar(
          menuItems: widget.resultMenu,
          title: 'Apply Leave',

          showProfile: true,
          // onProfileTap: () {
          //   print('Profile tapped!');
          // },
        ),
        body: SingleChildScrollView(
            child: SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container(
                //   padding: new EdgeInsets.all(10.0),
                //   width: 500.0,
                //   // height:20.0,
                //   decoration: BoxDecoration(
                //     color: AppColors.borderColor.withOpacity(0.1),
                //     //  borderRadius: BorderRadius.circular(10)
                //   ),
                //   //  width: MediaQuery.of(context).size.width,
                //   //       height: MediaQuery.of(context).size.height/1 ,
                //   child: Text("Avaliable Leaves: 51",
                //       style: TextStyle(
                //         color: AppColors.textColor,
                //         fontSize: 20,
                //         fontWeight: FontWeight.w500,
                //       )),
                // ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: 500.0,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor.withOpacity(0.1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Aligns text and icon to the ends
                    children: [
                      Text(
                        "Apply Leave ",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.history, // Use any icon, e.g., Icons.history
                          color: AppColors.textColor,
                        ),
                        onPressed: () {
                         
                         Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Leavelist(resultMenu: widget.resultMenu,),
                        ));
                        },
                      ),
                    ],
                  ),
                ),
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
                                          Text("Leave Type : ",
                                              style: TextStyle(
                                                color: AppColors.borderColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          SizedBox(width: 20),
                                          DropdownMenu<String>(
                                            // initialSelection: newData,
                                            hintText: "Select Leave Type",
                                            width: width,
                                            requestFocusOnTap: true,
                                            enableFilter: true,
                                            // label: const Text('SelectProjectId'),
                                            onSelected: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                newLeaveType = value!;
                                                print("newLeaveType" +
                                                    newLeaveType);
                                              });
                                            },
                                            dropdownMenuEntries: _leaveTypes
                                                .map<DropdownMenuEntry<String>>(
                                                    (value) {
                                              return DropdownMenuEntry<String>(
                                                value: value['leaveTypeId']
                                                    .toString(),
                                                label: value['leaveTypeName']
                                                    .toString(),
                                              );
                                            }).toList(),
                                          )
                                        ]),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Leave From : ",
                                              style: TextStyle(
                                                color: AppColors.borderColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          SizedBox(width: 20),
                                          Expanded(
                                              child: TextField(
                                            controller: dateinputFrom,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Select From Date",
                                              // "${_dateTime.toLocal()}".split(' ')[0],
                                              suffixIcon: Icon(
                                                Icons.calendar_view_month,
                                              ),
                                            ),
                                            readOnly: true,
                                            onTap: () {
                                              _selectFromDate(context);
                                            },
                                          ))
                                        ]),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Leave To : ",
                                              style: TextStyle(
                                                color: AppColors.borderColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          SizedBox(width: 40),
                                          Expanded(
                                              child: TextField(
                                            controller: dateinputTo,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Select To Date",
                                              // "${_dateTime.toLocal()}".split(' ')[0],
                                              suffixIcon: Icon(
                                                Icons.calendar_view_month,
                                              ),
                                            ),
                                            readOnly: true,
                                            onTap: () {
                                              _selectToDate(context);
                                            },
                                          ))
                                        ]),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Reason : ",
                                              style: TextStyle(
                                                color: AppColors.borderColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          SizedBox(width: 50),
                                          Expanded(
                                              child: TextField(
                                            controller: reasoncontroller,
                                            maxLines: 2,
                                            //  expands: false,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              labelText: "Reason",
                                            ),
                                          ))
                                        ]),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Total Days of Leave :" +
                                                  differenceInDays.toString(),
                                              style: TextStyle(
                                                color: AppColors.borderColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ]),
                                  ]))
                        ])),
                Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 5, right: 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: new EdgeInsets.all(10.0),
                            width: 500.0,
                            // height:20.0,
                            decoration: BoxDecoration(
                              color: AppColors.borderColor.withOpacity(0.1),
                              //  borderRadius: BorderRadius.circular(10)
                            ),

                            child: Text("Balance Leave",
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ])),
                getLeaveList(),
                Padding(
                    padding: EdgeInsets.only(top: 5.0, left: 5, right: 5),
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
                                    onPressed: () {
                                      requestLeave(
                                          // empId,
                                          // double.parse(
                                          //     differenceInDays.toString()),
                                          newLeaveType,
                                          dateinputFrom.text,
                                          dateinputTo.text,
                                          reasoncontroller.text,
                                          context);
                                    },
                                    child: Text("Request",
                                        style: TextStyle(
                                          color: AppColors.backgroundColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  )))
                        ])),
              ]),
        )));
  }

  Widget getLeaveList() {
    Padding(padding: EdgeInsets.all(5.0));
    // return Expanded(
    return SizedBox(
      height: 200,
      // child:Text("Hi")
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _itemsBalance.length,
          itemBuilder: (BuildContext context, index) {
            int count = _itemsBalance[index]['Count'] ?? 0;
            String description = _itemsBalance[index]['Description'] ??
                'No description available';
            return Container(
                height: 30,
                child: ListTile(
                    // leading:
                    // CircleAvatar(
                    //   radius: 6,
                    //   backgroundColor: Colors.blue,
                    // ),
                    title: Text(
                      description,
                    ),
                    trailing: CircleAvatar(
                    radius: 30, // Adjust the size of the circle
                    backgroundColor:
                        AppColors.primaryColor, // Background color of the circle
                    child: Text(
                      count.toString(), // Text inside the circle
                      style: TextStyle(
                        color: Colors.white, // Text color inside the circle
                        fontWeight: FontWeight.bold, // Optional: Text boldness
                      ),
                    ),
                  ),));
          }),
    );
  }


// for fromDate
  DateTime? fromDate;
  DateTime? toDate;
  double? differenceInDays = 0;

  Future<void> _selectFromDate(BuildContext context) async {
    DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now, // Initial date
      firstDate: now, // Minimum date is today
      lastDate:
          now.add(Duration(days: 30)), // Optional: Limit to a year from today
    );

    if (picked != null && picked != fromDate) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        dateinputFrom.text = formattedDate;
        fromDate = picked;
        toDate = null; // Reset the "to date" when a new "from date" is selected
        print("date" + dateinputFrom.text);
      });
    }
  }


// for ToDate
  Future<void> _selectToDate(BuildContext context) async {
    if (fromDate == null || newLeaveType == null || _leaveTypes == null) {
      return; // Ensure "from date" and "leave type" are selected before proceeding
    }

    DateTime maxDate;

    // Get the max days from the API response based on selected leave type
    final leaveType = _leaveTypes
        .firstWhere((leave) => leave['leaveTypeId'] == newLeaveType);
    final maxDays = leaveType['maxDays'];

    // Ensure that maxDays is not null and is a valid number
    if (maxDays == null || maxDays <= 0) {
      return; // Handle error if maxDays is invalid
    }

    // Special case for "Half_Day" leave
    if (newLeaveType == 'Half_Day') {
      maxDate =
          fromDate!; // For Half Day Leave, the max date is the same as the fromDate
    } else {
      // Calculate the maxDate based on the maxDays for other leave types
      maxDate = fromDate!.add(Duration(
          days: maxDays -
              1)); // Subtract 1 because fromDate is counted as the first day
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate!, // Start at the "from date"
      firstDate: fromDate!, // Minimum date is the "from date"
      lastDate: maxDate, // Maximum date based on leave type's maxDays
    );

    if (picked != null && picked != toDate) {
      String formattedDate1 = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        dateinputTo.text = formattedDate1;
        print("date1" + dateinputTo.text);
        toDate = picked;
        _calculateDifference();
      });
    }
  }

// for days calculate
  void _calculateDifference() {
    if (fromDate != null && toDate != null) {
      if (newLeaveType == 'Half_Day') {
        // If the leave type is Half Day, consider the 0.5 day duration
        differenceInDays = (toDate!.difference(fromDate!).inDays + 0.5);
      } else if (newLeaveType == 'Leave') {
        // For Leave, treat it as 1 full day (from the start date to the same date)
        differenceInDays = 1.0;
      }
      //  else if (newLeaveType == 'Paternity_Leave') {
      //   // For Leave, treat it as 1 full day (from the start date to the same date)
      //   differenceInDays = 5.0;
      // }
      else {
        // For other leave types, calculate the full days difference
        differenceInDays = toDate!.difference(fromDate!).inDays +
            1; // Adding 1 to account for the day range
      }
      print("differenceInDays: " + differenceInDays.toString());
      setState(() {});
    }
  }


  Future<void> _getBalanceLeave(BuildContext context) async {
    Map<String, dynamic> leaveBalance =
        await leaveservice.getLeaveBalance(context);
    // Now you have the leave balance data, and you can use it as needed
    print('Leave Balance Count: ${leaveBalance['Count']}');
    print('Leave Balance Description: ${leaveBalance['Description']}');

    if (leaveBalance != null) {
      // Update _itemsBalance with the leave balance data
      setState(() {
        // Assuming leaveBalance contains 'Count' and 'Description'
        _itemsBalance = [
          {
            'Count': leaveBalance['Count'] ??
                0, // Default to 0 if Count is not available
            'Description': leaveBalance['Description'] ??
                'No description available', // Default if Description is missing
          },
        ];
      });
      print('Updated Leave Count: ${_itemsBalance[0]['Count']}');
      print('Updated Leave Description: ${_itemsBalance[0]['Description']}');
    } else {
      print('Leave balance data is null');
      setState(() {
        _itemsBalance = [];
      });
    }
  }

  requestLeave(String symbol, String fromDate, String toDate, String reason,
      context) async {
    await applyleaveservice.applyLeave(
        symbol, fromDate, toDate, reason, context);

    dateinputFrom.clear();
    dateinputTo.clear();
    reasoncontroller.clear();
  }
}
