import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory_app/screens/frequent_actions/request_sent.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors_constants.dart';
import '../../widgets/custom_button.dart';
import '../models/cart.dart';
import '../providers/invoice_form_provider.dart';
import '../providers/user_provider.dart';
import 'package:http/http.dart' as http;

void sendRequest(Map<String, dynamic> requestBody) async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('accessToken');
  const url = 'https://www.reliablegroups.co.in/api/v1/orders';
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      // Request successful
      print('Request Sent Successfully');
      print('Response Body: ${response.body}');
      // You can handle the response here if needed
    } else {
      // Request failed
      print('Failed to send request: ${response.statusCode}');
      // You can handle the error here if needed
    }
  } catch (error) {
    // Exception occurred
    print('Error sending request: $error');
    // You can handle the error here if needed
  }
}

class CartDetails extends StatelessWidget {
  const CartDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).userData;
    final cart = Provider.of<Cart>(context);
    final invoiceFormData = Provider.of<InvoiceFormData>(context);

    String employeeName = '${userData!['employee_name']}';
    String employeeId = userData['email'] ?? '';

    final now = DateTime.now();
    final formattedDate = '${now.day}-${now.month}-${now.year}';

    final Map<String, dynamic> jsonData = {
      'date': formattedDate,
      'employee_name': employeeName,
      'employee_id': employeeId,
      'cart_items': cart.finalCartList.map((item) => item.toJson()).toList(),
      'total_price': '',
    };

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Image.asset(
              'assets/images/company_logo.jpg',
              height: 40,
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
            Navigator.of(context).pop();
            // Reset the quantity of all items to 0
            Provider.of<Cart>(context, listen: false)
                .resetItemQuantitiesfinal();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsConstants.primaryBlue.withOpacity(0.12),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'CART ITEMS',
                        style: TextStyle(
                          color: ColorsConstants.primaryBlue,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'EmployeeName: $employeeName\nEmail: $employeeId',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(overscroll: false),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: cart.finalCartList.length,
                          itemBuilder: (context, index) {
                            final item = cart.finalCartList.elementAt(index);
                            return ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.itemName,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 123, 123, 123)),
                                    ),
                                  ),
                                  const SizedBox(width: 35),
                                  Expanded(
                                    child: Text(
                                      '* ${item.quantity}',
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 123, 123, 123)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.3,
                      color: ColorsConstants.primaryBlue,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Price',
                            style: TextStyle(
                              color: ColorsConstants.primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            onChanged: (value) {
                              jsonData['total_price'] = value;
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              hintText: 'Enter total price',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorsConstants.primaryBlue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomButton(
              text: "Send Request",
              // Inside the onTap handler of your "Send Request" button
              onTap: () {
                final requestNumber = generateRequestNumber();
                final requestBody = {
                  "date": formattedDate,
                  "tcr_number": invoiceFormData.tcrNumber,
                  "call_number": invoiceFormData.callNumber,
                  "customer_name": invoiceFormData.customerName,
                  "brand": invoiceFormData.brand,
                  "employee_name": employeeName,
                  "items": cart.finalCartList.map((item) {
                    return {
                      "item_name": item.itemName,
                      "quantity": item.quantity
                    };
                  }).toList(),
                  "total_price": jsonData['total_price'],
                  "request_no": requestNumber,
                  "status": "Pending",
                };
                sendRequest(requestBody); // Call the sendRequest function
                Provider.of<Cart>(context, listen: false).clearCart();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RequestScreen(requestNumber: requestNumber),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String generateRequestNumber() {
    final now = DateTime.now();
    final year = now.year % 100;
    final month = now.month;
    final day = now.day;
    final hour = now.hour;
    final minute = now.minute;
    final second = now.second;
    final millisecond = now.millisecond;

    final dateFormatted = '${year.toString().padLeft(2, '0')}'
        '${month.toString().padLeft(2, '0')}'
        '${day.toString().padLeft(2, '0')}';

    final timeFormatted = '${hour.toString().padLeft(2, '0')}'
        '${minute.toString().padLeft(2, '0')}'
        '${second.toString().padLeft(2, '0')}';

    return 'REQ$dateFormatted$timeFormatted$millisecond';
  }
}
