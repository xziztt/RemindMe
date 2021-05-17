/*import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeSelected extends StatefulWidget {
  @override
  _HomeSelectedState createState() => _HomeSelectedState();
}

class _HomeSelectedState extends State<HomeSelected> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("TITLE HERE"),
          backgroundColor: Colors.black,
          actions: [
            PopupMenuButton(
                onSelected: (selectedValue) {
                  if (selectedValue == 0) {
                    setState(() {});
                  }
                  if (selectedValue == 1) {
                    setState(() {
                      showModalBottomSheet(context: context, builder: (_) {});
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
          ]),
      body: GoogleMap(
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
      ),
    );
  }
}*/
