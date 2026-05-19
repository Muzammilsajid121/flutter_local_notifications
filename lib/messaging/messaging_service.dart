import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    //-- Initialize timezone database
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    //-- Initialize notification settings
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    
    const DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    
    await _notificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {},
    );

    await _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>() ?.requestNotificationsPermission();

  }

  Future<void> scheduleDailyNotification({
    required String title,
    required String body,
    required TimeOfDay time,
    int id = 0,
  }) async {
    // Cancel any existing notification with same id
    await _notificationsPlugin.cancel(id);

    // Create notification details
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'daily_notification_channel',
      'Daily Notifications',
      channelDescription: 'Channel for daily reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Schedule notification for today at specified time
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint('Daily notification scheduled for ${time.hour}:${time.minute} || Current time is ${DateTime.now()} ');
    debugPrint('Scheduled Date String: ${scheduledDate.toString()}');
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  //-- Method to schedule notification for Specific Time
  Future<void> schedule8PMNotification() async {
    await scheduleDailyNotification(
      title: 'Daily Reminder',
      body: 'This is your daily notification!',
      time: const TimeOfDay(hour: 17, minute: 45), // 8:00 PM
      id: 0,
    );
  }
  

  //-- Method to show notification in 10 seconds
  Future<void> showTestNotificationIn10Seconds() async {
  const androidDetails = AndroidNotificationDetails(
    'test_channel',
    'Test Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const platformDetails = NotificationDetails(android: androidDetails);

  final scheduledDate =  tz.TZDateTime.now(tz.local).add(const Duration(seconds: 300));

  await _notificationsPlugin.zonedSchedule(
    999,
    'Test Notification',
    'This notification should appear in 10 seconds',
    scheduledDate,
    platformDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,

  );
}

  //-- Method to show notification with no time || used this in cases like user fill form and send notfication etc
  Future<void> showNotficationUrgent() async {
  const androidDetails = AndroidNotificationDetails(
    'daily_reminders',
    'Daily Reminders',
    importance: Importance.max,
    priority: Priority.high,
    fullScreenIntent: true
  );

  const platformDetails = NotificationDetails(android: androidDetails);

  final scheduledDate =  tz.TZDateTime.now(tz.local).add(const Duration(milliseconds: 100));

  await _notificationsPlugin.zonedSchedule(
    999,
    'Test Notification',
    'Urgent Notifcation',
    scheduledDate,
    platformDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,

  );
}


 //--Exact ntofication
 Future<void> scheduleExactNotification({
  required String title,
  required String body,
  required TimeOfDay time,
  int id = 100,
}) async {
  await _notificationsPlugin.cancel(id);

  const androidDetails = AndroidNotificationDetails(
    'exact_notification_channel',
    'Exact Notifications',
    channelDescription: 'Exact time notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const iosDetails = DarwinNotificationDetails();

  const platformDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);

  final now = tz.TZDateTime.now(tz.local);

  tz.TZDateTime scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );

  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  await _notificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    scheduledDate,
    platformDetails,

    // 🔥 EXACT alarm
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

  );

  debugPrint('Exact notification scheduled at: $scheduledDate');
}

Future<void> scheduleExact8PMNotification() async {
  await scheduleExactNotification(
    title: 'Exact Reminder',
    body: 'This notification will fire EXACTLY on time',
    time: const TimeOfDay(hour: 16, minute: 28),
    id: 200,
  );
}


}