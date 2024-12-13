import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeplot_flutter/modules/lms/screens/applyleave.dart';
import 'package:timeplot_flutter/modules/lms/screens/calender.dart';

import 'package:timeplot_flutter/modules/lms/screens/login.dart';
import 'package:timeplot_flutter/modules/lms/screens/welcome.dart';
import 'package:timeplot_flutter/screens/colors.dart';
import 'package:timeplot_flutter/services/sharedpreferences.dart';

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
    return AppBar(
      centerTitle: true,
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
              widget.title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
      backgroundColor: AppColors.backgroundColor,  // Customize the background color
      elevation: 0, // Set to 0 if you don't want the default shadow
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey, // Border color
          height: 1.0,
        ),
      ),
      actions: [
        if (widget.showProfile)
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("images/image.jpeg"),
            ),
          ),
        PopupMenuButton<String>(
          onSelected: (String value) {
            // Handle menu item selection
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
          child: Text(menu['menuName']),
        );
      }
    }).toList();
  }

  Widget _buildExpandableMenu(BuildContext context, Map<String, dynamic> menu, StateSetter setState) {
    final isExpanded = _expandedMenuStates[menu['menuName']] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(menu['menuName']),
            GestureDetector(
              onTap: () {
                setState(() {
                  _expandedMenuStates[menu['menuName']] = !isExpanded; // Toggle expanded state
                });
              },
              child: Icon(
                isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
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
              children: (menu['subMenu'] as List)
                  .map<Widget>((subMenu) {
                return InkWell(
                  onTap: () {
                    // Handle submenu selection
                    handleSubmenuSelection(context, subMenu['menuName'], widget.menuItems);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      subMenu['menuName'],
                      style: TextStyle(color: Colors.black87),
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

void showSnackbar(BuildContext context, String message, {bool isSuccess = true}) {
  final Color backgroundColor = isSuccess ? Colors.green : Colors.red;

  final snackbar = SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}



class buildDrawer extends StatefulWidget {
  const buildDrawer({super.key});

  @override
  State<buildDrawer> createState() => _buildDrawerState();
}

class _buildDrawerState extends State<buildDrawer> {

 var empId;
 var roles;
 var name;

 @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

void _loadEmployeeData() async {
    final empData = await shareddata.getpatdata();
    setState(() {
      empId = empData.userId;
      roles=empData.roles;
      name=empData.userName;
      roles = roles.where((role) => role != "Employee").toList();
      print("id:" + empId.toString());
      print("name:" + name.toString());
      print("role:" + roles.toString());
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return  Drawer(
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
                    name != null ? name : "Loading...",
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
          title: Text('Name: $name  '),
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
          title: Text('EmpId: $empId'),
          onTap: () {},
        ),
        ListTile(
          title: Text('Roles: ${roles != null && roles.isNotEmpty ? roles.first : "No role assigned"}',),
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


