import 'package:flutter/material.dart';
import 'package:focusontime/screens/CommonShimmer.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:focusontime/screens/colors.dart';
import 'package:focusontime/services/applyleaveservice.dart';
import 'package:focusontime/services/sharedpreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

final shareddata = SharedPref();

enum SampleItem { itemOne, itemTwo, itemThree }

SharedPreferences? prefs;
List<dynamic> _itemsLeave = [];

class Leavelist extends StatefulWidget {
  // const Leavelist({super.key});
  final List<Map<String, dynamic>> resultMenu; 

  Leavelist({
    required this.resultMenu,
  });
  @override
  State<Leavelist> createState() => _LeavelistState();
}

class _LeavelistState extends State<Leavelist> {
  SampleItem? selectedMenu;
  final ApplyLeaveService applyleaveservice = ApplyLeaveService();
  var empId;
  var roles;
  int page = 1;
  int perPage = 5;
  String sort = "modifiedDate desc";
  String firstDate = "";
  String lastDate = "";
  bool _isLoading = true;

  void transferdata() async {
    final empData = await shareddata.getpatdata();
    setState(() {
      empId = empData.userId;
      roles = empData.roles;
      print("id" + empId.toString());
    });
  }

  String getFirstDateOfYear() {
    DateTime now = DateTime.now();
    return DateTime(now.year, 1, 1)
        .toIso8601String()
        .split('T')[0]; // January 1st of the current year
  }

  String getLastDateOfYear() {
    DateTime now = DateTime.now();
    return DateTime(now.year, 12, 31)
        .toIso8601String()
        .split('T')[0]; // December 31st of the current year
  }

  void main() {
    firstDate = getFirstDateOfYear();
    lastDate = getLastDateOfYear();

    print("First Date of Year: $firstDate");
    print("Last Date of Year: $lastDate");
    getListLeave(page, perPage, sort, firstDate, lastDate, context);
  }

