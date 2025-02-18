import 'package:flutter/material.dart';
import 'package:focusontime/modules/lms/screens/applyleave.dart';
import 'package:focusontime/modules/lms/screens/calender.dart';

import 'package:focusontime/modules/lms/screens/login.dart';
import 'package:focusontime/modules/lms/screens/reportscreen.dart';
import 'package:focusontime/modules/lms/screens/welcome.dart';
import 'package:focusontime/screens/changepassword_modal.dart';
import 'package:focusontime/screens/colors.dart';
import 'package:focusontime/services/sharedpreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

final shareddata = SharedPref();
SharedPreferences? prefs;

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showProfile;
  final List<Map<String, dynamic>> menuItems;

  CommonAppBar({
    required this.title,
    this.showProfile = false,
    required this.menuItems,
  });

  @override
  _CommonAppBarState createState() => _CommonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CommonAppBarState extends State<CommonAppBar> {
  // Used to keep track of expanded/collapsed submenus
  Map<String, bool> _expandedMenuStates = {};
  var empId;
  var roles;
  var name;

  @override
  Widget build(BuildContext context) {
//     return AppBar(
//       // centerTitle: true,
//       title: Row(
//         mainAxisSize: MainAxisSize.min, // To make the row size fit content
//         mainAxisAlignment: MainAxisAlignment.start, 
//         children: [
//            Align(
//       alignment: Alignment.centerLeft,
//           // Image.asset(
//           //   'images/focus_topnav.jpg',
//           //   fit: BoxFit.fitHeight,
//           //     height: 50,
//           //   //  width: 100,
//           // ),
//           child: SizedBox(
//   height: 50,
//   child: Image.asset(
//     'images/focus_topnav.jpg',
//     fit: BoxFit.scaleDown, // Ensures the image scales down instead of stretching
//   ),
// ),
//            ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               widget.title,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           )
//         ],
//       ),
//       backgroundColor:
//           AppColors.backgroundColor, // Customize the background color
//       elevation: 0, // Set to 0 if you don't want the default shadow
//       bottom: PreferredSize(
//         preferredSize: Size.fromHeight(1.0),
//         child: Container(
//           color: Colors.grey, // Border color
//           height: 1.0,
//         ),
//       ),
//       actions: [
//         if (widget.showProfile)
//           GestureDetector(
//             onTap: () {
//               Scaffold.of(context).openDrawer();
//             },
//             child: CircleAvatar(
//               radius: 20,
//               backgroundImage: AssetImage("images/image.jpeg"),
//             ),
//           ),
//         PopupMenuButton<String>(
//           onSelected: (String value) {
//             // Handle menu item selection
//             handlePopupMenuSelection(context, value, widget.menuItems);
//           },
//           itemBuilder: (BuildContext context) {
//             return _buildMenuItems(context);
//           },
//         ),
//       ],
//     );
return AppBar(
  centerTitle: true,
  title: Row(
    // mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(
        height: 50,
        child: Image.asset(
          'images/focus_topnav.jpg',
          fit: BoxFit.scaleDown,
        ),
      ),
      SizedBox(width: 10), // Reduced spacing
      Flexible( // Prevents unnecessary expansion
        child: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis, // Avoids text overflow
        ),
      ),
    ],
  ),
  backgroundColor: AppColors.backgroundColor,
  elevation: 0,
  bottom: PreferredSize(
    preferredSize: Size.fromHeight(1.0),
    child: Container(
      color: Colors.grey,
      height: 1.0,
    ),
  ),
  actions: [
    // if (widget.showProfile)
    //   Padding(
    //     padding: EdgeInsets.only(right: 3), // Reduced padding for tighter layout
    //     child: GestureDetector(
    //       onTap: () {
    //         Scaffold.of(context).openDrawer();
    //       },
    //       child: CircleAvatar(
    //         radius: 20,
    //         backgroundImage: AssetImage("images/image.jpeg"),
    //       ),
    //     ),
    //   ),
    PopupMenuButton<String>(
      onSelected: (String value) {
        handlePopupMenuSelection(context, value, widget.menuItems);
      },
      itemBuilder: (BuildContext context) {
        return _buildMenuItems(context);
      },
    ),
  ],
);
  }

  // Building the menu items with expanded submenu support
  List<PopupMenuEntry<String>> _buildMenuItems(BuildContext context) {
    return widget.menuItems.map((menu) {
      final hasSubMenu = menu['subMenu'] != null && menu['subMenu'].isNotEmpty;

      if (hasSubMenu) {
        return PopupMenuItem<String>(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return _buildExpandableMenu(context, menu, setState);
            },
          ),
        );
      } else {
        return PopupMenuItem<String>(
          value: menu['menuName'],
          // child: Text(menu['menuName']),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(getIconFromCssClass(
                  menu['cssClassIcon'])), // Use the mapping function here
              SizedBox(width: 10),
              Text(menu['menuName']),
            ],
          ),
        );
      }
    }).toList();
  }

  Widget _buildExpandableMenu(
      BuildContext context, Map<String, dynamic> menu, StateSetter setState) {
    final isExpanded = _expandedMenuStates[menu['menuName']] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(getIconFromCssClass(
                menu['cssClassIcon'])), // Use the mapping function here
            SizedBox(width: 10),
            Text(menu['menuName']),
            Spacer(), // Push the toggle icon to the right
            SizedBox(
                width: 10), // Add space between menu name and the toggle icon
            GestureDetector(
              onTap: () {
                setState(() {
                  _expandedMenuStates[menu['menuName']] =
                      !isExpanded; // Toggle expanded state
                });
              },
              child: Icon(
                isExpanded
                    ? Icons.remove_circle_outline
                    : Icons.add_circle_outline,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (menu['subMenu'] as List).map<Widget>((subMenu) {
                return InkWell(
                  onTap: () {
                    // Handle submenu selection
                    handleSubmenuSelection(
                        context, subMenu['menuName'], widget.menuItems);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(getIconFromCssClass(
                            subMenu['cssClassIcon'])), // Icon for submenu
                        SizedBox(width: 10), // Space between icon and text
                        Text(
                          subMenu['menuName'],
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

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
          builder: (c) => Reportscreen(
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
    case 'Daily Log':
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

// for Icon
IconData getIconFromCssClass(String cssClassIcon) {
  switch (cssClassIcon.trim()) {
    case "icon-home":
      return Icons.home; // Map to home icon
    case "icon-settings":
      return Icons.settings; // Map to settings icon
    case "icon-tag":
      return Icons.local_offer; // Map to tag icon
    case "icon-pencil":
      return Icons.edit; // Map to pencil (edit) icon
    case "icon-bar-chart":
      return Icons.bar_chart; // Map to bar chart icon
    // Add other cases as per the icons in your JSON data
    default:
      return Icons.help; // Default icon if no match is found
  }
}
// snackbar
// void showSnackbar(BuildContext context, String message, {bool isSuccess = true}) {
//   final Color backgroundColor = isSuccess ? Colors.green : Colors.red;

//   final snackbar = SnackBar(
//     content: Text(message),
//     backgroundColor: backgroundColor,
//     duration: const Duration(seconds: 3),
//   );

//   ScaffoldMessenger.of(context).showSnackBar(snackbar);
// }

// for SnackBar

void showSnackbar(
  BuildContext context,
  String message, {
  bool isSuccess = true,
}) {
  final Color backgroundColor = isSuccess ? Colors.green : Colors.red;

  final snackbar = SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

// for open Drawer

class buildDrawer extends StatefulWidget {
  const buildDrawer({super.key});

  @override
  State<buildDrawer> createState() => _buildDrawerState();
}

class _buildDrawerState extends State<buildDrawer> {
  var empId;
  var roles;
  String? name;
  String? leadBy;
  String? emailId;

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  void _loadEmployeeData() async {
    final empData = await shareddata.getpatdata();
    setState(() {
      empId = empData.userId;
      roles = empData.roles;
      emailId = empData.emailId;
      name = empData.userName.replaceAll(RegExp(r'\s*\(.*?\)'), '');
      ;
      // .replaceAll(RegExp(r'\s*\(\d+\)'), '')
      leadBy = empData.leadBy.replaceAll(RegExp(r'\s*\(\d+\)'), '');
      // roles = roles.where((role) => role != "Employee").toList();
      // Check if "Employee" is the only role, otherwise remove it
      if (roles.contains("Employee") && roles.length > 1) {
        roles = roles.where((role) => role != "Employee").toList();
      }
      print("id:" + empId.toString());
      print("name:" + name.toString());
      print("role:" + roles.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Aligns text and icons to the start
              children: [
                Text(
                  'Employee Profile', // Text added before the row
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold, // Optional: Make the title bold
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
                    SizedBox(width: 10), // Space between icon and text
                    Text(
                      //  name ?? "Loading...",
                      name != null && roles != null
                          ? '$name $roles'
                          : "Loading...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment
                //       .center, // Vertically center items in the row
                //   children: [
                //     InkWell(
                //       onTap: () {
                //         // Action when the lock icon is tapped
                //        ForgetPasswordModal(context);
                //         print('Lock Icon Tapped!');

                //       },
                //       child: Icon(
                //         Icons.lock, // Lock icon
                //         color: Colors.white,
                //         size: 20, // Adjust size as needed
                //       ),
                //     ),
                //     SizedBox(width: 10), // Space between icon and text
                //     Text(
                //       'ChangePassword', // Text next to the icon
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 18,
                //       ),
                //     ),
                //   ],
                // ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        ForgetPasswordModal(context);
                        print('Lock Icon & Change Password Clicked!');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock, // Lock icon
                            color: Colors.white,
                            size: 20, // Adjust size as needed
                          ),
                          SizedBox(width: 10), // Space between icon and text
                          Text(
                            'Change Password', // Text next to the icon
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // ListTile(
          // title: Text('Name:${name ?? "Loading..."}  '),
          // Uncomment and implement if needed
          // onTap: () {
          //   Navigator.pop(context);
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => welcomeScreen()),
          //   );
          // },
          // ),
          ListTile(
            title: Text('Employee Id: $empId'),
            onTap: () {},
          ),
          // ListTile(
          //   title: Text('Roles: ${roles != null && roles.isNotEmpty ? roles.first : "No role assigned"}',),
          //   onTap: () {},
          // ),
          ListTile(
            title: Text('Lead By: ${leadBy ?? "Loading..."}  '),
            onTap: () {},
          ),
          ListTile(
            title: Text('Email Id: ${emailId ?? "Loading..."}  '),
            onTap: () {},
          ),

          // ListTile(
          //   title: Text('Email: ananthee89@gmail.com'),
          //   onTap: () {},
          // ),
          // ListTile(
          //   title: Text('Reporting To: Tamilselvan'),
          //   onTap: () {},
          // ),

          //     ListTile(
          //       title: Text('Logout'),
          //       onTap: () async {

          // prefs = await SharedPreferences.getInstance();
          //         await prefs?.clear();
          //         Navigator.of(context).pushAndRemoveUntil(
          //             MaterialPageRoute(builder: (c) => LoginScreen()),
          //             (route) => false);
          //         print('Logging out');
          //       },
          //     ),
          ListTile(
            title: Align(
              alignment: Alignment.centerLeft, // Align as needed
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 8, horizontal: 12), // Adjust padding
                decoration: BoxDecoration(
                  color: AppColors.primaryColor, // Background color
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (c) => LoginScreen()),
                      (route) => false,
                    );
                    print('Logging out');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Wrap content dynamically
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// for dialog
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

// for change password
