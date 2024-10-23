import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeplot_flutter/screens/appbar.dart';
import 'package:timeplot_flutter/screens/colors.dart';
import 'package:timeplot_flutter/services/applyleaveservice.dart';
import 'package:timeplot_flutter/services/sharedpreferences.dart';
import 'package:intl/intl.dart';

final shareddata = SharedPref();

enum SampleItem { itemOne, itemTwo, itemThree }

SharedPreferences? prefs;
List<dynamic> _itemsLeave = [];

class Leavelist extends StatefulWidget {
  const Leavelist({super.key});

  @override
  State<Leavelist> createState() => _LeavelistState();
}

class _LeavelistState extends State<Leavelist> {
  SampleItem? selectedMenu;
  final ApplyLeaveService applyleaveservice = ApplyLeaveService();
  var empId;

  void transferdata() async {
    final empData = await shareddata.getpatdata();
    setState(() {
      empId = empData.userId;
      print("id" + empId.toString());
    });

    getListLeave(empId.toString(), context);
  }

  @override
  void initState() {
    super.initState();
    transferdata();
    _itemsLeave.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          menuItems: ['Welcome', 'Logout'],
          title: 'LeaveList',
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
                  color:AppColors.borderColor.withOpacity(0.1),
                  //  borderRadius: BorderRadius.circular(10)
                ),
                //  width: MediaQuery.of(context).size.width,
                //       height: MediaQuery.of(context).size.height/1 ,
                child: Text("Leave List :" + empId,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              SizedBox(
                  height: 700,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _itemsLeave.length,
                      itemBuilder: (BuildContext context, index) {
                        var days = _itemsLeave[index]['noOfDays'];
                        double noOfDaysAsDouble =
                            (days is int) ? days.toDouble() : days;
                        String noOfDaysStr =
                            noOfDaysAsDouble.toStringAsFixed(1);
                        String status = _itemsLeave[index]['status'];
                        // Color cardColor;
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
                                color: Color.fromARGB(255, 247, 174, 169),
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
                                    message: "noOfDays-" + noOfDaysStr,
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
            ]))));
  }

  Future getListLeave(String empId, context) async {
    _itemsLeave.clear();
    print("list" + empId);
    List<dynamic> resultListLeave =
        await applyleaveservice.getLeaveList(empId, context);
    print("resultlist:" + resultListLeave.toString());

    setState(() {
      _itemsLeave = resultListLeave;
    });
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd')
        .format(dateTime); // Change the format as per your need
  }

  leaveCancel(String leaveId, context) async {
    print("cancel" + leaveId);
    await applyleaveservice.cancelLeaveList(leaveId, context);
    getListLeave(empId.toString(), context);
  }
}
