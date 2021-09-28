import 'package:flutter/material.dart';
import 'package:wearamask/widgets/mainHome.dart';
import 'package:wearamask/widgets/newUserHome.dart';
import './widgets/mapPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await PushNotifications().initState();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alpha',
      home: HomePage(),
      routes: {
        MapPage.routeName: (context) => MapPage(),
        MainHome.routeName: (context) => MainHome(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: NewUserHomePage(),
    );
  }
}
