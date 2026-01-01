import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  final double lattitude;
  final double longitude;
  const MapsScreen({
    super.key,
    required this.lattitude,
    required this.longitude,
  });

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late final _initialCameraPosition;
  late GoogleMapController? controller;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: LatLng(widget.lattitude, widget.longitude),
      zoom: 11.5,
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(20),
          child: GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            zoomControlsEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) => this.controller = controller,

            markers: {
              Marker(
                markerId: MarkerId("Event Location"),
                position: LatLng(widget.lattitude, widget.longitude),
              ),
            },
          ),
        ),

        Positioned(
          top: 20,
          right: 20,
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.black),
            ),
            onPressed: () {
              controller?.animateCamera(
                CameraUpdate.newCameraPosition(_initialCameraPosition),
              );
            },
            icon: Icon(Icons.center_focus_strong, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