  @override
  void initState() {
    super.initState();
    transferdata();
    _itemsLeave.clear();
    main();
     _loadData();
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
    return Scaffold(
        appBar: CommonAppBar(
          menuItems: widget.resultMenu,
          title: 'Leave Report',

          showProfile: true,
          // onProfileTap: () {
          //   print('Profile tapped!');
          // },
        ),
        body: RefreshIndicator(
onRefresh: _refreshData,
          child: SingleChildScrollView(
             physics: AlwaysScrollableScrollPhysics(),
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
                //   ),                
                //   child: 
                //   Text("Leave List :",
                //       style: TextStyle(
                //         color: AppColors.textColor,
                //         fontSize: 20,
                //         fontWeight: FontWeight.w500,
                //       )),
                // ),
                _isLoading ? CommonShimmer(itemCount: _itemsLeave.length, )
                :
                Container(
            padding: EdgeInsets.all(10.0),
            width: 500.0,
            decoration: BoxDecoration(
              color: AppColors.borderColor.withOpacity(0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Distribute space between the elements
              children: [
                Text(
          "Leave Records",
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
                ),
                LegendIndicator(
          color: Colors.blue,  // Example color
          text: "Pending",  // Example text
                ),
                 LegendIndicator(
          color: Colors.green,  // Example color
          text: "Approved",  // Example text
                ),
                LegendIndicator(
          color: Color.fromARGB(255, 241, 46, 32),  // Example color
          text: "Rejected",  // Example text
                ),
              ],
            ),
          ),
           _isLoading
           ? CommonShimmer(itemCount:_itemsLeave.length ):
                SizedBox(
                    height: 700,
                    child: ListView.builder(
                        // scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _itemsLeave.length,
                        itemBuilder: (BuildContext context, index) {
                          // var days = _itemsLeave[index]['noOfDays'];
                          // double noOfDaysAsDouble =
                          //     (days is int) ? days.toDouble() : days;
                          // String noOfDaysStr =
                          //     noOfDaysAsDouble.toStringAsFixed(1);
                          // String status = _itemsLeave[index]['status'];
                          var daysStr = _itemsLeave[index]
                              ['noOfDays']; // "1 day(s)" or "3 day(s)"
          
                          // Use regex to extract the number part of the string (e.g., "1", "3")
                          RegExp regExp = RegExp(
                              r'(\d+(\.\d+)?)'); // Regex to capture a number (integer or decimal)
                          var match = regExp.firstMatch(daysStr);
          
                          // Convert the captured number to a double
                          double noOfDaysAsDouble = 0.0;
                          if (match != null) {
                            noOfDaysAsDouble =
                                double.tryParse(match.group(0) ?? '0') ?? 0.0;
                          }
          
                          String noOfDaysStrFormatted =
                              noOfDaysAsDouble.toStringAsFixed(1);
                          String status = _itemsLeave[index]['status'];
                          // // Color cardColor;
                          BorderSide borderSide;
          
                          // switch (status) {
                          //   case 'Pending':
                          //     cardColor = const Color.fromARGB(255, 163, 208, 245);
                          //     break;
                          //   case 'Approved':
                          //     cardColor = const Color.fromARGB(255, 172, 232, 174);
                          //     break;
                          //   case 'Rejected':
                          //     cardColor = const Color.fromARGB(255, 240, 146, 139);
                          //     break;
                          //   default:
                          //     cardColor = Color.fromARGB(255, 250, 247, 247);
                          // }
          
                          switch (status) {
                            case 'Pending':
                              borderSide =
                                  BorderSide(color: Colors.blue, width: 2.0);
                              break;
                            case 'Approved':
                              borderSide =
                                  BorderSide(color: Colors.green, width: 2.0);
                              break;
                            case 'Rejected':
                              borderSide = BorderSide(
                                  color: Color.fromARGB(255, 241, 46, 32),
                                  width: 2.0);
                              break;
                            default:
                              borderSide =
                                  BorderSide(color: Colors.grey, width: 2.0);
                          }
                          return Card(
                              // color: cardColor,
                              shape: RoundedRectangleBorder(
                                side: borderSide,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: EdgeInsets.all(3.0),
                              child: ListTile(
                                title: Text(_itemsLeave[index]['symbol']),
                                leading: Text(index.toString()),
                                subtitle: Text("From-" +
                                    '${formatDate(_itemsLeave[index]['fromDate'])}' +
                                    "      To-" +
                                    '  ${formatDate(_itemsLeave[index]['toDate'])}'),
                                trailing: Wrap(
                                  spacing: 8,
                                  children: [
                                    Tooltip(
                                      message: "noOfDays-" + noOfDaysStrFormatted,
                                      preferBelow: false,
                                      child: IconButton(
                                        icon: const Icon(Icons.calendar_month),
                                        color: Colors.green,
                                        onPressed: () {},
                                      ),
                                    ),
                                    Tooltip(
                                      message: "reason-" +
                                          _itemsLeave[index]['reason'],
                                      preferBelow: false,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.event,
                                          color:
                                              Color.fromARGB(255, 19, 152, 219),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                    Tooltip(
                                      message: 'cancel',
                                      preferBelow: false,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: status == "Pending"
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        onPressed: status == "Pending"
                                            ? () {
                                                print(
                                                    'Cancel leave requested for ' +
                                                        _itemsLeave[index]
                                                            ['reason']);
                                                String leaveId =
                                                    _itemsLeave[index]['leaveId'];
                                                print("leaveId" + leaveId);
                                                leaveCancel(
                                                    _itemsLeave[index]['leaveId'],
                                                    context);
                                                // Navigator.of(context).pop();
                                              }
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        }))
              ]))),
        ));
  }

  Future getListLeave(int page, int perPage, String sort, String firstDate,
      String lastDate, context) async {
    _itemsLeave.clear();
    print("list" +
        page.toString() +
        perPage.toString() +
        sort +
        firstDate +
        lastDate);
    List<dynamic> resultListLeave = await applyleaveservice.getLeaveList(
        page, perPage, sort, firstDate, lastDate, context);
    print("leaveresultlist:" + resultListLeave.toString());

    setState(() {
      _itemsLeave = resultListLeave;
    });
  }

  

  // Define a helper function to format the date properly
  String formatDate(String dateString) {
    try {
      // Define the correct date format
      final DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");

      // Parse the date string and return the formatted date
      DateTime parsedDate = dateFormat.parse(dateString);
      return DateFormat('dd-MMM-yyyy').format(parsedDate);
    } catch (e) {
      // Handle the error and return a default string if parsing fails
      return "Invalid Date";
    }
  }

  String leaveId = "";
  leaveCancel(String leaveId, context) async {
    print("cancel" + leaveId);
    await applyleaveservice.cancelLeaveList(leaveId, context);
    getListLeave(page, perPage, sort, firstDate, lastDate, context);
  }
}


// for color description
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