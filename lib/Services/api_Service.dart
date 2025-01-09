import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:mis/Models/Attendance.dart';
import 'dart:convert';

import 'package:mis/Models/checkIn_response.dart';

class ApiService {
  static const String baseUrl = 'https://apimis.in/recib/wapi/';

  /// Login API
  Future<Map<String, dynamic>> login({
    required String userName,
    required String password,
  }) async {
    final url = Uri.parse('${baseUrl}login.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'UserName': userName, 'Password': password},
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {
        'success': false,
        'message': 'Login failed. Please try again.',
        'statusCode': response.statusCode,
      };
    }
  }

  /// Check-In API
  Future<CheckInResponse> checkIn(Map<String, String> body) async {
    final url = Uri.parse('${baseUrl}checkIn.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CheckInResponse.fromJson(data['checkIn'][0]);
    } else {
      throw Exception("Failed to perform check-in: ${response.body}");
    }
  }

  /// Send Location API
  Future<void> sendLocation(Map<String, String> body) async {
    final url = Uri.parse('${baseUrl}locationTrack.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to send location: ${response.body}");
    }
  }

  //Fetch Attendance API
  Future<List<Attendance>> fetchAttendance(String userId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}empAttendanceList.php'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'userId': userId
      }, // Automatically encoded in x-www-form-urlencoded format
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> attendanceList = data['AttendanceList'];

      return attendanceList.map((item) => Attendance.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load attendance');
    }
  }

  /// Fetch Attendance History API
  Future<List<Map<String, dynamic>>> fetchAttendanceHistory({
    required String userId,
    required String attendanceId,
  }) async {
    final url = Uri.parse('${baseUrl}trackHistory.php');
    try {
      final response = await http.post(
        url,
        body: {
          'userId': userId,
          'attendanceId': attendanceId,
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['attendanceHistory'] != null) {
          return (data['attendanceHistory'] as List)
              .map((item) => {
                    'latitude':
                        double.tryParse(item['locationLatitude'] ?? '0') ?? 0.0,
                    'longitude':
                        double.tryParse(item['locationLongitude'] ?? '0') ??
                            0.0,
                    'address': item['locationArea'] ?? 'Unknown',
                    'time': formatTimestamp(item['dataEntryDate']),
                  })
              .toList();
        } else {
          return [];
        }
      } else {
        print('API Error: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('API Error: $e');
      return [];
    }
  }

  String formatTimestamp(String timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(timestamp) ?? 0 * 1000);
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  //CheckOut API
  Future<void> checkOut(Map<String, String> body) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}checkOut.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Check-Out successful: ${response.body}");
        Get.snackbar(
            "Check-Out Successful", "You have successfully checked out.",
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            duration: Duration(seconds: 2));
      } else {
        print("Failed to check-out: ${response.body}");
      }
    } catch (e) {
      print("Error during Check-Out: $e");

      Get.snackbar("Error during Check-Out:", "$e",
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.black45,
          duration: Duration(seconds: 2));
    }
  }
}
