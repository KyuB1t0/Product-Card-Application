import 'package:product_card_application/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<List<Product>> getByCategory(String category);
  Future<void> toggleDiscount(String id);
  Future<void> updateStock(String id, String newStatus);
}
