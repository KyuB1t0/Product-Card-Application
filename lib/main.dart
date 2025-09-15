import 'package:flutter/material.dart';
import 'package:product_card_application/presentation/pages/root_screen.dart';
import 'package:provider/provider.dart';
import 'data/datasources/product_local_datasource.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/usecases/get_all_products.dart';
import 'domain/usecases/get_products_by_category.dart';
import 'domain/usecases/toggle_discount.dart';
import 'presentation/providers/product_provider.dart';

void main() {
  final dataSource = ProductLocalDataSourceImpl();
  final repository = ProductRepositoryImpl(dataSource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            getAllProducts: GetAllProducts(repository),
            getProductsByCategory: GetProductsByCategory(repository),
            toggleDiscountUseCase: ToggleDiscount(repository),
            repository: repository,
          )..loadProducts(),
        ),
      ],
      child: const ProductApp(),
    ),
  );
}

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Manager (Clean Arch)',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RootScreen(),
    );
  }
}
