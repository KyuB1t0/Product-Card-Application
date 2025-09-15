class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String stockStatus;
  final int quantity;
  final bool isFeatured;
  final bool hasDiscount;
  final DateTime lastRestocked;

  // Electronics
  final bool? hasWarranty;
  final int? warrantyDays;

  // Clothing
  final bool? isSeasonalItem;
  final List<String>? availableSizes;

  // Food
  final DateTime? expiryDate;
  final bool? isPerishable;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stockStatus,
    required this.quantity,
    required this.isFeatured,
    required this.hasDiscount,
    required this.lastRestocked,
    this.hasWarranty,
    this.warrantyDays,
    this.isSeasonalItem,
    this.availableSizes,
    this.expiryDate,
    this.isPerishable,
  });

  bool get isElectronics => category == 'electronics';
  bool get isClothing => category == 'clothing';
  bool get isFood => category == 'food';

  int daysUntilExpiry() {
    if (expiryDate == null) return 99999;
    return expiryDate!.difference(DateTime.now()).inDays;
  }
}
