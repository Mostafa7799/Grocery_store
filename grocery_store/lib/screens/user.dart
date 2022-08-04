import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_store/const/firebase_const.dart';
import 'package:grocery_store/const/style.dart';
import 'package:grocery_store/screens/auth/forget_pass.dart';
import 'package:grocery_store/screens/auth/login_screen.dart';
import 'package:grocery_store/screens/loading_screen.dart';
import 'package:grocery_store/screens/viewed/view_screen.dart';
import 'package:grocery_store/screens/wishlist/wishlist_screen.dart';
import 'package:grocery_store/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import 'orders/order_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: '');

  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  final User? user = authInstance.currentUser;
  bool isLoading = false;
  String? email;
  String? name;
  String? address;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
    if (user == null) {
      setState(() {
        isLoading = false;
      });
    }
    try {
      String uid = user!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc == null) {
        return;
      } else {
        email = userDoc.get('email');
        name = userDoc.get('name');
        address = userDoc.get('shipping address');
        _addressTextController.text = userDoc.get('shipping address');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      GlobalMethods.errorDialog(supTitle: '$error', context: context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black87;
    return LoadingScreen(
      isLoading: isLoading,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 23,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Hi,  ',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                      children: <TextSpan>[
                        TextSpan(
                            text: name == null ? 'user' : name,
                            style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                            recognizer: TapGestureRecognizer()..onTap = () {}),
                      ]),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  email == null ? 'user' : email!,
                  style: subStyle().copyWith(
                      color: color, fontWeight: FontWeight.w500, fontSize: 18),
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 20,
                ),
                _listTiles(
                  title: 'Address',
                  color: color,
                  subTitle: address == null ? 'Address' : address!,
                  iconLeading: IconlyLight.profile,
                  iconTrailing: IconlyLight.arrowRight2,
                  onPressed: () async {
                    await _showAddressDialog();
                  },
                ),
                _listTiles(
                  title: "Orders",
                  color: color,
                  iconLeading: IconlyLight.bag,
                  iconTrailing: IconlyLight.arrowRight2,
                  onPressed: () {
                    Navigator.pushNamed(context, OrderScreen.routeName);
                  },
                ),
                _listTiles(
                  title: "Wishlist",
                  color: color,
                  iconLeading: IconlyLight.heart,
                  iconTrailing: IconlyLight.arrowRight2,
                  onPressed: () {
                    Navigator.pushNamed(context, WishListScreen.routeName);
                  },
                ),
                _listTiles(
                  title: "Viewed",
                  color: color,
                  iconLeading: IconlyLight.show,
                  iconTrailing: IconlyLight.arrowRight2,
                  onPressed: () {
                    Navigator.pushNamed(context, ViewScreen.routeName);
                  },
                ),
                _listTiles(
                  title: "Forget Password",
                  color: color,
                  iconLeading: IconlyLight.unlock,
                  iconTrailing: IconlyLight.arrowRight2,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const ForgetPassword(),
                    ));
                  },
                ),
                SwitchListTile(
                  title: Text(
                    themeState.getDarkTheme ? "Dark mode" : "Light mode",
                    style: mainStyle(),
                  ),
                  secondary: Icon(themeState.getDarkTheme
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined),
                  onChanged: (bool value) {
                    setState(() {
                      themeState.setDarkTheme = value;
                    });
                  },
                  value: themeState.getDarkTheme,
                ),
                _listTiles(
                  title: user == null ? 'Login' : "Log Out",
                  color: color,
                  iconLeading: IconlyLight.logout,
                  iconTrailing: IconlyLight.arrowRight2,
                  onPressed: () async {
                    await GlobalMethods.warningDialog(
                      title: "Sign out",
                      supTitle: 'Do you wanna sign out?',
                      function: () async {
                        await authInstance.signOut();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                      },
                      context: context,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddressDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Address"),
          content: TextField(
            onChanged: (value) {
              print(
                  '_addressTextController.text${_addressTextController.text}');
            },
            controller: _addressTextController,
            maxLines: 5,
            decoration: InputDecoration(hintText: 'Your address'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String uid = user!.uid;
                try {
                  await FirebaseFirestore.instance.collection('users').doc(uid).update({
                    'shipping address' :_addressTextController.text,
                  });
                  Navigator.pop(context);
                  setState(() {
                    address = _addressTextController.text;
                  });
                } catch (error) {
                  GlobalMethods.errorDialog(
                    context: context,
                    supTitle: error.toString(),
                  );
                }
              },
              child: Text(
                'Update',
                style: mainStyle().copyWith(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _listTiles({
    required String title,
    String? subTitle,
    required IconData iconLeading,
    required IconData iconTrailing,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: Text(
        title,
        style: mainStyle(),
      ),
      subtitle: Text(
        subTitle == null ? "" : subTitle,
        style: subStyle(),
      ),
      leading: Icon(iconLeading),
      trailing: Icon(iconTrailing),
      onTap: () {
        onPressed();
      },
    );
  }
}
