import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Push Notification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FlutterLocalNotificationsPlugin localNotifications;

  @override
  void initState() {
    super.initState();

    localNotifications = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // Uncomment if targeting iOS
      // iOS: IOSInitializationSettings(),
    );

    // Initialize the notifications
    localNotifications.initialize(
      initializationSettings,
      // _onSelectNotification: _onSelectNotification,
    );

    _createNotificationChannel(); // Create the notification channel
  }

  void _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_channel_id', // Unique channel ID
      'Local Notification', // Descriptive channel name
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    try {
      await localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } catch (e) {
      print("Error creating notification channel: $e");
    }
  }

  Future<void> _onSelectNotification(String? payload) async {
    if (payload != null) {
      print("Notification tapped with payload: $payload");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Notification Tapped"),
          content: Text("Payload: $payload"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      print("Notification tapped with no payload");
    }
  }

  void _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Ensure this matches the channel ID
      'Local Notification',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    try {
      await localNotifications.show(
        0,
        'Hello',
        'This is a notification message',
        platformChannelSpecifics,
        payload: 'Notification payload', // Optional payload
      );
    } catch (e) {
      print("Error showing notification: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: const Text("Click the Notification Button to Receive a Message"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNotification,
        child: const Icon(Icons.notifications),
      ),
    );
  }
}
