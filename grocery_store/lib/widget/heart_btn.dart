import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_store/const/firebase_const.dart';
import 'package:grocery_store/providers/wishlist_provider.dart';
import 'package:grocery_store/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../model/products_model.dart';
import '../providers/product_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/utils.dart';

class HeartButton extends StatefulWidget {
  const HeartButton({
    Key? key,
    required this.productId,
    required this.isInWishlist,
  }) : super(key: key);
  final String productId;
  final bool? isInWishlist;

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).color;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.findProdById(widget.productId);

    bool isLoading = false;

    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        try {
          final User? user = authInstance.currentUser;

          if (user == null) {
            GlobalMethods.errorDialog(
                supTitle: 'No user found, Please login first',
                context: context);
            return;
          }
          if (widget.isInWishlist == false && widget.isInWishlist != null) {
            await GlobalMethods.addToWishlist(
                productId: widget.productId, context: context);
          } else {
            await wishlistProvider.removeOneItem(
                wishlistId:
                    wishlistProvider.getWishlistItems[getCurrentProduct.id]!.id,
                productId: widget.productId);
          }
          await wishlistProvider.fetchWishlist();
          setState(() {
            isLoading = false;
          });
        } catch (error) {
          GlobalMethods.errorDialog(supTitle: '$error', context: context);
        } finally {
          setState(() {
            isLoading = false;
          });
        }
        // print('user id is ${user.uid}');
        // wishlistProvider.addRemoveProductToWishlist(productId: productId);
      },
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator()),
            )
          : Icon(
              widget.isInWishlist != null && widget.isInWishlist == true
                  ? IconlyBold.heart
                  : IconlyLight.heart,
              size: 22,
              color: widget.isInWishlist != null && widget.isInWishlist == true
                  ? Colors.red
                  : color,
            ),
    );
  }
}
