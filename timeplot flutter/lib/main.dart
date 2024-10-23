
import 'package:flutter/material.dart';
import 'package:timeplot_flutter/screens/login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timeplot_flutter/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz; // For timezone operations
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // Load environment variables from the appropriate .env file
  await dotenv.load(fileName: ".env"); 
// WidgetsFlutterBinding.ensureInitialized();

// //   // Initialize the notification service
  
// WidgetsFlutterBinding.ensureInitialized();
//  await NotificationService.initialize();

//  tz.initializeTimeZones();
//   final String timeZone = 'Asia/Kolkata';

// // Set the local timezone
// final location = tz.getLocation(timeZone);
// final tz.TZDateTime now = tz.TZDateTime.now(location);

// // You can now use this `now` variable to schedule the notification correctly in the Asia/Kolkata timezone
// print('Local time in Kolkata: $now');
  
//   NotificationHelper notificationHelper = NotificationHelper();
//   // await notificationHelper.requestPermission(); // Request notification permission on Android 13+
//    await notificationHelper.scheduleDailyNotification(); // Schedule the daily notification
// await notificationHelper.showImmediateNotification();
// //  await notificationHelper.scheduleNotificationForNextMinute();
   
  runApp(const MyApp());
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

void listTimeZones() {
  final locations = tz.timeZoneDatabase.locations.keys;
  for (var location in locations) {
    print(location);
  }
}