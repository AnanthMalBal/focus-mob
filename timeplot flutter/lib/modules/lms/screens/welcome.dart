import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeplot_flutter/modules/lms/screens/calender.dart';
import 'package:timeplot_flutter/screens/appbar.dart';
import 'package:timeplot_flutter/screens/colors.dart';
import 'package:timeplot_flutter/modules/ticketing/screens/ticket.dart';
import 'package:timeplot_flutter/modules/ticketing/screens/ticketraising.dart';
import 'package:timeplot_flutter/screens/menu.dart';

import 'package:timeplot_flutter/services/addusersattendanceservice.dart';
import 'package:timeplot_flutter/services/menuservice.dart';
import 'package:timeplot_flutter/services/sharedpreferences.dart';

final shareddata = SharedPref();

// enum SampleItem { itemOne, itemTwo, itemThree }

SharedPreferences? prefs;

class welcomeScreen extends StatefulWidget {
  // const welcomeScreen({super.key,});
 final List<Map<String, dynamic>> resultMenu; 
 

  welcomeScreen({required this.resultMenu,});
  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {

  final Addusersattendance attendanceservice = Addusersattendance();
  // SampleItem? selectedMenu;
  var empId;
  var mode = 'WFH';
  var roles;
   
   final MenuService menuservice = MenuService();
late List<Map<String, dynamic>> menuItems;


  void transferdata() async {
    final empData = await shareddata.getpatdata();
    setState(() {
      empId = empData.userId;
      roles=empData.roles;
      // print("id" + empId.toString());
    });
  }

  // Future<void> getMenu() async {
  //   try {
  //     List<Map<String, dynamic>>  resultMenu = await menuservice.fetchMenuItems();
  //     setState(() {
  //       menuItems = resultMenu;
  //     });
  //   } catch (e) {
  //     print('Error fetching menu items: $e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    transferdata();
  //  getMenu(); 
    menuItems = widget.resultMenu; 
  }

  @override
  Widget build(BuildContext context) {
   
  
    return Scaffold(
      appBar:
         
          CommonAppBar(
        menuItems: widget.resultMenu,
         title: widget.resultMenu[0]['menuName'],
        showProfile: true,
        // showProfile: true,
        // // onProfileTap: () {
        // //   print('Profile tapped!');

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
                Padding(padding: EdgeInsets.all(10)),

                Container(
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor.withOpacity(1),
                      borderRadius: BorderRadius.circular(10)),
                  padding: new EdgeInsets.all(5.0),
                  child: Text("Mark Attendance-WFH",
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                Wrap(spacing: 1.0, runSpacing: 1.0, children: [
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
              Padding(padding: EdgeInsets.all(40)),
              Material(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(15),
                //padding:EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalenderScreen(resultMenu: widget.resultMenu),
                        ));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                borderRadius: BorderRadius.circular(15),
                //padding:EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketScreen(resultMenu: widget.resultMenu,),
                        ));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
