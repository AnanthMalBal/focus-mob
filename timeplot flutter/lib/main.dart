
import 'package:flutter/material.dart';

import 'package:timeplot_flutter/screens/login.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timeplot_flutter/services/notification_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();

  // Initialize the notification service
  await NotificationService.initialize();



  
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
