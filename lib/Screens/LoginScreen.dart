import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mis/Controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController controller = Get.find<LoginController>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00a0d2),
      body: Obx(() {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                      child: Text(
                    'Login',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  )),
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 60,
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email or Phone',
                        labelStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                        floatingLabelStyle: const TextStyle(
                            color: Color(0XFF4a8887), fontSize: 14.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    height: 60,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                        floatingLabelStyle: const TextStyle(
                            color: Colors.blueAccent, fontSize: 14.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            color: Colors.grey,
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        final userName = _emailController.text.trim();
                        final password = _passwordController.text.trim();
                        controller.login(userName: userName, password: password);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF006e8c),
                        padding: const EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 135.0),
                      ),
                      child: const Text('Login',
                          style: TextStyle(fontSize: 16.0, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      const SnackBar(content: Text('Forgot Password Clicked'));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
