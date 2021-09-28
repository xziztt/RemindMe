import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerHome extends StatelessWidget {
  bool _isHomeConfirmed;
  final VoidCallback callback;
  DrawerHome(this._isHomeConfirmed, this.callback);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.black, Colors.white])),
              child: Center(
                child: Text(
                  "Options",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Change home'),
            onTap: () => callback(),
          )
        ],
      ),
    );
  }
}
