
import 'package:flutter/material.dart';
import 'package:focusontime/modules/lms/screens/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';







Future<void> main() async {
  // Load environment variables from the appropriate .env file
  await dotenv.load(fileName: ".env");
  runApp(


  const MyApp());
  // runApp(
  //   ChangeNotifierProvider(
  //     create: (context) => MenuProvider(),
  //     child: MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: LoginScreen(),
      // routes: {
      //   '/': (context) =>  welcomeScreen(),
      //   '/dashboard': (context) => const welcomeScreen(),
       
      // },
    );
  }
}

