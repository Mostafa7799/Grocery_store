import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocery_store/const/contss.dart';
import 'package:grocery_store/const/firebase_const.dart';
import 'package:grocery_store/providers/cart_provider.dart';
import 'package:grocery_store/providers/order_provider.dart';
import 'package:grocery_store/providers/product_provider.dart';
import 'package:grocery_store/providers/wishlist_provider.dart';
import 'package:grocery_store/screens/bottom_bar.dart';
import 'package:provider/provider.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  List<String> images = Consts.authImages;
   @override
  void initState() {
    // TODO: implement initState
     images.shuffle();
    Future.delayed(Duration(microseconds: 5), () async {
      final User? user = authInstance.currentUser;

      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      final cartProvider =
      Provider.of<CartProvider>(context, listen: false);
      final wishlistProvider =
      Provider.of<WishlistProvider>(context, listen: false);
      final orderProvider =
      Provider.of<OrdersProvider>(context, listen: false);
      if(user == null){
        await productProvider.fetchProduct();
        cartProvider.clearAllItem();
        wishlistProvider.clearAllWishlist();
        orderProvider.clearAllOrders();
      }else{
        await productProvider.fetchProduct();
        await cartProvider.fetchCart();
        await wishlistProvider.fetchWishlist();
      }
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomBarScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            images[0],
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(color: Colors.black87.withOpacity(0.7),),
          Center(
            child: SpinKitFadingFour(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
