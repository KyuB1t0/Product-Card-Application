import 'package:flutter/foundation.dart';
import 'package:product_card_application/domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_all_products.dart';
import '../../domain/usecases/get_products_by_category.dart';
import '../../domain/usecases/toggle_discount.dart';

class ProductProvider extends ChangeNotifier {
  final GetAllProducts getAllProducts;
  final GetProductsByCategory getProductsByCategory;
  final ToggleDiscount toggleDiscountUseCase;
  final ProductRepository repository; // ✅ inject repo para updateStock

  List<Product> _products = [];
  bool _isLoaded = false;

  ProductProvider({
    required this.getAllProducts,
    required this.getProductsByCategory,
    required this.toggleDiscountUseCase,
    required this.repository,
  });

  List<Product> get products => _products;
  bool get isLoaded => _isLoaded;

  Future<void> loadProducts() async {
    _products = await getAllProducts();
    _isLoaded = true;
    notifyListeners();
  }

  Future<List<Product>> categoryProducts(String category) async {
    return getProductsByCategory(category);
  }

  Future<void> toggleDiscount(String id) async {
    await toggleDiscountUseCase(id);
    notifyListeners();
  }

  Future<void> updateStock(String id, String status) async {
    await repository.updateStock(id, status);
    final idx = _products.indexWhere((p) => p.id == id);
    if (idx != -1) {
      final old = _products[idx];
      _products[idx] = Product(
        id: old.id,
        name: old.name,
        category: old.category,
        price: old.price,
        stockStatus: status,
        quantity: old.quantity,
        isFeatured: old.isFeatured,
        hasDiscount: old.hasDiscount,
        lastRestocked: old.lastRestocked,
        hasWarranty: old.hasWarranty,
        warrantyDays: old.warrantyDays,
        isSeasonalItem: old.isSeasonalItem,
        availableSizes: old.availableSizes,
        expiryDate: old.expiryDate,
        isPerishable: old.isPerishable,
      );
      notifyListeners();
    }
  }
}
