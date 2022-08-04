import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/inner_screens/add_product.dart';
import 'package:grocery_admin_panel/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


import 'consts/theme_data.dart';
import 'controllers/MenuController.dart';
import 'providers/dark_theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitializeApp = Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyAduXeHTkQ3qToRGK7uvRENkq-Y_Zw-2Jo",
        authDomain: "grocery-d6fec.firebaseapp.com",
        projectId: "grocery-d6fec",
        storageBucket: "grocery-d6fec.appspot.com",
        messagingSenderId: "28668012463",
        appId: "1:28668012463:web:af93d6ce490c644013b15a",
        measurementId: "G-NG7971QHSD"
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInitializeApp,
      builder: (context,snapshots){
        if (snapshots.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }else if(snapshots.hasError){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text('An occurred error',),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => MenuController(),
            ),
            ChangeNotifierProvider(
              create: (_) {
                return themeChangeProvider;
              },
            ),
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Grocery',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: const MainScreen(),
                routes: {
                  AddProducts.routeName: (context) => AddProducts(),
                },
              );
            },
          ),
        );
      }
    );
  }
}
