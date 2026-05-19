import 'package:flutter/material.dart';
import 'package:local_notifications_app/messaging/messaging_service.dart';
import 'package:local_notifications_app/widgets/reusable_elevated_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //-- notification service object--//
  final NotificationService _notificationService = NotificationService();

  //-- to check wether notification is scheduled or not--//
  bool _isScheduled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text('Notifications Demo'), centerTitle: true,),

      body: Center(
        child: Column(
          spacing: 6,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //--icons
            Icon( Icons.notifications_active,  size: 80,   color: Colors.blue,  ),
            Text('Daily Notification', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
           
            //--schedule notification button
            ReusableElvatedButton(
              text: "Schedule Daily Notification",
              onPressed: () async {
                await _notificationService.schedule8PMNotification();
                setState(() { _isScheduled = true; });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar( content: Text('Daily notification scheduled successfully'), duration: Duration(seconds: 2),),);
              },
            ),
           
            //-- Test 10 second notification button
            ReusableElvatedButton(
              text: "Test Notification (10s)",
              onPressed: () async {
                debugPrint("Test Notfication Started");
                await _notificationService.showTestNotificationIn10Seconds();
                ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Test notification will appear in 10 seconds'), ), );
              },
            ),

            //-- Show notification Urgent button
            ReusableElvatedButton(
              text: "Urgent Notfication",
              onPressed: () async {
                debugPrint("Urgent Notfication Started");
                await _notificationService.showNotficationUrgent();
              },
            ),

            //--Show  exact notfication at 8 PM
            ReusableElvatedButton(
              text: "Schedule EXACT Notification",
              onPressed: () async {
                await _notificationService.scheduleExact8PMNotification();
                ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Exact notification scheduled')),
                );
              },
            ),

            //-- cancell all notification button
            ReusableElvatedButton(
              text: "Cancel All Notfications",
              onPressed: () async {
                await _notificationService.cancelAllNotifications();
                setState(() {_isScheduled = false;  });
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(  content: Text('All notifications cancelled!'),  duration: Duration(seconds: 2),  ), );
              },
            ),


            // -- to show that notfication is scheduled--//
            SizedBox(height: 20),
            if (_isScheduled) Text('✓ Notification scheduled', style: TextStyle(color: Colors.green, fontSize: 16),),  


          ],
        ),
      ),
    );
  }
}