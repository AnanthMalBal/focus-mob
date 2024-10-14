import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeplot_flutter/screens/applyleave.dart';
import 'package:timeplot_flutter/screens/colors.dart';
import 'package:timeplot_flutter/screens/leavelist.dart';
import 'package:timeplot_flutter/screens/login.dart';
import 'package:timeplot_flutter/screens/ticket.dart';
import 'package:timeplot_flutter/screens/welcome.dart';
import 'package:timeplot_flutter/services/sharedpreferences.dart';

final shareddata = SharedPref();
SharedPreferences? prefs;

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> menuItems;

  final String title;
  final bool showProfile;
  // final VoidCallback onProfileTap;

  CommonAppBar(
      {required this.title,
      this.showProfile = false,
      // required this.onProfileTap,
      required this.menuItems});

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

          SizedBox(
              width: 10), 
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
        color:  Colors.grey,  // Border color
        height: 1.0,         // Border height
      ),
    ),
      actions: <Widget>[
        if (showProfile)
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: GestureDetector(
              onTap: () {
                // Open the drawer when the profile image is tapped
                Scaffold.of(context).openDrawer();
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("images/image.jpeg"),
                // NetworkImage(
                //   'https://example.com/profile_picture.jpg', // Replace with your profile picture URL
                // ),
              ),
            ),
          ),
        PopupMenuButton<String>(
          onSelected: (String value) {
            // Handle menu item selection
            handlePopupMenuSelection(context, value);
            print('Selected: $value');
          },
          itemBuilder: (BuildContext context) {
            return menuItems.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Future<void> handlePopupMenuSelection(
      BuildContext context, String menuItem) async {
    // Switch-case for handling PopupMenu selection
    switch (menuItem) {
      case 'Welcome':
        print('Navigating to settings');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => welcomeScreen()));
        // Navigate to settings
        break;
      case 'ApplyLeave':
        print('Navigating to settings');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => Applyleave()));
        // Navigate to settings
        break;
      case 'LeaveList':
        print('Navigating to settings');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => Leavelist()));
        // Navigate to settings
        break;
        case 'Ticket':
        print('Navigating to settings');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => TicketScreen()));
        // Navigate to settings
        break;
      case 'Logout':
        prefs = await SharedPreferences.getInstance();
        await prefs?.clear();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => LoginScreen()), (route) => false);
        print('Logging out');
        // Add logout logic here
        break;
      default:
        print('Invalid selection');
    }
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
          child: Text(
            'Employee Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          title: Text('Name:' + "Ananthi.N"),
          // onTap: () {
          //   Navigator.pop(context);
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => welcomeScreen()),
          //   );
          // },
        ),
        ListTile(
          title: Text('PhoneNumber:' + "9791397039"),
          // onTap: () {
          //   Navigator.pop(context);
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => CalenderScreen()),
          //   );
          // },
        ),
        ListTile(
          title: Text('Email:' + "ananthee89@gmail.com"),
          onTap: () {},
        ),
        ListTile(
          title: Text('ReportingTo:' + "Tamilselvan"),
          onTap: () {},
        ),
      ],
    ),
  );
}


  Future showdialog(BuildContext context, String message,) async {
    return showDialog(
        builder: (context) =>
            new AlertDialog(title: new Text(message), actions: <Widget>[
              new FloatingActionButton(
                  onPressed: () => Navigator.pop(context),
                  child: new Text("OK"))
            ]),
        context: context);
  }


  void showAlert(String title, String message,BuildContext context) {
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