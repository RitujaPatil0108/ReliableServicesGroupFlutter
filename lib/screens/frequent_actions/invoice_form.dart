import 'package:flutter/material.dart';
import 'package:inventory_app/screens/providers/invoice_form_provider.dart';
import 'package:provider/provider.dart';
import '../../constants/colors_constants.dart';
import '../../screens/frequent_actions/items_list.dart';

class GenerateInvoiceForm extends StatelessWidget {
  const GenerateInvoiceForm({Key? key}) : super(key: key);

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
        elevation: 0, // No elevation for app bar
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
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin:
                const EdgeInsets.fromLTRB(20, 10, 20, 20), // Adjust margin here
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Invoice Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorsConstants.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'TCR Number',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorsConstants.primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    Provider.of<InvoiceFormData>(context, listen: false)
                        .updateTcrNumber(value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter TCR number',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorsConstants.primaryBlue),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'TCR number is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Call Number',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorsConstants.primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    Provider.of<InvoiceFormData>(context, listen: false)
                        .updateCallNumber(value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter call number',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorsConstants.primaryBlue),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Call number is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Customer Name',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorsConstants.primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    Provider.of<InvoiceFormData>(context, listen: false)
                        .updateCustomerName(value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter customer name',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorsConstants.primaryBlue),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Customer name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Brand',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorsConstants.primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    Provider.of<InvoiceFormData>(context, listen: false)
                        .updateBrand(value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter brand',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorsConstants.primaryBlue),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Brand is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final form = Provider.of<InvoiceFormData>(context, listen: false);
                      if (form.isValid) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ItemsList()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all required fields'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: ColorsConstants.primaryBlue,
                    ),
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
