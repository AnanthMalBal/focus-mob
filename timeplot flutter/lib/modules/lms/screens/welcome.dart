import 'package:flutter/material.dart';
import 'package:focusontime/modules/lms/screens/calender.dart';
import 'package:focusontime/modules/ticketing/screens/ticket.dart';
import 'package:focusontime/screens/CommonShimmer.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:focusontime/screens/colors.dart';
import 'package:focusontime/screens/logo_loader.dart';
import 'package:focusontime/services/addusersattendanceservice.dart';
import 'package:focusontime/services/menuservice.dart';
import 'package:focusontime/services/sharedpreferences.dart';
import 'package:focusontime/services/timesheetservice.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

final shareddata = SharedPref();
final sharedPref = SharedPref();

SharedPreferences? prefs;

class welcomeScreen extends StatefulWidget {
  // const welcomeScreen({super.key,});
  final List<Map<String, dynamic>> resultMenu;

  welcomeScreen({
    required this.resultMenu,
  });
  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  final Addusersattendance attendanceservice = Addusersattendance();

  var empId;
  var mode = 'WFH';
  var roles;
  final TimeSheetService timesheetservice = TimeSheetService();
  Map<String, dynamic> _itemTimeMarked = {};

  final MenuService menuservice = MenuService();
  late List<Map<String, dynamic>> menuItems;
  bool _isLoading = true;

  void transferdata() async {
    final empData = await shareddata.getpatdata();
    setState(() {
      empId = empData.userId;
      roles = empData.roles;
      // print("id" + empId.toString());
    });
  }

  void main() {
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat('yyyy-MMM-dd').format(now); // e.g., "13-Dec-2024"
    print("Current Date: $formattedDate");
    getMarkedAttendance(formattedDate);
  }

  @override
  void initState() {
    super.initState();
    transferdata();

    menuItems = widget.resultMenu;
    main();

    _loadData(); // Simulate data loading
  }

  Future<void> getMarkedAttendance(String formattedDate) async {
    print("MarkedAttendance");
    final resultTimeMarked =
        await timesheetservice.fetchMarkedAttendance(formattedDate, context);
    print(" resultTimeMarked:" + resultTimeMarked.toString());
    setState(() {
      _itemTimeMarked = resultTimeMarked; // Default to an empty map if null
      value = _itemTimeMarked['symbol'] ?? 'P0';
    });
    print("_itemTimeMarked: $_itemTimeMarked");
  }

// for refresh
  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate API call
    setState(() {
      _isLoading = false; // Data loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    //  final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CommonAppBar(
        menuItems: widget.resultMenu,
        title: widget.resultMenu[0]['menuName'],
        showProfile: true,
        // showProfile: true,
        // // onProfileTap: () {
        // //   print('Profile tapped!');

        // },
      ),
      drawer: buildDrawer(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isLoading
        ? Center( // ✅ Ensures the loader is centered on the entire screen
            child: LogoLoader(
        size: 100.0, // Customize size
       
       
      ),
          )
          :
        ListView(
          physics: AlwaysScrollableScrollPhysics(), // ✅ Ensures scrolling
          padding: EdgeInsets.all(16),
          children: [
            SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  SizedBox(
                    height: 20,
                  ),
                  
                      // buildShimmer(ShimmerType.fullScreen, 1)
                       _buildMainContent(screenWidth),
                ]))
          ],
        ),
      ),
    );
  }

  // ✅ Main Content (After Loading)
  Widget _buildMainContent(double screenWidth) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10)),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor.withOpacity(1),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Mark Attendance",
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: screenWidth < 400 ? 14 : 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Wrap(
              spacing: 5.0,
              children: [
                CustomRadioButton("4H", 'P4'),
                CustomRadioButton("6H", 'P6'),
                CustomRadioButton("8H", 'P8'),
              ],
            ),
          ],
        ),
        SizedBox(height: 60),
        Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(40)),
            _buildButton("LMS", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CalenderScreen(resultMenu: widget.resultMenu)));
            }),
            SizedBox(width: 60),
            _buildButton("Ticket", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TicketScreen(resultMenu: widget.resultMenu)));
            }),
          ],
        ),
      ],
    );
  }

  // ✅ Button Widget
  Widget _buildButton(String title, VoidCallback onTap) {
    return Material(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.backgroundColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // for radio buttons
  String value = 'P0';
  Widget CustomRadioButton(String text, String index) {
    return OutlinedButton(
      onPressed: () async {
        setState(() {
          // If the selected value is the same, reset to 'P0', otherwise toggle to the new value
          value = index;
        });

        addUserAttendance(empId, value, mode);
      },
      child: Text(
        text,
        style: TextStyle(
          color: (value == index)
              ? AppColors.backgroundColor
              : AppColors.textColor, // Text color based on selection
        ),
      ),
      style: OutlinedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: (value == index)
            ? AppColors.primaryColor
            : Colors.transparent, // Background color based on selection
        side: BorderSide(
          color: (value == index)
              ? AppColors.backgroundColor
              : AppColors.primaryColor, // Border color based on selection
        ),
      ),
    );
  }

// method to mark attendance
  addUserAttendance(
    String empid,
    String value,
    String mode,
  ) async {
    await attendanceservice.userAttendance(
        empid, value.toString(), mode, context);
  }
}
