import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mis/Services/api_Service.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  late Future<List<Map<String, dynamic>>> attendanceHistory;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
    attendanceHistory = ApiService().fetchAttendanceHistory(
      userId: '4', 
      attendanceId: '196', 
    );
  }

  Future<void> _fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle this scenario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle this scenario
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle this scenario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')),
      );
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00a0d2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Attendance History',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: attendanceHistory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print('Error occurred: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Check if the attendanceHistory is empty
                final attendanceHistoryData = snapshot.data ?? [];

                if (attendanceHistoryData.isEmpty) {
                  return Center(child: Text('No attendance history found.'));
                }

                return Column(
                  children: [
                    // Map Section
                    Expanded(
                      flex: 1,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: _currentPosition != null
                              ? LatLng(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude,
                                )
                              : LatLng(
                                  28.4595, 77.0266), // Default location if null
                          initialZoom: 14.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                            userAgentPackageName: 'com.example.app',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _currentPosition != null
                                    ? LatLng(
                                        _currentPosition!.latitude,
                                        _currentPosition!.longitude,
                                      )
                                    : LatLng(28.4595,
                                        77.0266), // Default marker if null
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Location and Time Section
                    SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: attendanceHistoryData.map((location) {
                              return Column(
                                children: [
                                  buildLocationItem(
                                    location: location['address'],
                                    time: location['time'],
                                  ),
                                  buildAlignedVerticalDivider(),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget buildLocationItem({required String location, required String time}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Circular Icon
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFF49AE4F),
          child: const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(width: 16),
        // Location and Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "Time: ",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAlignedVerticalDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 40, // Divider height
              width: 2, // Divider thickness
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(width: 41), // Offset for alignment with CircleAvatar
        ],
      ),
    );
  }
}
