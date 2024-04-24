import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/screens/frequent_actions/cart_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventory_app/screens/models/inventory_item.dart';
import 'package:provider/provider.dart';
import '../../constants/colors_constants.dart';
import '../models/cart.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  List<InventoryItem> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final fetchedItems = await fetchItemsFromAPI();
      setState(() {
        items = fetchedItems;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<InventoryItem>> fetchItemsFromAPI() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken');

    if (token != null) {
      const url = 'https://www.reliablegroups.co.in/api/v1/items_assigned';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      try {
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          print('Response Data: $jsonData');

          if (jsonData.containsKey('assigned_items')) {
            final List<dynamic> assignedItems = jsonData['assigned_items'];
            final List<InventoryItem> items = [];

            for (var itemData in assignedItems) {
              final InventoryItem item = InventoryItem(
                itemName: itemData['item_name'],
                partNumber: itemData['part_number'],
                quantity: 0,
                totalQuantity: itemData['quantity'],
              );
              items.add(item);
            }

            return items;
          } else {
            throw Exception('Response data does not contain "assigned_items"');
          }
        } else {
          throw Exception('Failed to load items: ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching items: $error');
        rethrow;
      }
    } else {
      print('Token not available');
      throw Exception('Token not available');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        leading:  IconButton(
  icon: const Icon(
    Icons.arrow_back_ios,
    color: ColorsConstants.primaryBlue,
  ),
  onPressed: () {
    Provider.of<Cart>(context, listen: false).clearCart(); 
    Navigator.of(context).pop();
  },
),

        actions: [
          Stack(
            children: [
              Consumer<Cart>(
                builder: (context, cart, child) {
                  return IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      cart.finalCart();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartDetails()),
                      );
                   
                    },
                  );
                },
              ),
              Consumer<Cart>(
                builder: (context, cart, child) {
                  return Positioned(
                    right: 6,
                    top: 2.5,
                    child: CircleAvatar(
                      backgroundColor: ColorsConstants.primaryBlue,
                      radius: 9,
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      item.itemName,
                      style: const TextStyle(
                        color: ColorsConstants.primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Part Number: ${item.partNumber}'),
                        Text('Total assigned items: ${item.totalQuantity}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (item.quantity > 0) {
                              Provider.of<Cart>(context, listen: false)
                                  .updateItemQuantity(item, -1);
                              Provider.of<Cart>(context, listen: false)
                                  .removeItem(item);
                            }
                          },
                        ),
                        Text(
                          '${Provider.of<Cart>(context).getItemQuantity(item)}',
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (item.quantity < item.totalQuantity) {
                              Provider.of<Cart>(context, listen: false)
                                  .addItem(item);
                              Provider.of<Cart>(context, listen: false)
                                  .updateItemQuantity(item, 1);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
