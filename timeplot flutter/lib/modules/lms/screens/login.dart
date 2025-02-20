import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:focusontime/screens/colors.dart';
import 'package:focusontime/screens/logo_loader.dart';

import 'package:focusontime/services/loginservice.dart';
import 'package:focusontime/services/notification_service.dart';


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
   final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(
        children: 
        [
          SingleChildScrollView(
          child: SafeArea(
             child: Form(
              key: _formKey,
              
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(10)),
                // Text(
                //   "Login",
                //   style: TextStyle(
                //     color: AppColors.textColor,
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    "images/focus_topnav.jpg",
                    width: 250,
                    height: 250,
                  ),
                ),
                SizedBox(height: 10),
        // Username Field
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: usernameController,
                    // maxLength: 10,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey), // Normal border
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2), // Blue when focused
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2), // Red on error
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2), // Red when focused on error
                        ),
                      label: Text("User Name"),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (val) {
                      if (val!.isEmpty 
                      // ||
                          // !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=/^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              // .hasMatch(val)
                              ) {
                        return "Please enter your Name";
                      }
                      return null;
                    },
                  ),
                ),
                 // Password Field
                Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: passToggle ? true : false,
                      // maxLength: 10,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                         enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color:Colors.grey, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
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
                // Login Button
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
                          onPressed: 
                          () async {
                            if (_formKey.currentState!.validate()){
                              setState(() {
                  _isLoading = true; // ✅ Set loader only when the button is pressed
                });
                            logincall(usernameController.text,
                                passwordController.text, context);
                            }
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
        ),),
            // ✅ Full-Screen Loader (Keeps running if API is down)
      if (_isLoading)
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5), // Semi-transparent background
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LogoLoader(size: 100.0), // ✅ Loader
                  // SizedBox(height: 20),
                  // Text(
                  //   "Connecting to server...",
                  //   style: TextStyle(color: Colors.white, fontSize: 16),
                  // ),
                  // SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       _isLoading = false; // ❌ Stop loader manually if needed
                  //     });
                  //   },
                  //   child: Text("Cancel"),
                  // ),
                ],
              ),
            ),
          ),
        ),
      
    ]  ),
    );
  }

// method for loginapi
bool _isLoading = false; // Declare loading state
  void logincall(String username, String password, BuildContext context) async {
  
    String result = await LoginService().login(username, password, context);

// Decode the JSON response
    // Check if the response is a valid JSON object
    Map<String, dynamic> jsonResponse;

    try {
      jsonResponse = json.decode(result);
    } catch (e) {
      // If decoding fails, treat the response as a plain message
      jsonResponse = {
        'message': result, // Store the plain response message
      };
    }
    usernameController.clear();
    passwordController.clear();

    String message = jsonResponse['message'];
    bool isSuccess = message.contains("successfully");

    // Show Snackbar using SnackbarHelper
    showSnackbar(context, result, isSuccess: isSuccess);
    setState(() {
      _isLoading = false; // Hide loader after API response
    });
  }
}
