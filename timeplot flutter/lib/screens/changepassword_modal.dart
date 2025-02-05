import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusontime/screens/appbar.dart';
import 'package:focusontime/screens/colors.dart';
import 'package:focusontime/services/passwordservice.dart';

final PasswordService passwordservice = PasswordService();
void ForgetPasswordModal(BuildContext context) {
  TextEditingController emailController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
              child: SingleChildScrollView( // Wrap the Column in a scrollable widget
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Enter Email",
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: 500, // Set a fixed width for the text field
                      child: TextField(
                        controller: emailController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 150, // Button width
                      child: ElevatedButton(
                        onPressed: () {
                          if (emailController.text.isNotEmpty) {
                            sendEmailForVerification(
                                emailController.text, context);
                          } else{
                           showdialog(context,"Please Enter valid Email");
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

 sendEmailForVerification(email, dynamic context)async {
  print("email:$email");
   await passwordservice.sendEamil(email,context);
   // Close the first modal
    //  Navigator.pop(context);

    
 }



 void ChangePasswordModal(BuildContext context) {
  TextEditingController otpController = TextEditingController(); 
  TextEditingController passwordController = TextEditingController();
  
bool passToggle = true;
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
            height: 500, // Fixed height for the modal
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SingleChildScrollView( // Wrap Column in SingleChildScrollView
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Enter OTP and Password",
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: 500, // Set a fixed width for the text field
                      child: TextField(
                        controller: otpController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: "OTP",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    

                    SizedBox(height: 16),
                    Container(
                      width: 500, // Set a fixed width for the text field
                      child: TextField(
                        controller: passwordController,
                        obscureText: passToggle ? true : false,
                        textAlign: TextAlign.center,
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
                          // setState(() {});
                        },
                        child: passToggle
                            ? Icon(CupertinoIcons.eye_slash_fill)
                            : Icon(CupertinoIcons.eye_fill),
                      ),
                    ),
                    
                      ),
                    ),
                    
                   
                    SizedBox(height: 20),
                    SizedBox(
                      width: 250, // Button width
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle password change logic here
                          String otp = otpController.text; 
      String password = passwordController.text;
                          changePassword(otp,password,context);
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


changePassword(otp,password, context) async{

  
  print("otp:$otp,password:$password");
  await passwordservice.updatePassword(otp,password,context);
  // Navigator.pop(context);
}