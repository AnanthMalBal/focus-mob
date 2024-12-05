import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeplot_flutter/modules/lms/screens/applyleave.dart';
import 'package:timeplot_flutter/modules/lms/screens/calender.dart';
// import 'package:timeplot_flutter/modules/lms/screens/filltimesheet.dart';
// import 'package:timeplot_flutter/modules/lms/screens/leavelist.dart';
import 'package:timeplot_flutter/modules/lms/screens/login.dart';
import 'package:timeplot_flutter/modules/lms/screens/welcome.dart';
import 'package:timeplot_flutter/screens/colors.dart';
// import 'package:timeplot_flutter/screens/menu.dart';
// import 'package:timeplot_flutter/screens/qrcodegenerator.dart';
// import 'package:timeplot_flutter/screens/qrcodescan.dart';
// import 'package:timeplot_flutter/modules/ticketing/screens/ticket.dart';
import 'package:timeplot_flutter/services/menuservice.dart';
import 'package:timeplot_flutter/services/sharedpreferences.dart';

final shareddata = SharedPref();
SharedPreferences? prefs;

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Map<String, dynamic>> menuItems;

  final String title;
  final bool showProfile;

  final MenuService menuservice = MenuService();

  // final VoidCallback onProfileTap;

  CommonAppBar({
    required this.title,
    this.showProfile = false,
    // required this.onProfileTap,
    required this.menuItems,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  Map<String, bool> expandedSubmenus = {};

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //  leading:Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Image.asset(
      //         'images/focus_topnav.jpg', // Make sure to add your logo in the assets folder
      //          fit: BoxFit.contain,
      //          width:100,
      //          height: 100,
      //       ),
      //  ),
      centerTitle: true,
      // title: Text(title,
      //  style: TextStyle(
      //        color: Colors.white,
      //      ),),
      title: Row(
        mainAxisSize: MainAxisSize.min, // To make the row size fit content
        children: [
          Image.asset(
            'images/focus_topnav.jpg',
            fit: BoxFit.fill,
            height: 50,
            width: 90,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
      backgroundColor: AppColors.backgroundColor,
      elevation: 0, // Set to 0 if you don't want default shadow
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0), // Set the height of the border
        child: Container(
          color: Colors.grey, // Border color
          height: 1.0, // Border height
        ),
      ),
      actions: <Widget>[
        if (showProfile)
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("images/image.jpeg"),
              ),
            ),
          ),
        PopupMenuButton<String>(
          onSelected: (String value) {
            handlePopupMenuSelection(context, value, menuItems);
          },
          itemBuilder: (BuildContext context) {
            return menuItems.map((menu) {
              // Check if the menu has submenus
              if (menu['subMenu'] != null && menu['subMenu'].isNotEmpty) {
                return PopupMenuItem<String>(
                  value: menu['menuName'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(menu['menuName']),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          children:
                              (menu['subMenu'] as List).map<Widget>((subMenu) {
                            return InkWell(
                              onTap: () {
                                handleSubmenuSelection(
                                    context, subMenu['menuName'], menuItems);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(subMenu['menuName'],
                                    style:
                                        TextStyle(color: AppColors.textColor)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return PopupMenuItem<String>(
                  value: menu['menuName'],
                  child: Text(menu['menuName']),
                );
              }
            }).toList();
          },
        ),
      ],
    );
  }

  // Method to handle menu item selection and navigate accordingly
  Future<void> handlePopupMenuSelection(BuildContext context, String menuItem,
      List<Map<String, dynamic>> resultMenu) async {
    // Switch-case for handling PopupMenu selection
    switch (menuItem) {
      case 'Dashboard':
        print('Navigating to Welcome Screen');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (c) => welcomeScreen(
            resultMenu: resultMenu,
          ), // Pass resultMenu here
        ));
        break;
      case 'WorkAllocation':
        print('Navigating to Welcome Screen');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (c) => welcomeScreen(
            resultMenu: resultMenu,
          ), // Pass resultMenu here
        ));
        break;
      case 'Reports':
        print('Navigating to LeaveList Screen');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => welcomeScreen(
                  resultMenu: resultMenu,
                )));
        break;

      // case 'LeaveList':
      //   print('Navigating to LeaveList Screen');
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (c) => Leavelist(resultMenu: resultMenu)));
      //   break;
      // case 'Ticket':
      //   print('Navigating to TicketScreen');
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (c) => TicketScreen(resultMenu: resultMenu)));
      //   break;
      // case 'QRCodeGenerator':
      //   print('Navigating to QRCodeGenerator Screen');
      //   Navigator.of(context)
      //       .push(MaterialPageRoute(builder: (c) => Qrcodegenerator()));
      //   break;
      // case 'QRCodeScan':
      //   print('Navigating to QRCodeScan Screen');
      //   Navigator.of(context)
      //       .push(MaterialPageRoute(builder: (c) => Qrcodescan()));
      //   break;
      // case 'Performance':
      //   print('Navigating to QRCodeScan Screen');
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (c) => CalenderScreen(resultMenu: resultMenu)));
      //   break;
      // case 'Logout':
      //   prefs = await SharedPreferences.getInstance();
      //   await prefs?.clear();
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (c) => LoginScreen()), (route) => false);
      //   print('Logging out');
      //   break;
      default:
        print('Invalid selection');
    }
  }

  Future<void> handleSubmenuSelection(BuildContext context, String submenuItem,
      List<Map<String, dynamic>> resultMenu) async {
    switch (submenuItem) {
      case 'Performance':
        print('Navigating to Welcome Screen');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => CalenderScreen(
              resultMenu: resultMenu,
            ), // Pass resultMenu here
          ),
        );
        break;
      case 'My Attendance':
        print('Navigating to Welcome Screen');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (c) => CalenderScreen(
            resultMenu: resultMenu,
          ), // Pass resultMenu here
        ));
        break;
      case 'Apply Leave':
        print('Navigating to ApplyLeave Screen');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => Applyleave(
                  resultMenu: resultMenu,
                )));
        break;
      default:
        print('Invalid submenu selection');
    }
  }

  static void showSnackbar(BuildContext context, String message,
      {bool isSuccess = true}) {
    final Color backgroundColor = isSuccess ? Colors.green : Colors.red;

    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3), // Duration of Snackbar
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

