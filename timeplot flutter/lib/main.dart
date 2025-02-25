

import 'package:flutter/material.dart';

import 'package:focusontime/modules/lms/screens/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:focusontime/services/notification_service.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

Future<void> main() async {
// for notification
 WidgetsFlutterBinding.ensureInitialized();

   // Initialize time zone data
  tz.initializeTimeZones();

  // Get the "Asia/Kolkata" time zone
  final kolkata = tz.getLocation('Asia/Kolkata');

  // Get the current system local time
  final now = DateTime.now(); // Get the system time in UTC
  final localTime = tz.TZDateTime.from(now, kolkata); // Convert system UTC time to Asia/Kolkata time zone

  // Format the local time to 24-hour format
  String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(localTime);

  // Print the formatted local time
  print("Current Local Time (Asia/Kolkata): $formattedTime");
  final notificationService = NotificationService();
 notificationService.testImmediateNotification();
 await notificationService.testScheduledNotification(); // Call here
  notificationService.scheduleDailyNotifications();

//  await NotificationService().initNotifications();

 
  // Load environment variables from the appropriate .env file
  await dotenv.load(fileName: ".env");
  runApp(
// MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => LoadingProvider()),
//       ],
//       child: MyApp(),
// )
   const MyApp()
  );
  
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //  theme: ThemeData.light(useMaterial3: true),
       home: LoginScreen(),
      // home: Stack(
      //   children: [
      //     LoginScreen(),
      //     GlobalLoader(), // This keeps the loader available in the whole app
      //   ],
      // ),
      
      // routes: {
      //   '/': (context) =>  welcomeScreen(),
      //   '/dashboard': (context) => const welcomeScreen(),
       
      // },
    );
  }
}

