import 'package:flutter/material.dart';
import "package:awesome_notifications/awesome_notifications.dart";

int selectedHour = 0;
int selectedMinute = 0;

@override
void initState() {}

class WelcomePage extends StatelessWidget {
  triggerNotification() async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'scheduled',
            title: 'Order Ready Notify!',
            body: 'Hey! We placed an Order for you! Verify it!'),
        schedule: NotificationCalendar(
            hour: selectedHour,
            minute: selectedMinute,
            timeZone: localTimeZone,
            repeats: true));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('Order Ready Notify'), backgroundColor: Colors.orange),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              _showTimePickerDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.orange, // Set the background color of the button
            ),
            child: Text('When do you want to be Notified?'),
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePickerDialog(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      selectedHour = pickedTime.hour;
      selectedMinute = pickedTime.minute;
      triggerNotification();
      print('Selected time: ${pickedTime.format(context)}');
    }
  }
}
