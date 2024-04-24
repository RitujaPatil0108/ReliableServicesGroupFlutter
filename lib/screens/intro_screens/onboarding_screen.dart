import 'package:flutter/material.dart';
import 'package:inventory_app/screens/intro_screens/intro_page1.dart';
import 'package:inventory_app/screens/intro_screens/intro_page2.dart';
import 'package:inventory_app/screens/intro_screens/intro_page3.dart';
import 'package:inventory_app/screens/intro_screens/intro_page4.dart';
import 'package:inventory_app/screens/intro_screens/intro_page5.dart';
import 'package:inventory_app/screens/intro_screens/intro_page6.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/Routes_constants.dart';
import '../../constants/colors_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  bool onLastPage = false;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.toInt();
        onLastPage = currentPage == 5;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
                onLastPage = currentPage == 5;
              });
            },
              physics: const BouncingScrollPhysics(), 

            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
              IntroPage4(),
              IntroPage5(),
              IntroPage6()
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // skip
                GestureDetector(
                    onTap: () {
                      _pageController.jumpToPage(5);
                    },
                    child:  const Text('Skip',
                            style: TextStyle(
                              color: ColorsConstants.primaryBlue,
                              fontSize: 16,
                            ))),
                // dot indicators
                SmoothPageIndicator(controller: _pageController, count: 6),

                // next or done
                onLastPage
                    ? Container(
        decoration: BoxDecoration(
          color: ColorsConstants.primaryBlue,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: GestureDetector(
          onTap: () {
            // put if condtion if token saved or not
            Navigator.pushNamed(context, RoutesConstants.login);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      )
                    : Container(
  decoration: BoxDecoration(
    color: ColorsConstants.primaryBlue, 
    borderRadius: BorderRadius.circular(4.0), 
  ),
  child: GestureDetector(
    onTap: () {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: const Text(
        'Next',
        style: TextStyle(
          color: Colors.white, 
          fontSize: 16,
        ),
      ),
    ),
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
