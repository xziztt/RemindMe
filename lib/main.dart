import 'package:flutter/material.dart';
import 'package:wearamask/widgets/mainHome.dart';
import 'package:wearamask/widgets/newUserHome.dart';
import './widgets/mapPage.dart';

void main() {
  runApp(MyApp());
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
