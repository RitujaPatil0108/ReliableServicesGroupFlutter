// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/Routes_constants.dart';
import '../../constants/colors_constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_form_field.dart';
import 'package:http/http.dart' as https;
import '../providers/user_provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String url = 'https://www.reliablegroups.co.in/api/v1/login';

  Future<void> sendPostRequest(BuildContext context) async {
    final Uri uri = Uri.parse(url);
    final body = json.encode({
      'phone': _phoneController.text,
      'password': _passwordController.text,
    });

    final headers = {'Content-Type': 'application/json'};

    try {
      print("BODY");
      print(body);
      final response = await https.post(uri, body: body, headers: headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Response Body: $responseData'); // Print the response body
        if (responseData['success'] == true) {
          // Login successful, extract user details and navigate to home page
          final user = responseData['user'];
          final accessToken = responseData['access_token'];

          // Store access token in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);

          // Set user data using the UserProvider
          Provider.of<UserProvider>(context, listen: false).setUserData(user);
          print('Login Successful');
          print('User Details: $user');
          Navigator.pushNamed(context, RoutesConstants.home);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Successful')),
          );
        } else {
          // Login failed, show error message
          final message = responseData['message'];
          print('Login Failed: $message');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Failed. \nIncorrect number or password!')),
          );
        }
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Failed')),
          );
        print('Failed to make request. Status code: ${response.statusCode}');
      }
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Failed')),
          );
      print('Error making POST request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Intercept back button press
        // You can handle this based on your app's requirements
        return false; // Returning false prevents navigating back
      },
      child: Scaffold(
        backgroundColor: ColorsConstants.backgroundColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 200),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            "Welcome ",
                            style: TextStyle(
                              fontSize: 28,
                              color: ColorsConstants.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "👋",
                            style: TextStyle(
                              fontSize: 28,
                              color: ColorsConstants.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Login to your account",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            labelText: "Phone",
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            labelText: "Password",
                            obscureText: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            }, inputFormatters: const [],
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                print("Forgot Password? pressed");
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: ColorsConstants.text1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: "Login",
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                sendPostRequest(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 5,
                decoration: BoxDecoration(
                  color: ColorsConstants.primaryBlue.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(250),
                    bottomRight: Radius.circular(250),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
