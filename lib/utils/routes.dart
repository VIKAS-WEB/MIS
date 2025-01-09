import 'package:get/route_manager.dart';
import 'package:mis/Screens/Attendance.dart';
import 'package:mis/Screens/AttendanceHistory.dart';
import 'package:mis/Screens/Dashboard.dart';
import 'package:mis/Screens/LoginScreen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String attendance = '/Attendance';
  static const String attendanceHistory = '/AttendanceHistory';

  static final routes = [
    GetPage(name: login, page: () => LoginScreen(), transition: Transition.cupertino),
    GetPage(name: dashboard, page: () => Dashboard(), transition: Transition.cupertino),
    GetPage(name: attendance, page: () => AttendanceScreen(),transition: Transition.cupertino),
    GetPage(name: attendanceHistory, page: () => AttendanceHistoryScreen(), transition: Transition.cupertino),
  ];
}

class AttendanceHistory {}
