import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  final String title;

  const CategoryPage({super.key, required this.category, required this.title});

  int _columnsForWidth(double width) {
    if (width < 600) return 2;
    if (width < 900) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    return FutureBuilder(
      future: provider.categoryProducts(category),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products in $title'));
        }
        final products = snapshot.data!;
        return LayoutBuilder(
          builder: (ctx, constraints) {
            final cols = _columnsForWidth(constraints.maxWidth);
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (ctx, i) => ProductCard(product: products[i]),
              ),
            );
          },
        );
      },
    );
  }
}
