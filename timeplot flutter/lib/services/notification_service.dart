import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timeplot_flutter/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/flutter_logo');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      channelDescription: 'This is the default channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}


// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

// class NotificationService {
//   static final NotificationService _notificationService =
//       NotificationService._internal();

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   factory NotificationService() {
//     return _notificationService;
//   }

//   NotificationService._internal();

//   Future<void> initializeNotifications() async {
//     // Initialize the timezone package
//     tz.initializeTimeZones();

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/flutter_logo'); // Replace with your app icon

//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> scheduleDailyNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'attendance_channel_id',
//       'Attendance Notifications',
//       channelDescription: 'Channel for attendance notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Mark Attendance',
//       'It\'s time to mark your attendance!',
//       _nextInstanceOfTenAM(),
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   tz.TZDateTime _nextInstanceOfTenAM() {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime tenAM = tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);

//     if (tenAM.isBefore(now)) {
//       tenAM = tenAM.add(const Duration(days: 1));
//     }
//     return tenAM;
//   }
// }


// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timeplot_flutter/main.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Constructor
  NotificationHelper() {
    _initialize();
  }

  // Initialize the plugin
  Future<void> _initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/flutter_logo');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    // Check notification permissions after initialization
  bool? isGranted = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.areNotificationsEnabled();

  if (isGranted == false) {
    // Request permission or inform the user
    print('Notifications are not enabled, please enable them in settings.');
  }
  }

  // Schedule daily notification at 10 AM
  Future<void> scheduleDailyNotification() async {
    // Use your timezone here
    final tz.TZDateTime scheduledTime = _nextInstanceOfSpecificTime();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daily_notification_channel_id',
      'Daily Notifications',
      channelDescription: 'This channel is for daily notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Mark your attendance',
      'Please remember to mark your attendance for the day!',
      scheduledTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print('Notification scheduled for: $scheduledTime');
  }

  // Helper function to get next instance of 10 AM in local timezone
  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime tenAM = tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);

    if (tenAM.isBefore(now)) {
      tenAM = tenAM.add(const Duration(days: 1));
    }
    
    print('Scheduled daily notification for: $tenAM');
     
    return tenAM;
  }


  // Helper function to get the next instance in one minute
   tz.TZDateTime _nextInstanceInOneMinute() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local); // Get the current local time
    final tz.TZDateTime nextMinute = now.add(const Duration(minutes: 1)); // Add one minute to current time

    // Log the current time and the scheduled time for one minute later
    // print('Current Local Time: $now'); // Log the current local time
    // print('Scheduled immediate notification for: $nextMinute'); // Log the scheduled time

    return nextMinute; // Return the next scheduled time
  }

  // Show an immediate notification scheduled for the next minute
  Future<void> showImmediateNotification() async {
    final tz.TZDateTime scheduledTime = _nextInstanceInOneMinute(); // Get the next minute time

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'immediate_notification_channel_id',
      'Immediate Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1, // Unique Notification ID
      'Immediate Notification',
      'This is a test notification scheduled for one minute later.',
      scheduledTime, // Schedule for the next minute
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print('Immediate notification scheduled for: $scheduledTime'); // Log the scheduled time
  }

tz.TZDateTime _nextInstanceOfSpecificTime() {
  final String timeZone = 'Asia/Kolkata';
  final location = tz.getLocation(timeZone);
  final tz.TZDateTime now = tz.TZDateTime.now(location); // Get local time

  tz.TZDateTime specificTime = tz.TZDateTime(location, now.year, now.month, now.day, 10, 45); // 10:00 AM in Kolkata

  // if (specificTime.isBefore(now)) {
  //   specificTime = specificTime.add(const Duration(days: 1)); // Move to the next day if it's past 10:00 AM today
  // }

  print('Scheduled daily notification for Asia/Kolkata: $specificTime');
  return specificTime;
}


}// Helper function to get the next instance of 9:54 AM in local timezone



// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationHelper {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Constructor
//   NotificationHelper() {
//     _initialize();
//   }

//   // Initialize the notification plugin and time zones
//   void _initialize() {
//     // Initialize time zones
//     tz.initializeTimeZones();

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/flutter_logo'); // Your app icon

//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   // Schedule a notification for the next minute
//   Future<void> scheduleNotificationForNextMinute() async {
//     final tz.TZDateTime scheduledTime = _nextInstanceInOneMinute(); // Get next minute in local timezone

//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'immediate_notification_channel_id',
//       'Immediate Notifications',
//       channelDescription: 'This channel is for immediate notifications.',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics); // Corrected variable name

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       1, // Unique Notification ID for this immediate notification
//       'Immediate Notification',
//       'This notification will appear in 1 minute!',
//       scheduledTime, // Schedule for the next minute
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );

//     // Log the scheduled time
//     print('Notification scheduled for next minute: $scheduledTime');
//   }

//   // Helper function to get the next instance in one minute
//   tz.TZDateTime _nextInstanceInOneMinute() {
//     // Get current time in local timezone
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local); 

//     // Calculate the next minute
//     final tz.TZDateTime nextMinute = now.add(const Duration(minutes: 1)); 

//     // Log both the current time and the next scheduled time
//     print('Current Local Time1: $now'); // Log the current local time
//     print('Scheduled immediate notification for1: $nextMinute'); // Log the scheduled time

//     return nextMinute; // Return the scheduled time for the next minute
//   }
// }