import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/const/firebase_const.dart';
import 'package:grocery_store/const/style.dart';
import 'package:grocery_store/widget/empty_cart.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/product_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import 'cart_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItems.isEmpty
        ? EmptyScreen(
            title: 'No items in your cart',
            subTitle: "Add something and make me happy :",
            imgPath: 'assets/images/cart.png',
            textButton: 'Shop now',
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                'Cart (${cartItems.length})',
                style: mainStyle().copyWith(color: color),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await GlobalMethods.warningDialog(
                      title: "Empty your cart",
                      supTitle: 'Are you sure?',
                      function: () async {
                        await cartProvider.deleteOnlineCart();
                        cartProvider.clearAllItem();
                      },
                      context: context,
                    );
                  },
                  icon: Icon(
                    IconlyBroken.delete,
                    color: color,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _checkOut(context: context),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, index) {
                      return ChangeNotifierProvider.value(
                        value: cartItems[index],
                        child: CartWidget(
                          q: cartItems[index].quantity,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget _checkOut({required BuildContext context}) {
    final size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrdersProvider>(context);

    var total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrentProduct = productProvider.findProdById(value.productId);
      total += (getCurrentProduct.isOnSale
              ? getCurrentProduct.salePrice
              : getCurrentProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * .1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () async {
                  final User? user = authInstance.currentUser;
                  final orderId = Uuid().v4();
                  final productProvider = Provider.of<ProductProvider>(context,listen: false);
                  cartProvider.getCartItems.forEach((key, value) async {
                    final getProduct =
                        productProvider.findProdById(value.productId);
                    try {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .set({
                        'orderId': orderId,
                        'userId': user!.uid,
                        'productId': value.productId,
                        'price': (getProduct.isOnSale
                                ? getProduct.salePrice
                                : getProduct.price) *
                            value.quantity,
                        'totalPrice': total,
                        'quantity': value.quantity,
                        'imageUrl': getProduct.imageUrl,
                        'userName': user.displayName,
                        'orderDate' : Timestamp.now(),
                      });
                      await cartProvider.deleteOnlineCart();
                      cartProvider.clearAllItem();
                      await orderProvider.fetchOrders();
                      await Fluttertoast.showToast(
                        msg: "Your order has been done",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.greenAccent
                      );
                    } catch (error) {
                      GlobalMethods.errorDialog(
                        context: context,
                        supTitle: error.toString(),
                      );
                    } finally {}
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Order now',
                    style: mainStyle().copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            Spacer(),
            FittedBox(
              child: Text(
                'Total \$ ${total.toStringAsFixed(2)}',
                style: mainStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
