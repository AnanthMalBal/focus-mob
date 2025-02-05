// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/flutter_logo');

//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   static Future<void> showNotification(String title, String body) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'default_channel_id',
//       'Default Channel',
//       channelDescription: 'This is the default channel for notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//     );
//   }
// }




// class NotificationHelper {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Constructor
//   NotificationHelper() {
//     _initialize();
//   }

//   // Initialize the plugin
//   Future<void> _initialize() async {
//     tz.initializeTimeZones();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/flutter_logo');

//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//     // Check notification permissions after initialization
//   bool? isGranted = await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//       ?.areNotificationsEnabled();

//   if (isGranted == false) {
//     // Request permission or inform the user
//     print('Notifications are not enabled, please enable them in settings.');
//   }
//   }

//   // Schedule daily notification at 10 AM
//   Future<void> scheduleDailyNotification() async {
//     // Use your timezone here
//     final tz.TZDateTime scheduledTime = _nextInstanceOfSpecificTime();

//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'daily_notification_channel_id',
//       'Daily Notifications',
//       channelDescription: 'This channel is for daily notifications.',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Mark your attendance',
//       'Please remember to mark your attendance for the day!',
//       scheduledTime,
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );

//     print('Notification scheduled for: $scheduledTime');
//   }

//   // Helper function to get next instance of 10 AM in local timezone
//   tz.TZDateTime _nextInstanceOfTenAM() {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime tenAM = tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);

//     if (tenAM.isBefore(now)) {
//       tenAM = tenAM.add(const Duration(days: 1));
//     }
    
//     print('Scheduled daily notification for: $tenAM');
     
//     return tenAM;
//   }


//   // Helper function to get the next instance in one minute
//    tz.TZDateTime _nextInstanceInOneMinute() {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local); // Get the current local time
//     final tz.TZDateTime nextMinute = now.add(const Duration(minutes: 1)); // Add one minute to current time

//     // Log the current time and the scheduled time for one minute later
//     // print('Current Local Time: $now'); // Log the current local time
//     // print('Scheduled immediate notification for: $nextMinute'); // Log the scheduled time

//     return nextMinute; // Return the next scheduled time
//   }

//   // Show an immediate notification scheduled for the next minute
//   Future<void> showImmediateNotification() async {
//     final tz.TZDateTime scheduledTime = _nextInstanceInOneMinute(); // Get the next minute time

//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'immediate_notification_channel_id',
//       'Immediate Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       1, // Unique Notification ID
//       'Immediate Notification',
//       'This is a test notification scheduled for one minute later.',
//       scheduledTime, // Schedule for the next minute
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );

//     print('Immediate notification scheduled for: $scheduledTime'); // Log the scheduled time
//   }

// tz.TZDateTime _nextInstanceOfSpecificTime() {
//   final String timeZone = 'Asia/Kolkata';
//   final location = tz.getLocation(timeZone);
//   final tz.TZDateTime now = tz.TZDateTime.now(location); // Get local time

//   tz.TZDateTime specificTime = tz.TZDateTime(location, now.year, now.month, now.day, 10, 45); // 10:00 AM in Kolkata

//   // if (specificTime.isBefore(now)) {
//   //   specificTime = specificTime.add(const Duration(days: 1)); // Move to the next day if it's past 10:00 AM today
//   // }

//   print('Scheduled daily notification for Asia/Kolkata: $specificTime');
//   return specificTime;
// }


// }

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Initialize notifications
//   static Future<void> initialize() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/flutter_logo');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await _notificationsPlugin.initialize(initializationSettings);
//   }

//   // Show notification
//   static Future<void> showNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'attendance_channel_id',
//       'Attendance Reminder',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await _notificationsPlugin.show(
//       0,
//       'Attendance Reminder',
//       'Please mark your attendance!',
//       platformChannelSpecifics,
//     );
//   }

//   // Schedule notifications at 11 AM & 4 PM
//   static Future<void> scheduleNotifications() async {
//     await AndroidAlarmManager.periodic(
//         const Duration(hours: 24), 1, showNotification,
//         startAt: DateTime(DateTime.now().year, DateTime.now().month,
//             DateTime.now().day, 11, 0),
//         exact: true,
//         wakeup: true);

//     await AndroidAlarmManager.periodic(
//         const Duration(hours: 24), 2, showNotification,
//         startAt: DateTime(DateTime.now().year, DateTime.now().month,
//             DateTime.now().day, 16, 0),
//         exact: true,
//         wakeup: true);
//   }
// }


