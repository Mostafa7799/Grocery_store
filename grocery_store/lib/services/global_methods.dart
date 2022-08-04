import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/const/firebase_const.dart';
import 'package:uuid/uuid.dart';

import '../const/style.dart';

class GlobalMethods {
  static Future<void> warningDialog({
    required String title,
    required String supTitle,
    required Function function,
    required BuildContext context,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Image.asset(
                'assets/images/warning-sign.png',
                height: 20,
                width: 20,
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: 8,
              ),
              Text(title),
            ],
          ),
          content: Text(
            supTitle,
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Cancel',
                style: mainStyle().copyWith(fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                function();
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Ok',
                style: mainStyle().copyWith(fontSize: 20, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> errorDialog({
    required BuildContext context,
    required String supTitle,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Image.asset(
                'assets/images/warning-sign.png',
                height: 20,
                width: 20,
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: 8,
              ),
              Text("Error Occurred"),
            ],
          ),
          content: Text(
            supTitle,
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Cancel',
                style: mainStyle().copyWith(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> addToCart({
    required String productId,
    required int quantity,
    required BuildContext context,
  }) async {
    final User? user = authInstance.currentUser;
    final uid = user!.uid;
    final cartId = Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': quantity,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: 'Product added to your cart',
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT
      );
    } catch (error) {
      errorDialog(context: context, supTitle: error.toString());
    }
  }

  static Future<void> addToWishlist(
      {required String productId, required BuildContext context}) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final wishlistId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'wishlistId': wishlistId,
            'productId': productId,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: "Item has been added to your wishlist",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } catch (error) {
      errorDialog(supTitle: error.toString(), context: context);
    }
  }
}
