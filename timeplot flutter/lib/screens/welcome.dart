import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeplot_flutter/screens/appbar.dart';
import 'package:timeplot_flutter/screens/calender.dart';
import 'package:timeplot_flutter/screens/colors.dart';
import 'package:timeplot_flutter/screens/ticket.dart';
import 'package:timeplot_flutter/services/addusersattendanceservice.dart';
import 'package:timeplot_flutter/services/sharedpreferences.dart';

final shareddata = SharedPref();

// enum SampleItem { itemOne, itemTwo, itemThree }

SharedPreferences? prefs;

class welcomeScreen extends StatefulWidget {
  // const welcomeScreen({super.key,});

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {

  final Addusersattendance attendanceservice = Addusersattendance();
  // SampleItem? selectedMenu;
  var empId;
  var mode = 'WFH';

  void transferdata() async {
    final empData = await shareddata.getpatdata();
    setState(() {
      empId = empData.userId;
      print("id" + empId.toString());
    });
  }

  @override
  void initState() {
    transferdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          // AppBar(
          //     centerTitle: true,
          //     title: Text(
          //       "Welcome",
          //       style: TextStyle(
          //         color: Colors.white,
          //       ),
          //     ),
          //     backgroundColor:AppColors.primaryColor,
          //     actions: [
          //       PopupMenuButton<SampleItem>(
          //         initialValue: selectedMenu,
          //         // Callback that sets the selected popup menu item.
          //         onSelected: (value) async {
          //           // setState(() {
          //           //   selectedMenu = item;

          //           // });
          //           switch (value) {
          //             case SampleItem.itemOne:
          //               Navigator.of(context)
          //                   .push(MaterialPageRoute(builder: (c) => Applyleave()));
          //               // }
          //               break;

          //             case SampleItem.itemTwo:
          //               Navigator.of(context)
          //                   .push(MaterialPageRoute(builder: (c) => Leavelist()));
          //               break;
          //             case SampleItem.itemThree:
          //               prefs = await SharedPreferences.getInstance();
          //               await prefs?.clear();
          //               Navigator.of(context).pushAndRemoveUntil(
          //                   MaterialPageRoute(builder: (c) => LoginScreen()),
          //                   (route) => false);
          //               break;
          //           }
          //         },
          //         itemBuilder: (BuildContext context) =>
          //             <PopupMenuEntry<SampleItem>>[
          //           const PopupMenuItem<SampleItem>(
          //             value: SampleItem.itemOne,
          //             child: Text('Apply Leave '),
          //           ),
          //           const PopupMenuItem<SampleItem>(
          //             value: SampleItem.itemTwo,
          //             child: Text('LeaveList'),
          //           ),
          //           const PopupMenuItem<SampleItem>(
          //             value: SampleItem.itemThree,
          //             child: Text('Logout'),
          //           ),
          //         ],
          //         // onSelected : (value){

          //         // }
          //       ),
          //     ]),
          CommonAppBar(
        menuItems: ['ApplyLeave', 'LeaveList', 'Logout'],
        title: 'Welcome',
        showProfile: true,
        // onProfileTap: () {
        //   print('Profile tapped!');

        // },
      ),
      drawer: buildDrawer(context),
      body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            // Container(
            //   padding: new EdgeInsets.all(25.0),
            //   child: Text("Mark Attendance-WFH",
            //       style: TextStyle(
            //         color: Colors.blue,
            //         fontSize: 20,
            //         fontWeight: FontWeight.w500,
            //       )),
            // ),
            SizedBox(
              height: 20,
            ),
            //  Padding( padding: new EdgeInsets.all(10.0),
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(5)),

                Container(
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor.withOpacity(1),
                      borderRadius: BorderRadius.circular(10)),
                  padding: new EdgeInsets.all(5.0),
                  child: Text("Mark Attendance-WFH",
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                Wrap(spacing: 2.0, runSpacing: 2.0, children: [
                  CustomRadioButton("4H", 'P4'),
                  CustomRadioButton("6H", 'P6'),
                  CustomRadioButton("8H", 'P8'),
                ])

                
              ],
            ),

          

            SizedBox(
              height: 60,
            ),
            Row(children: <Widget>[
              Padding(padding: EdgeInsets.all(20)),
              Material(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
                //padding:EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalenderScreen(),
                        ));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    child: Text(
                      "LMS",
                      style: TextStyle(
                        color: AppColors.backgroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 60),
              Material(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
                //padding:EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketScreen(),
                        ));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    child: Text(
                      "Ticket",
                      style: TextStyle(
                        color: AppColors.backgroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ])
          ]))),
    );
  }

  var value = 'P0';
  Widget CustomRadioButton(String text, var index) {
    return OutlinedButton(
        onPressed: () {
          setState(() {
            value = index;
          });
          addUserAttendance(empId, value, mode);
        },
        child: Text(
          text,
          style: TextStyle(
            color: (value == index) ? AppColors.backgroundColor :AppColors.textColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
            shape: CircleBorder(),
            // (borderRadius: BorderRadius.circular(10)),
             backgroundColor: (value == index) ? AppColors.primaryColor : Colors.transparent,
            side: BorderSide(
                color:
                    (value == index) ? AppColors.backgroundColor : AppColors.primaryColor)));
  }

  addUserAttendance(
    String empid,
    String value,
    String mode,
  ) async {
    await attendanceservice.userAttendance(
        empid, value.toString(), mode, context);
  }
}
