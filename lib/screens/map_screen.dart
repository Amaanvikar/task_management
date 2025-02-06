import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const MapScreen({super.key, this.initialLocation});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      Navigator.pop(context, _selectedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Location',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF01442C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: widget.initialLocation ?? LatLng(19.9975, 73.7898),
          zoom: 14.0,
        ),
        markers: _selectedLocation != null
            ? {
                Marker(
                  markerId: MarkerId('selected_location'),
                  position: _selectedLocation!,
                )
              }
            : {},
        onTap: _onMapTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _confirmLocation,
        child: Icon(Icons.check),
      ),
    );
  }
}
