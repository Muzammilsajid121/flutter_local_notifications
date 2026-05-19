import 'package:flutter/material.dart';
import 'package:local_notifications_app/home_screen.dart';
import 'package:local_notifications_app/messaging/messaging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  //-- Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Notification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}