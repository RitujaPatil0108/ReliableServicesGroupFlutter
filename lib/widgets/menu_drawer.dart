// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:inventory_app/screens/Profile&settings/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/colors_constants.dart';
import '../screens/AuthScreens/login_screen.dart';
import '../screens/providers/user_provider.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).userData;

    return Drawer(
      child: Container(
        color: ColorsConstants.backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 150,
            ),
            Container(
              color: ColorsConstants.backgroundColor,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const CircleAvatar(
                      backgroundColor: ColorsConstants.primaryBlue,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                      radius: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userData != null
                          ? '${userData['employee_name']}'
                          : 'Loading...',
                      style: const TextStyle(
                        color: ColorsConstants.primaryBlue,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        // Handle "View Profile" tap
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileScreen()));
                      },
                      child: const Text(
                        'View Profile',
                        style: TextStyle(
                          color: ColorsConstants.primaryBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Color.fromARGB(
                    255, 105, 105, 105), // Changed color to dark grey
              ),
              title: const Text(
                'Personal Info',
                style: TextStyle(
                  color: Color.fromARGB(
                      255, 105, 105, 105), // Changed color to dark grey
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // Handle "Personal Info" tap
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Color.fromARGB(
                    255, 105, 105, 105), // Changed color to dark grey
              ),
              title: const Text(
                'Settings',
                style: TextStyle(
                  color: Color.fromARGB(
                      255, 105, 105, 105), // Changed color to dark grey
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // Handle "Settings" tap
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
             onTap: () async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('accessToken');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (error) {
      // Error occurred while logging out, handle error
      print('Error logging out: $error');
    }
  },
            ),
          ],
        ),
      ),
    );
  }
}