// notification_service.dart
import 'dart:io'; // Import for platform detection
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService() {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/flutter_logo');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Request exact alarm permission on Android 12+
 Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid) {
    if (await Permission.scheduleExactAlarm.isGranted) {
      print("Exact alarm permission already granted.");
    } else {
      try {
        // Open device settings where the user can manually allow exact alarms
        await openAppSettings();
      } catch (e) {
        print("Error opening exact alarm settings: $e");
      }
    }
  }
}

  /// Schedule notifications for 10 AM and 4 PM daily
Future<void> scheduleDailyNotifications() async {
  await requestExactAlarmPermission();

  if (!await Permission.scheduleExactAlarm.isGranted) {
    print("Exact alarm permission is not granted. Cannot schedule notifications.");
    return;
  }

  final time11am = _nextInstanceOfTime(11, 0); // Should return IST time
  final time4pm = _nextInstanceOfTime(16, 0); // Should return IST time

  print("Scheduling 11 AM notification at: $time11am (IST)");
  print("Scheduling 4 PM notification at: $time4pm (IST)");

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Attendance Reminder',
    'Please mark your attendance at 11 AM.',
    time11am,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'attendance_channel', 'Attendance Notifications',
        channelDescription: 'Channel for attendance reminders',
        importance: Importance.high,
        priority: Priority.high,
        
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    1,
    'Attendance Reminder',
    'Please mark your attendance at 4 PM.',
    time4pm,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'attendance_channel', 'Attendance Notifications',
        channelDescription: 'Channel for attendance reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );

  await debugScheduledNotifications();
}



// tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
//   tz.initializeTimeZones();

//   // Get the Asia/Kolkata time zone
//   final kolkata = tz.getLocation('Asia/Kolkata');

//   // Get the current system local time (in Asia/Kolkata time zone)
//   final now = DateTime.now(); // Get system time in UTC
//   final localTime = tz.TZDateTime.from(now, kolkata); // Convert system local time to Asia/Kolkata time zone

//   // Print the current local time for debugging
//   print("currentTime: ${localTime}");

//   // Format the local time to 24-hour format
//   String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(localTime);
//   print("Formatted Local Time (Asia/Kolkata): $formattedTime");

//   // Schedule for today at the given hour and minute using parsed year, month, day
//   var scheduledTime = tz.TZDateTime(tz.local, localTime.year, localTime.month, localTime.day, hour, minute);

//   // If the scheduled time has already passed today, move it to the next day
//   if (scheduledTime.isBefore(localTime)) {
//     // Move to the next day if time has passed
//     scheduledTime = scheduledTime.add(Duration(days: 1));
//   }

//   // Print the next scheduled time for debugging
//   print("Next scheduled time: ${scheduledTime.toLocal()}");

//   return scheduledTime;
// }

tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final kolkata = tz.getLocation('Asia/Kolkata'); // Get India timezone
  final now = tz.TZDateTime.now(kolkata); // Current IST time

  var scheduledTime = tz.TZDateTime(kolkata, now.year, now.month, now.day, hour, minute);

  // If the scheduled time has already passed today, move to the next day
  if (scheduledTime.isBefore(now)) {
    scheduledTime = scheduledTime.add(Duration(days: 1));
  }

  print("Next scheduled time (Asia/Kolkata): $scheduledTime"); // Debugging

  return scheduledTime;
}

Future<void> testScheduledNotification() async {
  tz.initializeTimeZones(); // Ensure timezones are initialized
  final kolkata = tz.getLocation('Asia/Kolkata'); // Set India timezone

  final now = tz.TZDateTime.now(kolkata); // Get current IST time
  final scheduledTime = now.add(Duration(minutes: 1)); // 1 min from now in IST

  print("Current Local Time (Asia/Kolkata): $now");
  print("Scheduled a test notification at: $scheduledTime (Asia/Kolkata)"); // Debugging

  await flutterLocalNotificationsPlugin.zonedSchedule(
    200,
    'Test Scheduled Notification',
    'This should appear in 1 minute!',
    scheduledTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'test_channel', 'Test Notifications',
        channelDescription: 'Test scheduled notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}
Future<void> debugScheduledNotifications() async {
  final pending = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  print("Pending notifications: ${pending.length}");
  for (var notification in pending) {
    print("Notification ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}");
  }
}

Future<void> testImmediateNotification() async {
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails('test_channel', 'Test Notifications',
          channelDescription: 'Channel for testing',
          importance: Importance.max,
          priority: Priority.high);

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    100,
    'Test Notification',
    'This is a test notification.',
    platformDetails,
  );
}

}