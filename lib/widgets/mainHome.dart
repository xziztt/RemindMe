import 'package:flutter/material.dart';

class MainHome extends StatefulWidget {
  static const routeName = '/home-confirmed';

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.purple, Colors.blue])),
      ),
    );
  }
}
