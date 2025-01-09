import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mis/Models/login_response_model.dart';

class LoginController extends GetxController {
  final String _baseUrl = 'https://apimis.in/recib/wapi/login.php';

  var isLoading = false.obs;
  var loginResponse = Rxn<LoginResponseModel>();

  Future<void> login(
      {required String userName, required String password}) async {
    print('Username: $userName');
    print('Password: $password');

    if (userName.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Username and Password cannot be empty.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Prepare form data as a Map
      Map<String, String> formData = {
        'userName': userName,
        'password': password,
      };

      // Send POST request with form-data in the body
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData,
      );

      print('Full Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseMap = jsonDecode(response.body);

        if (responseMap['message'] == 'Login successful') {
          // Assuming your API returns data in the expected format
          final userData = responseMap['login'][0];
          loginResponse.value = LoginResponseModel.fromJson(userData);
          Get.snackbar(
            'Success',
            'Login successful',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          print("Navigating to dashboard...");
          Get.offAllNamed('/dashboard');
        } else {
          final errorMessage = responseMap['error'] ??
              responseMap['message'] ??
              'Invalid credentials';
          Get.snackbar(
            'Error',
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        print('Error: ${response.statusCode}');
        Get.snackbar(
          'Error',
          'Login failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
