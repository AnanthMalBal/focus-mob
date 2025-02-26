import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusontime/l10n/app_localizations.dart';
import 'package:focusontime/provider/locale_provider.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:focusontime/screens/colors.dart';
import 'package:focusontime/services/loginservice.dart';
import 'package:provider/provider.dart';

List<dynamic> loginData = [];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key,});
   

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
    _loadData();
  }

// for refresh
  Future<void> _refreshData() async {
    if (!mounted) return;
    setState(() {
      usernameController.text = "";
      passwordController.text = "";
      _isLoading = true;
    });
    await _loadData();
     if (mounted) {
      setState(() {
        _isLoading = false; // ✅ Stop loading after data loads
      });
    }
  }

  Future<void> _loadData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate API call
    setState(() {
      _isLoading = false; // Data loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!; // Access translations
    final localeProvider = Provider.of<LocaleProvider>(context);
    String selectedLanguage = localeProvider.locale.languageCode;
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text(appLoc.login),
      //   actions: [
      //     // Language Toggle
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 10),
      //       child: CupertinoSlidingSegmentedControl<String>(
      //         groupValue: selectedLanguage,
      //         onValueChanged: (String? value) {
      //           if (value != null) {
      //             localeProvider.setLocale(Locale(value));
      //           }
      //         },
      //         children: const {
      //           'en': Padding(padding: EdgeInsets.all(8), child: Text('EN')),
      //           'ta': Padding(padding: EdgeInsets.all(8), child: Text('தமிழ்')),
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(), // ✅ Ensures it's scrollable
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
                          borderSide:
                              BorderSide(color: Colors.grey), // Normal border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2), // Blue when focused
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red, width: 2), // Red on error
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red,
                              width: 2), // Red when focused on error
                        ),
                        label: Text(appLoc.username),
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
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          label: Text(appLoc.password),
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
                            //           onPressed:
                            //           () async {
                            //             if (_formKey.currentState!.validate()){
                            //               setState(() {
                            //   _isLoading = true; // ✅ Set loader only when the button is pressed
                            // });
                            //             logincall(usernameController.text,
                            //                 passwordController.text, context);
                            //             }
                            //           },
                            onPressed: _isLoading
                                ? null // ✅ Disable button while loading
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isLoading =
                                            true; // ✅ Show loader inside button
                                      });
                                      // Simulate API call
                                      String apiResponse = await logincall(
                                        usernameController.text,
                                        passwordController.text,
                                        context,
                                      );
                                      // ✅ Parse response to check success/failure
                                      bool isSuccess =
                                          apiResponse.contains("successfully");

                                      if (!isSuccess) {
                                        // If login fails, keep "Logging in..." for 2 more seconds
                                        await Future.delayed(
                                            Duration(seconds: 2));
                                      }

                                      setState(() {
                                        _isLoading =
                                            false; // ✅ Hide loader after login completes
                                      });
                                    }
                                  },
                            child: _isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              10), // Space between loader and text
                                      Text(
                                        "Logging in...",
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(appLoc.login,
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
        ),
      ),
    );
  }

// method for loginapi
  bool _isLoading = false; // Declare loading state
  Future<String> logincall(
      String username, String password, BuildContext context) async {
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
    return message;
  }
}
