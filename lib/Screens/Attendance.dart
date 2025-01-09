import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mis/Models/Attendance.dart';
import 'package:mis/Screens/AttendanceHistory.dart';
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
                      border: Border.all(
                          color: const Color(0xFF00a0d2), width: 1.5),
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

  Widget buildAttendanceCard(BuildContext context, String day, String time,
      String punchOut, String totalHours, Color cardColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                day,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailRow(time, 'Punch In'),
                  const SizedBox(width: 8.0),
                  buildDetailRow(punchOut, 'Punch Out'),
                  const SizedBox(width: 8.0),
                  buildDetailRow(totalHours, 'Total Hours'),
                  const SizedBox(width: 8.0),
                  Text(
                    'View Map',
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              title,
              // Handle empty values
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
