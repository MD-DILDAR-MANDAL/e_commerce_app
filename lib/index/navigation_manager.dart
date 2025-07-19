import 'package:e_commerce_app/global_colors.dart';
import 'package:e_commerce_app/pages/home_screen.dart';
import 'package:e_commerce_app/pages/product_screen.dart';
import 'package:e_commerce_app/pages/profile_screen.dart';
import 'package:e_commerce_app/pages/search_screen.dart';
import 'package:flutter/material.dart';

class NavigationManager extends StatefulWidget {
  const NavigationManager({super.key});
  @override
  State<NavigationManager> createState() => _NavigationManagerState();
}

class _NavigationManagerState extends State<NavigationManager> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    ProductScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16,
        iconSize: 30,
        elevation: 6.0,
        enableFeedback: true,
        backgroundColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        selectedItemColor: primary,
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
