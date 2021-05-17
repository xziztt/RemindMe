import 'package:flutter/material.dart';

class DrawerHome extends StatelessWidget {
  bool _isHomeConfirmed;
  DrawerHome(this._isHomeConfirmed);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Change home'),
            onTap: () => {},
          )
        ],
      ),
    );
  }
}
