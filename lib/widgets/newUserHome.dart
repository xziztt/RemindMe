import 'package:flutter/material.dart';
import 'package:wearamask/widgets/mapPage.dart';
import '../theming/homePageTheme.dart';

class NewUserHomePage extends StatelessWidget {
  MediaQueryData queryData;

  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: null,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.red, Colors.purple])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                /*decoration: BoxDecoration(
                    color: Colors.white,
                    gradient:
                        LinearGradient(colors: [Colors.purple, Colors.red])),
                */
                child: Text(
              "TITLE HERE",
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: queryData.size.height / 2,
            ),
            Center(
                child: Container(
              /*decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),*/
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  color: Colors.white,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(MapPage.routeName),
                  child: Text("Add new home"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            )),
          ],
        ),
        //child: CustomPaint(
        // painter: CirclePaint(),
      ),
    );
  }
}
