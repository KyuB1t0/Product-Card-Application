import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'home_page.dart';
import 'category_page.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'Home',
    'Electronics',
    'Clothing',
    'Food',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 2, // ✨ mas subtle na shadow
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue, // kulay ng title at icons
        centerTitle: false,
      ),
      body: provider.isLoaded
          ? IndexedStack(
              index: _selectedIndex,
              children: const [
                HomePage(),
                CategoryPage(category: 'electronics', title: 'Electronics'),
                CategoryPage(category: 'clothing', title: 'Clothing'),
                CategoryPage(category: 'food', title: 'Food'),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // white background
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // selected = blue
        unselectedItemColor: Colors.black, // unselected = black
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed, // para makita lahat ng labels
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label: 'Electronics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom),
            label: 'Clothing',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Food'),
        ],
      ),
    );
  }
}
