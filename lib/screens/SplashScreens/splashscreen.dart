// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:inventory_app/constants/colors_constants.dart';
import 'package:inventory_app/screens/AuthScreens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../HomeScreens/home_screen.dart';
import '../providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controllerR;
  late AnimationController _controllerC;
  late AnimationController _controllerS;
  late AnimationController _controllerLogo;
  late AnimationController _controllerText;

  @override
  void initState() {
    super.initState();

    _controllerR = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _controllerC = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _controllerS = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _controllerLogo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controllerText = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controllerR.forward();

    _controllerR.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controllerR.reset();
        _controllerC.forward();
      }
    });

    _controllerC.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controllerC.reset();
        _controllerS.forward();
      }
    });

    _controllerS.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controllerS.reset();
        _controllerLogo.forward();
        Future.delayed(const Duration(seconds: 1), () {
          _controllerText.forward();
        });
      }
    });

    _controllerText.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 3), () {
          _checkSessionStatus();
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(builder: (context) => LoginScreen()),
          // );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controllerR,
              builder: (context, child) {
                return _buildLetter('R', _controllerR);
              },
            ),
            AnimatedBuilder(
              animation: _controllerC,
              builder: (context, child) {
                return _buildLetter('C', _controllerC);
              },
            ),
            AnimatedBuilder(
              animation: _controllerS,
              builder: (context, child) {
                return _buildLetter('S', _controllerS);
              },
            ),
            AnimatedBuilder(
              animation: _controllerLogo,
              builder: (context, child) {
                return _buildImage(_controllerLogo);
              },
            ),
            AnimatedBuilder(
              animation: _controllerText,
              builder: (context, child) {
                return _buildText(_controllerText);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkSessionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      // Session is active, navigate to home screen
      const String url =
          'https://www.reliablegroups.co.in/api/v1/profile';
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
      };

      try {
        final response = await http.get(Uri.parse(url), headers: headers);
        print(response.body);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print('Response Body: $responseData');

          if (responseData != null && responseData is Map<String, dynamic>) {
            print('Response Data: $responseData');

            Provider.of<UserProvider>(context, listen: false)
                .setUserData(responseData);
            print('User Details: $responseData');
          } else {
            print(
                'Invalid response data format. Unable to parse response data.');
          }
        } else {
          print(
              'Failed to fetch user data. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error during API call: $error');
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // Session is not active, navigate to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Widget _buildLetter(String letter, AnimationController controller) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.5,
              curve: Curves.easeInOut), // Adjusted curve
        ),
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.5,
                curve: Curves.easeInOut), // Adjusted curve
          ),
        ),
        child: FadeTransition(
          opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: controller,
              curve: const Interval(0.5, 1.0,
                  curve: Curves.easeInOut), // Adjusted curve
            ),
          ),
          child: Text(
            letter,
            style: const TextStyle(
              color: ColorsConstants.primaryBlue,
              fontSize: 200, // Adjusted font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = controller.value;
        final offset = Offset(0, -100 + 100 * value);
        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: value,
            child: Image.asset(
              'assets/images/company_logo.jpg',
              height: 200,
            ),
          ),
        );
      },
    );
  }

  Widget _buildText(AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = controller.value;
        final offset = Offset(0, 200 - 100 * value); // Adjusted offset
        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: value,
            child: const Text(
              'Reliable Customer Services',
              style: TextStyle(
                color: ColorsConstants.primaryBlue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controllerR.dispose();
    _controllerC.dispose();
    _controllerS.dispose();
    _controllerLogo.dispose();
    _controllerText.dispose();
    super.dispose();
  }
}
