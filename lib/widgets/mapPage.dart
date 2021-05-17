import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wearamask/widgets/mainHome.dart';
import '../drawer/drawerHome.dart';
import 'dart:math' show cos, sqrt, asin;
import 'dart:async';

class MapPage extends StatefulWidget {
  static const routeName = '/map-page';
  @override
  _MapPageState createState() => _MapPageState();
}

Timer timer;
double distanceBetweenPoints = 0;

class _MapPageState extends State<MapPage> {
  final Set<Marker> _myMarkers = {};
  Position position;
  bool _isHomeConfirmed = false;
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
  }

  @override
  void initState() {
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getCurrentLocation());
    super.initState();
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
      _isHomeConfirmed = true;
    });
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

  @override
  Widget build(BuildContext context) {
    final deviceQuery = MediaQuery.of(context);
    BuildContext scaffoldContext = context;
    return Scaffold(
      drawer: _isHomeConfirmed ? DrawerHome(_isHomeConfirmed) : null,
      appBar: _isHomeConfirmed
          ? AppBar(
              title: Text(distanceBetweenPoints.toString()),
              backgroundColor: Colors.black,
              actions: [
                  PopupMenuButton(
                      onSelected: (selectedValue) {
                        if (selectedValue == 0) {
                          setState(() {
                            _isHomeConfirmed = !_isHomeConfirmed;
                          });
                        }
                        if (selectedValue == 1) {
                          setState(() {
                            showModalBottomSheet(
                                context: context,
                                builder: (_) {
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
                            PopupMenuItem(child: Text('Change distance'))
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
