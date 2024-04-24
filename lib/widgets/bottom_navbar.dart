import 'package:flutter/material.dart';
import 'package:inventory_app/constants/colors_constants.dart';
import 'package:inventory_app/screens/Profile&settings/profile_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: ColorsConstants.primaryBlue,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
        // Handle navigation or other actions based on the index
        switch (index) {
          case 0:
            // Handle Settings item click
            // Replace with your desired action
            break;
          case 1:
            // Handle Home item click
            // Replace with your desired action
            break;
          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfileScreen()));
            break;
        }
      },
    );
  }
}
