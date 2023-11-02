import 'package:flutter/material.dart';
import 'welcomePage.dart';
import 'profilePage.dart';
import 'orderPage.dart';
import "package:awesome_notifications/awesome_notifications.dart";

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'scheduled',
          channelName: "basic_notifications",
          channelDescription: "Notification channel for basic tests",
        ),
      ],
      debug: true);
  runApp(MyApp());
}

Future<void> showNotificationPermissionDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Allow Notifications?'),
        content: Text(
            'Do you want to allow notifications from this app? They allow you to be notified when your next order is placed'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              AwesomeNotifications().requestPermissionToSendNotifications();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyBottomNavigationBar(),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    WelcomePage(),
    OrderPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showNotificationPermissionDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Welcome',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
