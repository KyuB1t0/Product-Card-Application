import '../../domain/entities/product.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String stockStatus;
  final int quantity;
  final bool isFeatured;
  final bool hasDiscount;
  final DateTime? lastRestocked;

  // Electronics
  final bool? hasWarranty;
  final int? warrantyDays;

  // Clothing
  final bool? isSeasonalItem;
  final List<String>? availableSizes;

  // Food
  final DateTime? expiryDate;
  final bool? isPerishable;

  const ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> j) {
    return ProductModel(
      id: j['id'],
      name: j['name'],
      category: j['category'],
      price: (j['price'] as num).toDouble(),
      stockStatus: j['stockStatus'],
      quantity: j['quantity'],
      isFeatured: j['isFeatured'] ?? false,
      hasDiscount: j['hasDiscount'] ?? false,
      lastRestocked: j['lastRestocked'] != null
          ? DateTime.tryParse(j['lastRestocked'])
          : null,
      hasWarranty: j['hasWarranty'],
      warrantyDays: j['warrantyDays'],
      isSeasonalItem: j['isSeasonalItem'],
      availableSizes: j['availableSizes'] != null
          ? List<String>.from(j['availableSizes'])
          : null,
      expiryDate: j['expiryDate'] != null
          ? DateTime.tryParse(j['expiryDate'])
          : null,
      isPerishable: j['isPerishable'],
    );
  }

  /// 🔹 Convert to domain entity
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      category: category,
      price: price,
      stockStatus: stockStatus,
      quantity: quantity,
      isFeatured: isFeatured,
      hasDiscount: hasDiscount,
      lastRestocked: lastRestocked ?? DateTime.now(),
      hasWarranty: hasWarranty,
      warrantyDays: warrantyDays,
      isSeasonalItem: isSeasonalItem,
      availableSizes: availableSizes,
      expiryDate: expiryDate,
      isPerishable: isPerishable,
    );
  }
}
