import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventory_app/screens/HomeScreens/frequent_actions.dart';
import '../../constants/colors_constants.dart';
import '../../widgets/bottom_navbar.dart';
import '../../widgets/menu_drawer.dart';
import '../AuthScreens/login_screen.dart';
import 'dashboard_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        // Return true to indicate that the back button should be handled by the system
        return false; // Returning false prevents navigating back
      },
      child: FutureBuilder<bool>(
        future: _checkAuthenticationState(), // Check authentication state
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError || !snapshot.data!) {
            // If authentication fails or user not authenticated, navigate to login screen
            return LoginScreen();
          } else {
            // User is authenticated, show the HomeScreen
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                title: Image.asset(
                  'assets/images/company_logo.jpg',
                  height: 40, // Set the desired height
                ),
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(
                  color: ColorsConstants.primaryBlue,
                ),
              ),
              drawer: const MenuDrawer(),
              body: const SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Overview",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      DashboardScreen(),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Frequent Actions",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FrequentActions(),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: const CustomBottomNavigationBar(),
            );
          }
        },
      ),
    );
  }

  Future<bool> _checkAuthenticationState() async {
    // Retrieve access token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    // Check if access token exists and is not null
    return accessToken != null;
  }
}
