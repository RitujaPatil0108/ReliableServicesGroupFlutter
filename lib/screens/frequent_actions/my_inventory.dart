import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/constants/colors_constants.dart';
import 'package:inventory_app/screens/HomeScreens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final Widget content;
  final Color arrowColor;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    required this.content,
    this.arrowColor = ColorsConstants.primaryBlue,
  }) : super(key: key);

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: ColorsConstants.primaryBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: widget.arrowColor,
                    ),
                  ],
                ),
              ),
            ),
            if (_isExpanded) widget.content,
          ],
        ),
      ),
    );
  }
}

class MyInventory extends StatefulWidget {
  const MyInventory({Key? key}) : super(key: key);

  @override
  State<MyInventory> createState() => _MyInventoryState();
}

class _MyInventoryState extends State<MyInventory> {
  late List<Map<String, dynamic>> requestList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken');

    // Check if the token is null
    if (token == null) {
      print('Access token is null');
      setState(() {
        isLoading = false;
      });
      return;
    }

    const url = 'https://www.reliablegroups.co.in/api/v1/orders';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          requestList = List<Map<String, dynamic>>.from(responseData);
          isLoading = false;
        });

        // Print the response list on the console
        print('Response List: $requestList');
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorsConstants.primaryBlue,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: requestList.length,
              itemBuilder: (context, index) {
                final json = requestList[index];
                final date = json['date'] as String;
                final totalPrice = json['total_price'] as int;
                final status = json['status'] as String;
                final requestNumber = json['request_no'] as String;
                final List<Widget> itemList = (json['items'] as List<dynamic>?)
                        ?.asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key + 1;
                      final item = entry.value;
                      final itemName = item['item_name'] as String;
                      final quantity = item['quantity'] as int;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        title: Text('$index. $itemName'),
                        subtitle: Text('Quantity: $quantity'),
                      );
                    }).toList() ??
                    [];

                return CustomExpansionTile(
                  title: 'Request Number: $requestNumber',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            ...itemList,
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date: $date',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Price: ₹$totalPrice',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: status == 'Approved'
                                        ? Colors.green.withOpacity(0.5)
                                        : status == 'Pending'
                                            ? Colors.orange.withOpacity(0.5)
                                            : Colors.red.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (status == 'Denied') SizedBox(height: 8), // Add a gap
                                if (status == 'Denied')
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      'Resend Request',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
