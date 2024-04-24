import 'package:flutter/material.dart';

import '../../constants/colors_constants.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: ColorsConstants.backgroundColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to RCS inventory",
                  style: TextStyle(
                    color: ColorsConstants.primaryBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/intro_page1.jpg',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Unlock the Ultimate Inventory Experience",
                  style: TextStyle(
                    color: ColorsConstants.primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Semicircle at the top with primary blue color and 0.2 opacity
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height / 7, // Adjust the height as needed
            decoration: BoxDecoration(
              color: ColorsConstants.primaryBlue.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(250), // Adjust the radius to create a semicircle
                bottomRight: Radius.circular(250),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
