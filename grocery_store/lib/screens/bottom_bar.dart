import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/providers/dark_theme_provider.dart';
import 'package:grocery_store/screens/cart/cart.dart';
import 'package:grocery_store/screens/home.dart';
import 'package:grocery_store/screens/user.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'categories.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int currentIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'page': HomeScreen(), 'title': 'Home'},
    {'page': CategoriesScreen(), 'title': 'Categories'},
    {'page': CartScreen(), 'title': 'Cart'},
    {'page': UserScreen(), 'title': 'User'},
  ];

  void _selectedIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     _pages[currentIndex]['title'],
      //     style: TextStyle(color: isDark ? Colors.white : Colors.black87,fontSize: 22,fontWeight: FontWeight.bold),
      //   ),
      //   backgroundColor: isDark ? Color(0xFF00001a) : Color(0xFFFFFFFF),
      //   elevation: 0.6,
      //   centerTitle: false,
      // ),
      body: _pages[currentIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? Color(0xFF00001a) : Color(0xFFFFFFFF),
        unselectedItemColor: isDark ? Colors.white30 : Colors.black54,
        selectedItemColor: isDark ? Colors.lightBlue.shade200 : Colors.black87,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _selectedIndex,
        items: [
          BottomNavigationBarItem(
              icon:
                  Icon(currentIndex == 0 ? IconlyLight.home : IconlyLight.home),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(currentIndex == 1
                  ? IconlyLight.category
                  : IconlyLight.category),
              label: "Categories"),
          BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (_,myCart,ch){
                  return Badge(
                    toAnimate: true,
                    shape: BadgeShape.circle,
                    badgeColor: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                    position: BadgePosition.topEnd(top: -15, end: -7),
                    badgeContent: FittedBox(
                      child: Text(
                        myCart.getCartItems.length.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    child:
                    Icon(currentIndex == 2 ? IconlyLight.buy : IconlyLight.buy),
                  );
                },
              ),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(
                  currentIndex == 3 ? IconlyLight.user2 : IconlyLight.user2),
              label: "User"),
        ],
      ),
    );
  }
}
