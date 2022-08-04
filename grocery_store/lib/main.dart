import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/const/style.dart';
import 'package:grocery_store/const/theme_data.dart';
import 'package:grocery_store/inner_screens/feeds_screen.dart';
import 'package:grocery_store/providers/dark_theme_provider.dart';
import 'package:grocery_store/providers/cart_provider.dart';
import 'package:grocery_store/providers/order_provider.dart';
import 'package:grocery_store/providers/product_provider.dart';
import 'package:grocery_store/providers/view_provider.dart';
import 'package:grocery_store/providers/wishlist_provider.dart';
import 'package:grocery_store/screens/auth/forget_pass.dart';
import 'package:grocery_store/screens/auth/login_screen.dart';
import 'package:grocery_store/screens/auth/register_screen.dart';
import 'package:grocery_store/screens/bottom_bar.dart';
import 'package:grocery_store/inner_screens/on_sale_screen.dart';
import 'package:grocery_store/screens/orders/order_screen.dart';
import 'package:grocery_store/screens/viewed/view_screen.dart';
import 'package:grocery_store/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

import 'fetch_screen.dart';
import 'inner_screens/cat_screen.dart';
import 'inner_screens/details_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePref.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshots.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text(
                  'An occurred error',
                  style: mainStyle(),
                ),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) {
              return themeChangeProvider;
            }),
            ChangeNotifierProvider(
              create: (_) => ProductProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => CartProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => WishlistProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => ViewedProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => OrdersProvider(),
            ),
          ],
          child: Consumer<DarkThemeProvider>(
              builder: (context, themeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: Style.themeData(themeProvider.getDarkTheme, context),
              home: FetchScreen(),
              routes: {
                OnSaleScreen.routeName: (context) => OnSaleScreen(),
                FeedsScreen.routeName: (context) => FeedsScreen(),
                DetailScreen.routeName: (context) => DetailScreen(),
                WishListScreen.routeName: (context) => WishListScreen(),
                OrderScreen.routeName: (context) => OrderScreen(),
                ViewScreen.routeName: (context) => ViewScreen(),
                RegisterScreen.routeName: (context) => RegisterScreen(),
                LoginScreen.routeName: (context) => LoginScreen(),
                ForgetPassword.routeName: (context) => ForgetPassword(),
                CategoryScreen.routeName: (context) => CategoryScreen(),
              },
            );
          }),
        );
      },
    );
  }
}
