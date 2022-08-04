import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_store/const/firebase_const.dart';
import 'package:grocery_store/model/cart_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  void addProductToCart({
    required String productId,
    required int quantity,
  }) {
    _cartItems.putIfAbsent(
      productId,
      () => CartModel(
        id: DateTime.now().toString(),
        productId: productId,
        quantity: quantity,
      ),
    );
    notifyListeners();
  }

  void reduceQuantityByOne(String productId) {
    _cartItems.update(
      productId,
      (value) => CartModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity - 1,
      ),
    );
    notifyListeners();
  }


  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchCart() async {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDocs =
        await userCollection.doc(user!.uid).get();
    if (userDocs == null) {
      return;
    }
    final leng = userDocs.get('userCart').length;
    for (int i = 0; i < leng; i++) {
      _cartItems.putIfAbsent(
        userDocs.get('userCart')[i]['productId'],
        () => CartModel(
          id: userDocs.get('userCart')[i]['cartId'],
          productId: userDocs.get('userCart')[i]['productId'],
          quantity: userDocs.get('userCart')[i]['quantity'],
        ),
      );
    }
    notifyListeners();
  }

  void increaseQuantityByOne(String productId) {
    _cartItems.update(
      productId,
      (value) => CartModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity + 1,
      ),
    );
    notifyListeners();
  }

  Future<void> removeOneItem({
    required String productId,
    required String cartId,
    required int quantity,
}) async{
    final User? user = authInstance.currentUser;

    await userCollection.doc(user!.uid).update(
      {
        'userCart': FieldValue.arrayRemove([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': quantity,
          }
        ])
      }
    );
    _cartItems.remove(productId);
    await fetchCart();
    notifyListeners();
  }

  Future<void> deleteOnlineCart()async{
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update(
      {
        'userCart': [],
      }
    );
    _cartItems.clear();
    notifyListeners();
  }

  void clearAllItem() {
    _cartItems.clear();
    notifyListeners();
  }
}
