class InventoryItem {
  final dynamic itemName;
  final dynamic partNumber;
  late dynamic quantity;
  final dynamic totalQuantity;

  InventoryItem({
    required this.itemName,
    required this.partNumber,
    required this.quantity,
    required this.totalQuantity, 
  });

  get status => null;

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'loan_number': partNumber,
      'quantity': quantity,
    };
  }

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      itemName: json['item_name'] as String,
      quantity: json['quantity'] as int, 
      partNumber: json['loan_number'] ?? '', 
      totalQuantity: json['total_quantity'] ?? 0, 
    );
  }
}
