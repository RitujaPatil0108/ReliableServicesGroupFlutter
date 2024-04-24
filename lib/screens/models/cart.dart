import 'package:flutter/material.dart';
import 'package:inventory_app/screens/models/inventory_item.dart';

class Cart extends ChangeNotifier {
  final List<InventoryItem> _items = [];
  final Set<InventoryItem> _finalCartList = {};

  List<InventoryItem> get items => _items;

  int get itemCount => _items.length;

  void addItem(InventoryItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(InventoryItem item) {
    print('Removing item: $item');
    _items.remove(item);
    notifyListeners();
  }

  void updateItemQuantity(InventoryItem item, int changeAmount) {
    final index = _items.indexWhere((element) => element == item);
    if (index != -1) {
      final updatedQuantity = _items[index].quantity + changeAmount;
      print('Updating quantity for item: $item');
      if (updatedQuantity >= 0 &&
          updatedQuantity <= _items[index].totalQuantity) {
        _items[index].quantity = updatedQuantity;
      } else if (updatedQuantity < 0) {
        // If quantity becomes negative, reset it to 1
        _items[index].quantity = 0;
      } else {
        // If quantity exceeds total quantity, set it to total quantity
        _items[index].quantity = _items[index].totalQuantity;
      }
      notifyListeners();
    }
  }

  int getItemQuantity(InventoryItem item) {
    final index = _items.indexWhere((element) => element == item);
    return index != -1 ? _items[index].quantity : 0;
  }

 void finalCart() {
  _finalCartList.clear(); // Clear the previous items
  for (var item in _items) {
    if (!_finalCartList.any((element) => element.itemName == item.itemName)) {
      _finalCartList.add(item);
    }
  }
  print('Final Cart:');
  for (var item in _finalCartList) {
    print(
      'Item: ${item.itemName}, Quantity: ${item.quantity}');
  }
  
  // Clear the items after updating _finalCartList
  _items.clear();
  notifyListeners();
}

void resetItemQuantities() {
  for (var item in _items) {
    item.quantity = 0;
  }
  notifyListeners();
}

void resetItemQuantitiesfinal() {
  for (var item in _finalCartList) {
    item.quantity = 0;
  }
  notifyListeners();
}


  // Method to clear the cart items and reset the count
  void clearCart() {
    _items.clear();
    _finalCartList.clear();
    notifyListeners();
  }

  Set<InventoryItem> get finalCartList => _finalCartList;
}
