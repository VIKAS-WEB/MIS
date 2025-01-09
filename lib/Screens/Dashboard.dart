import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:mis/Screens/Attendance.dart';
import 'package:mis/Screens/AttendanceHistory.dart';
import 'package:mis/Services/api_Service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isSwitchOn = false; // Initial state of the switch button
  String locationAddress = 'Fetching Address...'; // Default location address
  String currentTime = ''; // Variable to hold current time
  String currentDate = ''; // Variable to hold current date

  // Method to get current location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle accordingly
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception('Location permissions are denied');
      }
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _fetchAddress(double latitude, double longitude) async {
    try {
      // Fetch address from latitude and longitude
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      // Log the placemarks list to inspect its content
      print("Placemark List: $placemarks");

      if (placemarks.isNotEmpty) {
        // Get the first Placemark object from the list
        Placemark place = placemarks[0];

        // Log individual properties to ensure they are not null
        print("Name: ${place.name}");
        print("Street: ${place.street}");
        print("Locality: ${place.locality}");
        print("Admin Area: ${place.administrativeArea}");
        print("Country: ${place.country}");

        // Set the locationAddress with null checks
        setState(() {
          locationAddress = ' ${place.street ?? "Unknown"}'
              ', ${place.locality ?? "Unknown"}'
              ', ${place.administrativeArea ?? "Unknown"}'
              ', ${place.country ?? "Unknown"}';
        });
      } else {
        // Handle case where no placemarks are returned
        setState(() {
          locationAddress = 'Address not available';
        });
      }
    } catch (e) {
      // Log the exception details for further inspection
      print("Error fetching address: $e");
      setState(() {
        locationAddress = 'Unable to fetch address';
      });
    }
  }

  // Method to handle the check-in process
  Future<void> _handleCheckIn() async {
    try {
      // Fetch current location
      Position position = await _getCurrentLocation();

      // Fetch current time and date
      setState(() {
        currentTime =
            DateFormat('hh:mm a').format(DateTime.now()); // Time format
        currentDate = DateFormat('EEEE, MMM dd, yyyy')
            .format(DateTime.now()); // Date format
      });

      // Fetch the address using the location
      await _fetchAddress(position.latitude, position.longitude);

      // Prepare the body parameters for both APIs
      Map<String, String> body = {
        'userId': '4', // Example user ID
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'location': locationAddress, // Dynamic location
      };

      // Check-In API call
      await ApiService().checkIn(body);

      // Location Track API call
      await ApiService().sendLocation(body);

      // Update the UI or perform additional actions after success
      print("Check-In and Location Track successful.");
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  // Method to handle the check-out process
  // Method to handle the check-in process
  Future<void> _handleCheckOut() async {
    try {
      // Fetch current location
      Position position = await _getCurrentLocation();

      // Fetch current time and date
      setState(() {
        currentTime =
            DateFormat('hh:mm a').format(DateTime.now()); // Time format
        currentDate = DateFormat('EEEE, MMM dd, yyyy')
            .format(DateTime.now()); // Date format
      });

      // Fetch the address using the location
      await _fetchAddress(position.latitude, position.longitude);

      // Prepare the body parameters for both APIs
      Map<String, String> body = {
        'userId': '4', // Example user ID
        'checkInId': '196',
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'location': locationAddress,
        'Distance': '23' // Dynamic location
      };

      // Check-In API call
      await ApiService().checkOut(body);

      // Location Track API call
      await ApiService().sendLocation(body);

      // Update the UI or perform additional actions after success
      print("Check-out and Location Track successful.");
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.notifications_none),
            tooltip: 'Notifications',
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 5),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(
                'assets/Images/User.png',
              ),
              backgroundColor: Colors.white,
            ),
          ),
        ],
        backgroundColor: const Color(0xFFededed),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu',
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Container
              SizedBox(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  height: MediaQuery.of(context).size.height / 3.1,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00a0d2),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Welcome to MIS',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            currentTime, // Display current time
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 22.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 19.0),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                currentDate, // Display current date
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Location:', // Display the fetched address
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 150,
                                child: Text(
                                  locationAddress, // Display the fetched address
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 21.0),
                          Row(
                            children: [
                              const Icon(
                                Icons.check_box,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Check-In:',
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                currentTime,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Right Column
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              'assets/Images/User.png',
                            ),
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            decoration: BoxDecoration(
                              color: isSwitchOn
                                  ? const Color(0xFF4cad53)
                                  : const Color(0xFFaf001e),
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Switch(
                              value: isSwitchOn,
                              activeColor: const Color(0xFFaffe56),
                              inactiveThumbColor: const Color(0xFFc35a6e),
                              inactiveTrackColor: const Color(0xFFaf001e),
                              onChanged: (value) {
                                setState(() {
                                  isSwitchOn = value; // Toggle the switch
                                  if (isSwitchOn) {
                                    _handleCheckIn(); // Call the check-in method
                                  } else {
                                    _handleCheckOut();
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Dashboard Cards (not changed)
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDashboardCard(
                    imagePath: 'assets/Images/LeaveM.png',
                    label: 'Leave Management',
                    destinationScreen: AttendanceHistoryScreen(),
                  ),
                  _buildDashboardCard(
                    imagePath: 'assets/Images/AssetManagement.png',
                    label: 'Attendance Management',
                    destinationScreen: AttendanceScreen(),
                  ),
                  _buildDashboardCard(
                    imagePath: 'assets/Images/WFH.png',
                    label: 'Work From Home',
                    destinationScreen: AttendanceScreen(),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDashboardCard(
                    imagePath: 'assets/Images/ProjectT.png',
                    label: 'Project Task',
                    destinationScreen: AttendanceScreen(),
                  ),
                  _buildDashboardCard(
                    imagePath: 'assets/Images/Chart.png',
                    label: 'Performance',
                    destinationScreen: AttendanceScreen(),
                  ),
                  _buildDashboardCard(
                    imagePath: 'assets/Images/ShiftRoster.png',
                    label: 'Shift Roster',
                    destinationScreen: AttendanceScreen(),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDashboardCard(
                    imagePath: 'assets/Images/EmployeeOnboard.png',
                    label: 'Employee Onboarding',
                    destinationScreen: AttendanceScreen(),
                  ),
                  _buildDashboardCard(
                    imagePath: 'assets/Images/Recruitment.png',
                    label: 'Recruitment & Hiring',
                    destinationScreen: AttendanceScreen(),
                  ),
                  _buildDashboardCard(
                    imagePath: 'assets/Images/Travel.png',
                    label: 'Travel & Expense',
                    destinationScreen: AttendanceScreen(),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDashboardCard(
                    imagePath: 'assets/Images/AssetManagement.png',
                    label: 'Assets Management',
                    destinationScreen: AttendanceScreen(),
                  ),
                  _buildDashboardCard(
                    imagePath: 'assets/Images/PayRoll.png',
                    label: 'Payroll Management',
                    destinationScreen: AttendanceScreen(),
                  ),
                  _buildDashboardCard(
                    imagePath: 'assets/Images/HRReport.png',
                    label: 'HR Report & Data',
                    destinationScreen: AttendanceScreen(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to create each card
  Widget _buildDashboardCard({
    required String imagePath,
    required String label,
    required Widget destinationScreen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Container(
        width: 110.0,
        height: 115,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 70.0,
              width: 70.0,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 8.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
