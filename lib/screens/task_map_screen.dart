import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaskMapScreen extends StatefulWidget {
  final List<dynamic> tasks;

  const TaskMapScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  _TaskMapScreenState createState() => _TaskMapScreenState();
}

class _TaskMapScreenState extends State<TaskMapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    for (var task in widget.tasks) {
      if (task.latitude != null && task.longitude != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(task.title),
            position: LatLng(task.latitude, task.longitude),
            infoWindow: InfoWindow(title: task.title, snippet: task.status),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              task.status == 'Completed'
                  ? BitmapDescriptor.hueGreen
                  : task.status == 'InProgress'
                      ? BitmapDescriptor.hueOrange
                      : BitmapDescriptor.hueRed,
            ),
          ),
        );
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Locations',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF01442C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _markers.isNotEmpty
              ? _markers.first.position
              : const LatLng(12.9716, 77.5946),
          zoom: 12,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
