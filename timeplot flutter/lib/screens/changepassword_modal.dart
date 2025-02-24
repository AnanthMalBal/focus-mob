import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusontime/screens/colors.dart';
import 'package:focusontime/services/passwordservice.dart';

final PasswordService passwordservice = PasswordService();
void ForgetPasswordModal(BuildContext context) {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Define a GlobalKey for the Form

  // First Modal - Email Input
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return SizedBox(
            height: 400, // Fixed height for the modal
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SingleChildScrollView(
                // Wrap the Column in a scrollable widget
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Enter Email",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                  
                    Form(
                      key: _formKey, // Attach the key to the Form
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType
                            .emailAddress, // Helps with email input
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email"; // ✅ Required field validation
                          }
                          if (!RegExp(
                                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                              .hasMatch(value)) {
                            return "Please enter a valid email"; // ✅ Email format validation
                          }
                          return null;
                        },
                        onChanged: (value) {
          setModalState(() {
            _formKey.currentState!.validate(); // Revalidate dynamically
          });
        },
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 150, // Button width
                      child: ElevatedButton(
                        onPressed: () {
                          // if (emailController.text.isNotEmpty) {
                          //   sendEmailForVerification(
                          //       emailController.text, context);
                          // } else {
                          //   showdialog(context, "Please Enter valid Email");
                          // }
                          if (_formKey.currentState!.validate()) {
                            print("Valid Email: ${emailController.text}");
                          }
                          sendEmailForVerification(
                              emailController.text, context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

sendEmailForVerification(email, dynamic context) async {
  print("email:$email");
  await passwordservice.sendEamil(email, context);
  // Close the first modal
  //  Navigator.pop(context);
}



void ChangePasswordModal(BuildContext context) {
  final _formKey = GlobalKey<FormState>(); // ✅ Form key for validation
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passToggle = true; // Password visibility toggle

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) { // ✅ Using setModalState for updates
          return SizedBox(
            height: 500, // Fixed height for the modal
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey, // ✅ Attach form key
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Enter OTP and Password",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),

                      // ✅ OTP Field with Validation
                      Container(
                        width: 500,
                        child: TextFormField(
                          controller: otpController,
                          // keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: InputDecoration(
                            labelText: "OTP",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.verified),
                            counterText: "", // Hides character counter
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter OTP"; // ✅ Required field validation
                            }
                            if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                              return "Enter a valid 4-6 digit OTP"; // ✅ OTP format validation
                            }
                            return null;
                          },
                          onChanged: (value) {
          setModalState(() {
            _formKey.currentState!.validate(); // Revalidate dynamically
          });
        },
                        ),
                      ),
                      SizedBox(height: 16),

                      // ✅ Password Field with Validation & Visibility Toggle
                      Container(
                        width: 500,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: passToggle,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: InkWell(
                              onTap: () {
                                setModalState(() { // ✅ Update UI on tap
                                  passToggle = !passToggle;
                                });
                              },
                              child: Icon(
                                passToggle ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a password"; // ✅ Required field validation
                            }
                            // if (value.length < 10) {
                            //   return "Password must be at least 6 characters"; // ✅ Password length validation
                            // }
                            if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                              return "Include at least 1 uppercase & 1 number"; // ✅ Strong password validation
                            }
                            return null;
                          },
                            onChanged: (value) {
          setModalState(() {
            _formKey.currentState!.validate(); // Revalidate dynamically
          });
                            }
                        ),
                      ),
                      SizedBox(height: 20),

                      // ✅ Submit Button with Validation Check
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // ✅ If all fields are valid, proceed
                              String otp = otpController.text;
                              String password = passwordController.text;
                              changePassword(otp, password, context);                             
                            }

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Change Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

//                     // OTP Input Boxes
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: List.generate(6, (index) {
//                         return Expanded( // Ensures each OTP box takes up equal space
//                           child: Container(
//                             margin: EdgeInsets.symmetric(horizontal: 8),
//                             height: 50, // Fixed height for the OTP box
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey, // Border color
//                                 width: 1.5, // Border width
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: TextField(
//                               controller: otpController, // You can create separate controllers for each box if needed
//                               maxLength: 1, // Limit to 1 digit
//                               textAlign: TextAlign.center,
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 counterText: "", // Hide the counter text
//                                 border: InputBorder.none, // Remove the default border
//                                 contentPadding: EdgeInsets.all(10), // Padding inside the text field
//                               ),
//                               style: TextStyle(fontSize: 24), // Increase font size for better readability
//                               onChanged: (value) {
//                                 if (value.length == 1 && index < 5) {
//                                   FocusScope.of(context).nextFocus(); // Move to the next box
//                                 }
//                               },
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//

changePassword(otp, password, context) async {
  print("otp:$otp,password:$password");
  await passwordservice.updatePassword(otp, password, context);
  // Navigator.pop(context);
}
