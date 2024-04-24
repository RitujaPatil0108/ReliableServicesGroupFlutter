import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/constants/colors_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../invoice_pdf/invoice.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final Widget content;
  final Color arrowColor;
  final VoidCallback? onGenerateInvoicePressed;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    required this.content,
    this.arrowColor = ColorsConstants.primaryBlue,
    this.onGenerateInvoicePressed,
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
                    fontSize: 15, // Reduce the font size
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
        if (_isExpanded && widget.onGenerateInvoicePressed != null)
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: widget.onGenerateInvoicePressed,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: ColorsConstants.primaryBlue,
                ),
                child: const Text('Generate Invoice'),
              ),
            ),
          ),
      ],
    ),
  ),
);

  }
}

class MyInvoice extends StatefulWidget {
  const MyInvoice({Key? key}) : super(key: key);

  @override
  State<MyInvoice> createState() => _MyInvoiceState();
}

class _MyInvoiceState extends State<MyInvoice> {
  List<Map<String, dynamic>> requestList = [];
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

  try {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken');
    const url = 'https://www.reliablegroups.co.in/api/v1/approved_requests'; 
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        requestList = List<Map<String, dynamic>>.from(responseData);
        isLoading = false;
      });
      
      // Print the response data on the console
      print('Response Data: $requestList');
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
            Navigator.of(context).pop();
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
                final requestNumber = json['request_no'] as String;
                final List<Widget> itemList = (json['items'] as List<dynamic>)
                    .map((item) => ListTile(
                          title: Text(item['item_name']),
                          subtitle: Text('Quantity: ${item['quantity']}'),
                        ))
                    .toList();

                return CustomExpansionTile(
                  title: 'Request Number: $requestNumber',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...itemList,
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date: $date',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Total Price: ₹$totalPrice',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onGenerateInvoicePressed: () async {
                    // Action to perform when Generate Invoice button is pressed
                    print('Generating PDF...');
                    // Call the function with the JSON data
                    await generateInvoicePDF(context, json);
                    print('PDF generated.');
                  },
                );
              },
            ),
    );
  }
}
