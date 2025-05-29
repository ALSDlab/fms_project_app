import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FullMapScreen extends StatelessWidget {
  final LatLng initialPosition;

  const FullMapScreen({super.key, required this.initialPosition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 15.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('initial_position'),
            position: initialPosition,
          ),
        },
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
