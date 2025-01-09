import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:mis/Models/Attendance.dart';
import 'package:mis/Services/api_Service.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final ApiService _attendanceService = ApiService(); // Fixed instantiation
  late Future<List<Attendance>> _attendanceFuture;

  @override
  void initState() {
    super.initState();
    _attendanceFuture = _attendanceService.fetchAttendance('4'); // Pass userId
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
          'Attendance',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.calendar_today,
                    size: 24.0, color: Color(0xFF00a0d2)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF00a0d2), width: 1.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButton<String>(
                    value: 'January',
                    underline: const SizedBox(),
                    onChanged: (String? newValue) {
                      // Handle month change
                    },
                    items: <String>['January', 'February', 'March', 'April']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Attendance>>(
                future: _attendanceFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final attendanceList = snapshot.data!;
                    return ListView.builder(
                      itemCount: attendanceList.length,
                      itemBuilder: (context, index) {
                        final attendance = attendanceList[index];
                        return buildAttendanceCard(
                          context,
                          attendance.checkIn.split(' ')[0], // Extract day
                          attendance.checkIn.split(' ')[1], // Extract time
                          attendance.checkOut,
                          attendance.duration,
                          const Color(0xFF5fc882),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text('No attendance data available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAttendanceCard(BuildContext context, String checkIn, String time,
      String punchOut, String totalHours, Color cardColor) {
    try {
      // Trim any leading/trailing spaces
      checkIn = checkIn.trim();

      // Parse the date in the 'dd-MM-yyyy' format
      DateTime checkInDate = DateFormat('dd-MM-yyyy').parse(checkIn);

      // Format the parsed date into the desired display format (e.g., "Mon, Dec 26").
      String date = DateFormat('dd').format(checkInDate);
      String day = DateFormat('E').format(checkInDate);
      return Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Row(
          children: [
            // Container for the day and date
            Container(
              width: 90,
              height: 70,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date, // Display formatted date
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    day, // Display formatted date
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildDetailRow(time, 'Punch In'),
                    const SizedBox(width: 15.0),
                    buildDetailRow(punchOut, 'Punch Out'),
                    const SizedBox(width: 15.0),
                    buildDetailRow(totalHours, 'Total Hours'),
                    const SizedBox(width: 15.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed('/AttendanceHistory');
                          },
                          child: Text(
                            'View Map',
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return Center(
        child: Text('Error parsing date: $e'),
      );
    }
  }

  Widget buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              title,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
