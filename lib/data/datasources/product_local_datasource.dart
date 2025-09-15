import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:product_card_application/domain/entities/product.dart';
import '../models/product_model.dart';

/// ✅ Interface (abstract class)
abstract class ProductLocalDataSource {
  Future<List<Product>> loadProducts();
}

/// ✅ Implementation
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  @override
  Future<List<Product>> loadProducts() async {
    final data = await rootBundle.loadString('assets/test_data.json');
    final decoded = json.decode(data) as Map<String, dynamic>;
    final list = decoded['products'] as List<dynamic>;

    return list
        .map((e) => ProductModel.fromJson(e).toEntity()) // convert to entity
        .toList();
  }
}
