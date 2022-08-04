import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_store/const/firebase_const.dart';

import '../model/order_model.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrderModel> orders = [];

  List<OrderModel> get getOrders {
    return orders;
  }

  Future<void> fetchOrders() async {
    User? user = authInstance.currentUser;
    await FirebaseFirestore.instance
        .collection('orders').where('userId',isEqualTo: user!.uid )
        .get()
        .then((orderSnapshot) {
      orders = [];
      orderSnapshot.docs.forEach((element) {
        orders.insert(
            0,
            OrderModel(
              orderId: element.get('orderId'),
              userId: element.get('userId'),
              productId: element.get('productId'),
              userName: element.get('userName'),
              price: element.get('price').toString(),
              imageUrl: element.get('imageUrl'),
              quantity: element.get('quantity').toString(),
              orderDate: element.get('orderDate'),
            ));
      });
    });
    notifyListeners();
  }

  void clearAllOrders() {
    orders.clear();
    notifyListeners();
  }
}
