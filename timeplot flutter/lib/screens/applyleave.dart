import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeplot_flutter/screens/appbar.dart';
import 'package:intl/intl.dart';
import 'package:timeplot_flutter/screens/colors.dart';
import 'package:timeplot_flutter/services/applyleaveservice.dart';
import 'package:timeplot_flutter/services/getholidaysservice.dart';
import 'package:timeplot_flutter/services/sharedpreferences.dart';

final shareddata = SharedPref();

enum SampleItem { itemOne, itemTwo, itemThree }

SharedPreferences? prefs;
List<Map<String, dynamic>> _itemsBalance = [];

class Applyleave extends StatefulWidget {
  const Applyleave({super.key});

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

  void transferdata() async {
    final empData = await shareddata.getpatdata();
    setState(() {
      empId = empData.Empid;
      print("id" + empId.toString());
    });
    getBalanceLeave(empId.toString(), context);
  }

  @override
  void initState() {
    super.initState();
    _fetchLeaveTypes();
    transferdata();
  }

  Future<void> _fetchLeaveTypes() async {
    print("resultLMS");

    List<dynamic> resultLeaveType =
        await applyleaveservice.getLeaveType(context);
    print("resultLeaveType:" + resultLeaveType.toString());
    setState(() {
      _leaveTypes = resultLeaveType;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = 260;
    return Scaffold(
       
        appBar:

            CommonAppBar(
          menuItems: ['Welcome', 'Logout'],
          title: 'ApplyLeave',

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
                Container(
                  padding: new EdgeInsets.all(10.0),
                  width: 500.0,
                  // height:20.0,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor.withOpacity(0.1),
                    //  borderRadius: BorderRadius.circular(10)
                  ),
                  //  width: MediaQuery.of(context).size.width,
                  //       height: MediaQuery.of(context).size.height/1 ,
                  child: Text("Avaliable Leaves: 51",
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
                                                color:AppColors.borderColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          SizedBox(width: 20),
                                          DropdownMenu<String>(
                                            // initialSelection: newData,
                                            hintText: "Select Menu",
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
                                                value: value['leave_Type_Id']
                                                    .toString(),
                                                label: value['leave_Type_Name']
                                                    .toString(),
                                              );
                                            }).toList(),
                                          )
                                        ]),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.start,
                                    //   children: [
                                    //     Text("Leave For : ",
                                    //         style: TextStyle(
                                    //           color: Colors.grey,
                                    //           fontSize: 15,
                                    //           fontWeight: FontWeight.w500,
                                    //         )),
                                    //     SizedBox(width: 30),
                                    //     DropdownMenu<String>(
                                    //       // initialSelection: list.first,
                                    //       hintText: "Select Menu",
                                    //       width: width,
                                    //       requestFocusOnTap: true,
                                    //       enableFilter: true,
                                    //       onSelected: (String? value) {
                                    //         // This is called when the user selects an item.
                                    //         setState(() {
                                    //           dropdownValue = value!;
                                    //           print("ProcessData" +
                                    //               dropdownValue);
                                    //         });
                                    //       },
                                    //       dropdownMenuEntries: list
                                    //           .map<DropdownMenuEntry<String>>(
                                    //               (value) {
                                    //         return DropdownMenuEntry<String>(
                                    //           value: value,
                                    //           label: value,
                                    //         );
                                    //       }).toList(),
                                    //     )
                                    //   ],
                                    // ),
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
                                              labelText: "Select Date",
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
                                              labelText: "Select Date",
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
                                                color:AppColors.borderColor,
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
                                              //  labelText: "00:00",
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
                              color:AppColors.borderColor.withOpacity(0.1),
                              //  borderRadius: BorderRadius.circular(10)
                            ),

                            child: Text("History",
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
                                color:AppColors.backgroundColor,
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
                                          empId,
                                          double.parse(
                                              differenceInDays.toString()),
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
            int count = _itemsBalance[index]['Count'];
            String description = _itemsBalance[index]['Description'];
            return Container(
                height: 23,
                child: ListTile(
                    // leading:
                    // CircleAvatar(
                    //   radius: 6,
                    //   backgroundColor: Colors.blue,
                    // ),
                    title: Text(
                      description,
                    ),
                    trailing: Text(count.toString())));
          }),
    );
  }

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

  Future<void> _selectToDate(BuildContext context) async {
    if (fromDate == null) {
      return; // Ensure "from date" is selected before "to date"
    }

    DateTime maxDate;

    // Set the maximum date based on the leave type and the "from date"
    if (newLeaveType == 'Leave') {
      maxDate = fromDate!.add(Duration(days: 2));
    } else if (newLeaveType == 'P4') {
      maxDate = fromDate!.add(Duration(days: 0));
    } else if (newLeaveType == 'Long_Leave') {
      maxDate = fromDate!.add(Duration(days: 15));
    } else {
      maxDate = fromDate!.add(Duration(days: 30));
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate!, // Start at the "from date"
      firstDate: fromDate!, // Minimum date is the "from date"
      lastDate: maxDate, // Maximum date based on leave type
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

  void _calculateDifference() {
    if (fromDate != null && toDate != null) {
      if (newLeaveType == 'P4') {
        differenceInDays = (toDate!.difference(fromDate!).inDays + 0.5);
      } else {
        // Calculate the difference in days
        differenceInDays = toDate!.difference(fromDate!).inDays + 1;
      }
      print("differentdays" + differenceInDays.toString());
      setState(() {});
    }
  }

  Future getBalanceLeave(String empId, context) async {
    print("resultbalance" + empId);
    List<dynamic> resultBalance =
        await leaveservice.getLeaveBalance(empId, context);
    print("resultbalance:" + resultBalance[0].toString());
    List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(resultBalance[0]);
    setState(() {
      _itemsBalance = data;

      // int count =  _itemsBalance['Count'];
      // print("count++"+count.toString());
      // mapMonths.addEntries( _itemsBalance.entries);
      // mapMonths.forEach((key, value) {
      //   print("++++" '$key: $value');
      // });
    });
  }

  requestLeave(String empid, double days, String symbol, String fromDate,
      String toDate, String reason, context) async {
    await applyleaveservice.applyLeave(
        empid, days, symbol, fromDate, toDate, reason, context);

    dateinputFrom.clear();
    dateinputTo.clear();
    reasoncontroller.clear();
  }
}
