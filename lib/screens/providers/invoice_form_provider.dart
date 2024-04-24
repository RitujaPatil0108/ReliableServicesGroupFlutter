import 'package:flutter/material.dart';

class InvoiceFormData extends ChangeNotifier {
  String tcrNumber = '';
  String callNumber = '';
  String customerName = '';
  String brand = '';

  bool get isValid => tcrNumber.isNotEmpty && callNumber.isNotEmpty && customerName.isNotEmpty && brand.isNotEmpty;

  void updateTcrNumber(String newValue) {
    tcrNumber = newValue;
    notifyListeners();
  }

  void updateCallNumber(String newValue) {
    callNumber = newValue;
    notifyListeners();
  }

  void updateCustomerName(String newValue) {
    customerName = newValue;
    notifyListeners();
  }

  void updateBrand(String newValue) {
    brand = newValue;
    notifyListeners();
  }
}
