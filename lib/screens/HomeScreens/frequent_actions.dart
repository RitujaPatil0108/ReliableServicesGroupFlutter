import 'package:flutter/material.dart';
import 'package:inventory_app/screens/frequent_actions/invoice_form.dart';
import 'package:inventory_app/screens/frequent_actions/my_inventory.dart';
import 'package:inventory_app/screens/frequent_actions/my_invoice.dart';
import '../../constants/colors_constants.dart';
import '../frequent_actions/all_inventory.dart';

class FrequentActions extends StatelessWidget {
  const FrequentActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ActionData> actions = [
      ActionData(
        icon: Icons.list_outlined,
        label: 'Request Invoice',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GenerateInvoiceForm()),
          );
        },
      ),
      ActionData(
        icon: Icons.inventory_2_outlined,
        label: 'Request Status',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  const MyInventory()),
          );
        },
      ),
      ActionData(
        icon: Icons.home_outlined,
        label: 'All Inventory',
        onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AllInventory()),
          );
        },
      ),
      ActionData(
        icon: Icons.money_outlined,
        label: 'Approved Invoices',
        onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  const MyInvoice()),
          );
        },
      ),
      // ActionData(
      //   icon: Icons.work_outline,
      //   label: 'Services',
      //   onTap: () {},
      // ),
      
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: List.generate(
          (actions.length / 2).ceil(),
          (index) => Row(
            children: actions
                .skip(index * 2)
                .take(2)
                .map(
                  (action) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: action.onTap,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4,
                          child: Container(
                            width: 120,
                            height: 120,
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  action.icon,
                                  color: ColorsConstants.primaryBlue,
                                  size: 32,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  action.label,
                                  style: const TextStyle(
                                    color: ColorsConstants.primaryBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class ActionData {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  ActionData({required this.icon, required this.label, this.onTap});
}
