import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_store/const/style.dart';
import 'package:grocery_store/inner_screens/details_screen.dart';
import 'package:grocery_store/model/view_model.dart';
import 'package:grocery_store/providers/view_provider.dart';
import 'package:provider/provider.dart';

import '../../const/firebase_const.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';

class ViewWidget extends StatefulWidget {
  const ViewWidget({Key? key}) : super(key: key);

  @override
  State<ViewWidget> createState() => _ViewWidgetState();
}

class _ViewWidgetState extends State<ViewWidget> {
  @override
  Widget build(BuildContext context) {
    final size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final productProvider = Provider.of<ProductProvider>(context);
    final viewedModel = Provider.of<ViewedModel>(context);
    final viewedProvider = Provider.of<ViewedProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final getCurrentProduct =
        productProvider.findProdById(viewedModel.productId);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    bool? isOnCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, DetailScreen.routeName);
      },
      child: Row(
        children: [
          FancyShimmerImage(
            width: size.width * .2,
            height: size.height * .17,
            imageUrl: getCurrentProduct.imageUrl,
            boxFit: BoxFit.fill,
          ),
          SizedBox(
            width: 13,
          ),
          Column(
            children: [
              Text(
                getCurrentProduct.title,
                style: mainStyle().copyWith(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${usedPrice.toStringAsFixed(2)}',
                style: subStyle().copyWith(fontSize: 20),
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: isOnCart
                    ? null
                    : () {
                        final User? user = authInstance.currentUser;
                        if (user == null) {
                          GlobalMethods.errorDialog(
                            context: context,
                            supTitle: 'No user found please login first',
                          );
                        }
                        GlobalMethods.addToCart(
                            productId: getCurrentProduct.id,
                            quantity: 1,
                            context: context);
                      },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    isOnCart ? Icons.check : IconlyBold.plus,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
