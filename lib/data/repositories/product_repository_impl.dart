import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource dataSource;
  List<Product> _cache = [];

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<List<Product>> getAllProducts() async {
    if (_cache.isEmpty) {
      _cache = await dataSource.loadProducts();
      _cache.sort((a, b) => a.name.compareTo(b.name));
    }
    return _cache;
  }

  @override
  Future<List<Product>> getByCategory(String category) async {
    final all = await getAllProducts();
    return all.where((p) => p.category == category).toList();
  }

  @override
  Future<void> toggleDiscount(String id) async {
    final idx = _cache.indexWhere((p) => p.id == id);
    if (idx >= 0) {
      final old = _cache[idx];
      _cache[idx] = Product(
        id: old.id,
        name: old.name,
        category: old.category,
        price: old.price,
        stockStatus: old.stockStatus,
        quantity: old.quantity,
        isFeatured: old.isFeatured,
        hasDiscount: !old.hasDiscount,
        lastRestocked: old.lastRestocked,
        hasWarranty: old.hasWarranty,
        warrantyDays: old.warrantyDays,
        isSeasonalItem: old.isSeasonalItem,
        availableSizes: old.availableSizes,
        expiryDate: old.expiryDate,
        isPerishable: old.isPerishable,
      );
    }
  }

  Future<void> updateStock(String id, String newStatus) async {
    final idx = _cache.indexWhere((p) => p.id == id);
    if (idx >= 0) {
      final old = _cache[idx];
      _cache[idx] = Product(
        id: old.id,
        name: old.name,
        category: old.category,
        price: old.price,
        stockStatus: newStatus,
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
    }
  }
}
