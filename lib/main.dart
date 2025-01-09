import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mis/Bindings/Login_Binding.dart';
import 'package:mis/Controllers/login_controller.dart';
import 'package:mis/Screens/Dashboard.dart';
import 'package:mis/Screens/LoginScreen.dart';

void main() {
  runApp(const MyApp());
  Get.put(LoginController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: LoginBinding(),
      //title: 'MIS',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LoginScreen()),
        GetPage(name: '/dashboard', page: () => Dashboard()),
      ],
    );
  }
}
