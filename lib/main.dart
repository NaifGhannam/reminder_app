import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  runApp(MyApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: ReminderScreen(),
      routes: {
        '/details': (context) => ReminderDetailScreen(),
      },
    );
  }
}

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: details.payload,
        );
      },
    );
  }

  Future<void> _scheduleNotification(String title, TimeOfDay time) async {
    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    final tz.TZDateTime tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      title,
      tzDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: title,
    );
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveReminder() {
    final title = _titleController.text;
    if (title.isEmpty || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter title and pick time')),
      );
      return;
    }

    _scheduleNotification(title, _selectedTime!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder scheduled')),
    );

    _titleController.clear();
    setState(() {
      _selectedTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Reminder')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Reminder Title'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickTime,
              child: Text(_selectedTime == null
                  ? 'Pick Time'
                  : 'Picked: ${_selectedTime!.format(context)}'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _saveReminder,
              child: Text('Schedule Reminder'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReminderDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? reminderTitle =
    ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(title: Text('Reminder Detail')),
      body: Center(
        child: Text(
          reminderTitle ?? 'No Reminder Data',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
