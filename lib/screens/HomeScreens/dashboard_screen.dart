import 'package:flutter/material.dart';
import '../../constants/colors_constants.dart';

class InventoryDetails {
  final String title;
  final IconData icon;

  InventoryDetails({
    required this.title,
    required this.icon,
  });
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hardcoded inventory data for demonstration
    final List<InventoryDetails> todayInventory = [
      InventoryDetails(
        title: 'Reliable',
        icon: Icons.people,
      ),
      InventoryDetails(
        title: 'Efficient',
        icon: Icons.speed,
      ),
      InventoryDetails(
        title: 'Flexible',
        icon: Icons.layers,
      ),
      InventoryDetails(
        title: 'Easy',
        icon: Icons.lightbulb_outline,
      ),
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: todayInventory.map((inventoryItem) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: 300,
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ColorsConstants.primaryBlue, ColorsConstants.primaryBlue.withOpacity(.7)],
                        begin: AlignmentDirectional.topCenter,
                        end: AlignmentDirectional.bottomCenter,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Aligning the title and icon in the center of the container
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon with larger size
                                Icon(
                                  inventoryItem.icon,
                                  color: Colors.white,
                                  size: 70, // Larger icon size
                                ),
                                const SizedBox(width: 10), // Added spacing between icon and title
                                // Title with larger font
                                Text(
                                  inventoryItem.title,
                                  style: const TextStyle(
                                    fontSize: 32, // Larger font size
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
