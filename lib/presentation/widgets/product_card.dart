import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  // Category badge colors
  Color _categoryColor() {
    switch (product.category) {
      case 'electronics':
        return Colors.blue;
      case 'clothing':
        return Colors.purple;
      case 'food':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Stock indicator colors
  Color _stockColor() {
    switch (product.stockStatus) {
      case 'inStock':
        return Colors.green;
      case 'lowStock':
        return Colors.amber;
      case 'outOfStock':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Build dropdown menu options based on conditions
  List<PopupMenuEntry<String>> _buildMenuItems(BuildContext context) {
    final items = <PopupMenuEntry<String>>[];

    items.add(const PopupMenuItem(value: 'view', child: Text('View Details')));

    if (product.stockStatus != 'inStock') {
      items.add(
        const PopupMenuItem(value: 'update_stock', child: Text('Update Stock')),
      );
    }

    if (!product.hasDiscount) {
      items.add(
        const PopupMenuItem(
          value: 'apply_discount',
          child: Text('Apply Discount'),
        ),
      );
    } else {
      items.add(
        const PopupMenuItem(
          value: 'remove_discount',
          child: Text('Remove Discount'),
        ),
      );
    }

    if (product.isElectronics &&
        (product.hasWarranty ?? false) &&
        (product.warrantyDays ?? 0) < 365) {
      items.add(
        const PopupMenuItem(
          value: 'extend_warranty',
          child: Text('Extend Warranty'),
        ),
      );
    }

    if (product.isClothing &&
        (product.isSeasonalItem ?? false) &&
        product.stockStatus != 'outOfStock') {
      items.add(
        const PopupMenuItem(
          value: 'mark_clearance',
          child: Text('Mark for Clearance'),
        ),
      );
    }

    if (product.isFood) {
      final days = product.daysUntilExpiry();
      if (days <= 7 ||
          ((product.isPerishable ?? false) &&
              product.stockStatus == 'lowStock')) {
        items.add(
          const PopupMenuItem(
            value: 'mark_quick_sale',
            child: Text('Mark for Quick Sale'),
          ),
        );
      }
    }

    return items;
  }

  void _onSelected(BuildContext context, String value) {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    switch (value) {
      case 'view':
        _showDetails(context);
        break;

      case 'update_stock':
        _showUpdateStock(context, provider);
        break;

      case 'apply_discount':
      case 'remove_discount':
        provider.toggleDiscount(product.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              value == 'apply_discount'
                  ? 'Discount applied'
                  : 'Discount removed',
            ),
          ),
        );
        break;

      case 'extend_warranty':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Warranty extended (demo)')),
        );
        break;

      case 'mark_clearance':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Marked for clearance')));
        break;

      case 'mark_quick_sale':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Marked for quick sale')));
        break;
    }
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${product.category}'),
            Text(
              'Price: ${NumberFormat.simpleCurrency().format(product.price)}',
            ),
            Text('Stock: ${product.stockStatus} (${product.quantity})'),
            if (product.isElectronics && (product.hasWarranty ?? false))
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shield, // warranty icon
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.warrantyDays} days',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            if (product.isClothing &&
                (product.availableSizes?.isNotEmpty ?? false))
              Text('Sizes: ${product.availableSizes!.join(", ")}'),
            if (product.isFood && product.expiryDate != null)
              Text(
                'Expiry: ${product.expiryDate} (${product.daysUntilExpiry()} days)',
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showUpdateStock(BuildContext context, ProductProvider provider) {
    String selected = product.stockStatus;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 👈 allows full-width / full-height layouts
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: MediaQuery.of(ctx).viewInsets, // para di matakpan ng keyboard
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // 👈 make children full width
                children: [
                  const Text(
                    'Update Stock Status',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selected,
                    items: const [
                      DropdownMenuItem(
                        value: 'inStock',
                        child: Text('inStock'),
                      ),
                      DropdownMenuItem(
                        value: 'lowStock',
                        child: Text('lowStock'),
                      ),
                      DropdownMenuItem(
                        value: 'outOfStock',
                        child: Text('outOfStock'),
                      ),
                    ],
                    onChanged: (v) => setState(() => selected = v!),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Stock Status',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      provider.updateStock(
                        product.id,
                        selected,
                      ); // demo placeholder
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // 🔹 blue background
                      foregroundColor: Colors.white, // 🔹 white text
                      minimumSize: const Size.fromHeight(48), // full width
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final priceStr = NumberFormat.simpleCurrency().format(product.price);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  itemBuilder: (ctx) => _buildMenuItems(ctx),
                  onSelected: (v) => _onSelected(context, v),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(priceStr, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _categoryColor().withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    product.category.toUpperCase(),
                    style: TextStyle(
                      color: _categoryColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 12, color: _stockColor()),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          product.stockStatus,
                          overflow:
                              TextOverflow.ellipsis, // para hindi lumampas
                          softWrap: false, // i-clip sa isang line
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (product.isElectronics && (product.hasWarranty ?? false))
              Text(
                'Warranty: ${product.warrantyDays} days',
                style: const TextStyle(fontSize: 12),
              ),
            if (product.isClothing &&
                (product.availableSizes?.isNotEmpty ?? false))
              Text(
                'Sizes: ${product.availableSizes!.join(", ")}',
                style: const TextStyle(fontSize: 12),
              ),
            if (product.isFood &&
                (product.expiryDate != null) &&
                product.daysUntilExpiry() < 30)
              Text(
                'Expires in ${product.daysUntilExpiry()} days',
                style: const TextStyle(fontSize: 12),
              ),
            const Spacer(),
            if (product.hasDiscount)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'DISCOUNT',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
