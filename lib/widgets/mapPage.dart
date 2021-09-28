import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wearamask/widgets/mainHome.dart';
import '../drawer/drawerHome.dart';
import 'dart:math' show cos, sqrt, asin;
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  static const routeName = '/map-page';
  @override
  _MapPageState createState() => _MapPageState();
}

bool _isHomeConfirmed = false;
Future<bool> isFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool _isHomeSet = prefs.getBool('_isHomeConfirmed');
  if (_isHomeSet != null && !_isHomeSet) {
    prefs.setBool('_isFirstTime', false);
    return false;
  } else {
    prefs.setBool('_isFirstTime', false);
    return true;
  }
}

Timer timer;
double distanceBetweenPoints = 0;
bool _haveNotified = false;
TextEditingController distanceController,reminderController;
String reminderText;
SharedPreferences prefs;

class _MapPageState extends State<MapPage> {
  double minDistanceFromHome = 20.000;
  showNotification() async {
    final androidNotification = new AndroidNotificationDetails(
        'id', 'cname', 'cdesc',
        priority: Priority.high, importance: Importance.max);
    var platform =
        new NotificationDetails(android: androidNotification, iOS: null);
    await flutterLocalNotificationsPlugin.show(
        0, 'Flutter devs', 'ARE YOU WEARING A MASK ?', platform,
        payload: 'REMINDER!');
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Set<Marker> _myMarkers = {};
  Position position;
  bool _isMarkerSet = false;
  LatLng currentlySelectedPositionOnMap;
  GoogleMapController googleMapController;
  
  //final LatLng _center = const LatLng(45.521563, -122.677433);
  Location location = Location();

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    setState(() {
      distanceBetweenPoints = (12742 * asin(sqrt(a)));
    });

    if (distanceBetweenPoints > 20.00 && !_haveNotified) {
      _haveNotified = !_haveNotified;
      showNotification();
      //showNotification();
    }
  }

  @override
  void initState() {
    super.initState();

    isHomeSet();
    print("hereeee");

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: null);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getCurrentLocation());
  }

  void dispose(){
    distanceController.dispose();
    reminderController.dispose();
    super.dispose();
  }



  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {}));
  }

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  void getCurrentLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    print(currentPosition.latitude);
    print(currentPosition.longitude);
    _isHomeConfirmed
        ? calculateDistance(
            currentPosition.latitude,
            currentPosition.longitude,
            currentlySelectedPositionOnMap.latitude,
            currentlySelectedPositionOnMap.longitude)
        : () {};
    setState(() {
      position = currentPosition;
    });
  }

  void homeConfirmed() {
    setState(() {
      _setHomeTrue();
      print("home is confirmed");
    });
  }

  _setHome(bool val) {
    _isHomeConfirmed = val;
  }

  _setHomeTrue() async {
    _isHomeConfirmed = true;
    SharedPreferences sprefs = await SharedPreferences.getInstance();
    sprefs.setBool('_isHomeConfirmed', true);
  }

  _setHomeFalse() async {
    _isHomeConfirmed = false;
    SharedPreferences sprefs = await SharedPreferences.getInstance();
    sprefs.setBool('_isHomeConfirmed', false);
  }

  void addMarkerOnClick(LatLng currentlySelectedPosition) {
    print('inside add function');
    print(currentlySelectedPosition.latitude);
    print(currentlySelectedPosition.longitude);
    setState(() {
      _myMarkers.clear();
      _myMarkers.add(Marker(
          markerId: MarkerId('Home'),
          position: currentlySelectedPosition,
          infoWindow: InfoWindow(title: 'Home'),
          icon: BitmapDescriptor.defaultMarker));
    });

    print(_myMarkers.length);
  }

  isHomeSet() async {
    print("inside is home set");
    var _isHomeSet = prefs.getBool('_isHomeConfirmed');
    print("isHomeSet called");
    if (_isHomeSet != null && !_isHomeSet) {
      print("home set to isHomeSet");
      _isHomeConfirmed = _isHomeSet;
    } else {
      _isHomeConfirmed = false;
      print("home set to false");
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceQuery = MediaQuery.of(context);
    BuildContext scaffoldContext = context;
    return Scaffold(
      drawer: _isHomeConfirmed
          ? DrawerHome(
              _isHomeConfirmed,
              _setHomeFalse,
            )
          : null,
      appBar: _isHomeConfirmed
          ? AppBar(
              title: Text(distanceBetweenPoints.toString()),
              backgroundColor: Colors.black,
              actions: [
                  IconButton(
                      icon: Icon(Icons.notification_important),
                      onPressed: showNotification),
                  PopupMenuButton(
                      onSelected: (selectedValue) {
                        if (selectedValue == 0) {
                          setState(() {
                            _setHome(false);
                          });
                        }
                        if (selectedValue == 1) {
                          setState(() {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: distanceController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "Enter the distance"),
                                        ),
                                        TextField(
                                          controller: reminderController,
                                          onSubmitted: (data){
                                            reminderText = reminderController.text;
                                          },
                                          decoration: InputDecoration(
                                            hintText: "What do you want to be reminded about ?"
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  /*ADD LOGIC TO CHANGE DISTANCE*/
                                });
                          });
                        }
                      },
                      itemBuilder: (_) => [
                            PopupMenuItem(
                              child: Text('Change Home'),
                              value: 0,
                            ),
                            PopupMenuItem(
                              child: Text('Change distance'),
                              value: 1,
                            )
                          ]),
                ])
          : null,
      body: position == null
          ? Center(child: CircularProgressIndicator())
          : _isHomeConfirmed
              ? GoogleMap(
                  /* onTap: (cords) {
                    addMarkerOnClick(cords);
                    setState(() {
                      currentlySelectedPositionOnMap = cords;
                    });
                    print("currently"); 
                    print(currentlySelectedPositionOnMap.latitude);
                    print(currentlySelectedPositionOnMap.longitude);
                  }, */
                  markers: _myMarkers,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 11.0,
                  ),
                )
              : Builder(
                  builder: (context) => Stack(
                    children: [
                      GoogleMap(
                        onTap: (cords) {
                          _isMarkerSet = true;
                          addMarkerOnClick(cords);
                          setState(() {
                            currentlySelectedPositionOnMap = cords;
                          });
                          print("currently");
                          print("here");
                          print(currentlySelectedPositionOnMap.latitude);
                          print(currentlySelectedPositionOnMap.longitude);
                        },
                        markers: _myMarkers,
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 11.0,
                        ),
                      ),
                      Positioned(
                          left: deviceQuery.size.width / 10,
                          bottom: deviceQuery.size.height / 10,
                          child: FloatingActionButton(
                            onPressed: () {
                              if (_isMarkerSet) {
                                homeConfirmed();
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                    'Home set at marker',
                                  )),
                                );
                              } else {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Please mark a location on the map as Home'),
                                  ),
                                );
                              }

                              // addMarkerOnClick(currentlySelectedPositionOnMap);
                            },
                            child: Icon(Icons.check),
                          ))
                    ],
                  ),
                ),
    );
  }
}
