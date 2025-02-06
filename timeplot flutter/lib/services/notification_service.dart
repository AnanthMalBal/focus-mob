import 'dart:io'; 
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

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

  /// Schedule notifications for 11 AM and 4 PM daily
Future<void> scheduleDailyNotifications() async {
  await requestExactAlarmPermission();

  if (!await Permission.scheduleExactAlarm.isGranted) {
    print("Exact alarm permission is not granted. Cannot schedule notifications.");
    return;
  }

  final time11am = _nextInstanceOfTime(14, 20); // Should return IST time
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

// testScheduledNotification

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



// for debugScheduledNotifications

Future<void> debugScheduledNotifications() async {
  final pending = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  print("Pending notifications: ${pending.length}");
  for (var notification in pending) {
    print("Notification ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}");
  }
}


// testImmediateNotification

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

