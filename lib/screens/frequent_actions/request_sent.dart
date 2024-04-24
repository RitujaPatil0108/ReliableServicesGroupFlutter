import 'package:flutter/material.dart';
import 'package:inventory_app/screens/HomeScreens/home_screen.dart';
import 'package:inventory_app/screens/frequent_actions/my_inventory.dart';

import '../../constants/colors_constants.dart';
import '../../widgets/custom_button.dart';

class RequestScreen extends StatelessWidget {
  final String requestNumber; 

  const RequestScreen({Key? key, required this.requestNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Image.asset(
              'assets/images/company_logo.jpg',
              height: 40, // Set the desired height
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: ColorsConstants.primaryBlue,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorsConstants.primaryBlue,
          ),
          onPressed: () {
Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));            
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: ColorsConstants.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Request Sent',
              style: TextStyle(
                color: ColorsConstants.primaryBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Request Number:', 
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
             Text(
              requestNumber, 
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomButton(
                text: "Check Status",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyInventory(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

