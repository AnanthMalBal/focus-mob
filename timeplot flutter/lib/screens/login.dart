import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timeplot_flutter/screens/colors.dart';
// import 'package:timeplot_flutter/model/login';
// import 'package:timeplot_flutter/screens/calender.dart';
//  import 'package:http/http.dart' as http;
// import 'package:timeplot_flutter/screens/welcome.dart';
import 'package:timeplot_flutter/services/loginservice.dart';
import 'package:timeplot_flutter/services/notification_service.dart';


List<dynamic> loginData = [];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passToggle = true;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

      final NotificationHelper notificationHelper = NotificationHelper();


  @override
  void initState() {
    super.initState();

    // Schedule a daily notification at 9:00 AM
    // NotificationService().scheduleDailyNotification(9, 0);
    
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backgroundColor,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(10)),
              Text(
                "Login",
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  "images/focus_topnav.jpg",
                  width: 250,
                  height: 250,
                ),
              ),
              SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: usernameController,
                  // maxLength: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Enter Name"),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (val) {
                    if (val!.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=/^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)) {
                      return "Please enter your Name";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: passToggle ? true : false,
                    maxLength: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Password"),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (passToggle == true) {
                            passToggle = false;
                          } else {
                            passToggle = true;
                          }
                          setState(() {});
                        },
                        child: passToggle
                            ? Icon(CupertinoIcons.eye_slash_fill)
                            : Icon(CupertinoIcons.eye_fill),
                      ),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  )),
              SizedBox(height: 10),
              Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.all(10),
                        ),
                        onPressed: ()async {
                          logincall(
                            usernameController.text,
                            passwordController.text,
                          );
                          //  Show a notification when the button is pressed
              NotificationService.showNotification(
                'Test Notification',
                'This is a test notification from the NotificationService class.',
              );
              //  await notificationHelper.showImmediateNotification();
               await notificationHelper.scheduleDailyNotification(); 
              //  await notificationHelper.showImmediateNotification();
            print('Daily notification scheduled.');
                        },
                        child: Text("Login",
                            style: TextStyle(
                              color: AppColors.backgroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                      ))),
              // SizedBox(height: 10),
              // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              //   Text(
              //     "Dont have any account?",
              //     style: TextStyle(
              //       color: Colors.black54,
              //       fontSize: 16,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              //   TextButton(
              //       onPressed: () {

              //         // Navigator.push(
              //         //     context,
              //         //     MaterialPageRoute(
              //         //       builder: (context) =>SignUpScreen (3),
              //         //     ));
              //       },
              //       child:
              //       Text("Create Account",
              //           style: TextStyle(
              //             color: Colors.blue,
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ))
              //           ),
              // ])
            ],
          ),
        ),
      ),
    );
  }

  void logincall(String username, String password) async {
    await LoginService().login(username, password, context);

// var result = json.decode(response.body);

    usernameController.clear();
    passwordController.clear();
    // Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }
}