Widget buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns text and icons to the start
            children: [
              Text(
                'Employee Profile', // Text added before the row
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold, // Optional: Make the title bold
                ),
              ),
              SizedBox(height: 10), // Space between the title and the row
              Row(
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Vertically center items in the row
                children: [
                  // Icon(
                  //   Icons.person, // Profile icon
                  //   color: Colors.white,
                  //   size: 40, // Adjust size as needed
                  // ),
                  CircleAvatar(
                    radius: 20, // Adjust the size of the avatar
                    backgroundImage: AssetImage(
                        "images/image.jpeg"), // Replace with your image path
                  ),
                  SizedBox(width: 16), // Space between icon and text
                  Text(
                    'Ananthi.N', // Employee Name
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Vertically center items in the row
                children: [
                  InkWell(
                    onTap: () {
                      // Action when the lock icon is tapped
                      print('Lock Icon Tapped!');
                      // You can perform any action here like navigating to another screen
                    },
                    child: Icon(
                      Icons.lock, // Lock icon
                      color: Colors.white,
                      size: 20, // Adjust size as needed
                    ),
                  ),
                  SizedBox(width: 10), // Space between icon and text
                  Text(
                    'ChangePassword', // Text next to the icon
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ListTile(
          title: Text('Name: Ananthi.N'),
          // Uncomment and implement if needed
          // onTap: () {
          //   Navigator.pop(context);
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => welcomeScreen()),
          //   );
          // },
        ),
        ListTile(
          title: Text('Phone Number: 9791397039'),
          // Uncomment and implement if needed
          // onTap: () {
          //   Navigator.pop(context);
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => CalenderScreen()),
          //   );
          // },
        ),
        ListTile(
          title: Text('Email: ananthee89@gmail.com'),
          onTap: () {},
        ),
        ListTile(
          title: Text('Reporting To: Tamilselvan'),
          onTap: () {},
        ),
        ListTile(
          title: Text('Logout'),
          onTap: () async {
            prefs = await SharedPreferences.getInstance();
            await prefs?.clear();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (c) => LoginScreen()),
                (route) => false);
            print('Logging out');
          },
        ),
      ],
    ),
  );
}

Future showdialog(
  BuildContext context,
  String message,
) async {
  return showDialog(
      builder: (context) =>
          new AlertDialog(title: new Text(message), actions: <Widget>[
            new FloatingActionButton(
                onPressed: () => Navigator.pop(context), child: new Text("OK"))
          ]),
      context: context);
}

void showAlert(String title, String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
