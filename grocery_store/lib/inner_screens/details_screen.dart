import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_store/providers/product_provider.dart';
import 'package:grocery_store/widget/back_widget.dart';
import 'package:grocery_store/widget/heart_btn.dart';
import 'package:provider/provider.dart';

import '../const/firebase_const.dart';
import '../const/style.dart';
import '../providers/cart_provider.dart';
import '../providers/view_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = '/DetailScreen';

  const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.findProdById(productId);
    final double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    final double totalPrice =
        usedPrice * int.parse(_quantityTextController.text);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isOnCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    final viewedProvider = Provider.of<ViewedProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        viewedProvider.addProductToViewed(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: BackWidget(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: FancyShimmerImage(
                  imageUrl: getCurrentProduct.imageUrl,
                  boxFit: BoxFit.fill,
                  height: size.height * .4,
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(.4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 30, right: 30, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(
                                getCurrentProduct.title,
                                style: mainStyle(),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: HeartButton(
                                productId: getCurrentProduct.id,
                                isInWishlist: isInWishlist,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 30, right: 20, bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              '\$${usedPrice.toStringAsFixed(2)}/',
                              style: mainStyle()
                                  .copyWith(color: Colors.green, fontSize: 20),
                            ),
                            Text(
                              getCurrentProduct.isPiece ? 'Piece' : 'Kg',
                              style: TextStyle(
                                color: color,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Visibility(
                              visible:
                                  getCurrentProduct.isOnSale ? true : false,
                              child: Text(
                                '\$${getCurrentProduct.salePrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: color,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 5),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12)),
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Free delivery',
                                    style: mainStyle()
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _quantityController(
                            function: () {
                              if (_quantityTextController.text == '1') {
                                return;
                              } else {
                                setState(() {
                                  _quantityTextController.text =
                                      (int.parse(_quantityTextController.text) -
                                              1)
                                          .toString();
                                });
                              }
                            },
                            icon: CupertinoIcons.minus,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    _quantityTextController.text = '1';
                                  } else {
                                    return;
                                  }
                                });
                              },
                              textAlign: TextAlign.center,
                              controller: _quantityTextController,
                              key: ValueKey('10'),
                              style: TextStyle(color: color, fontSize: 18),
                              keyboardType: TextInputType.number,
                              enabled: true,
                              maxLines: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]'))
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          _quantityController(
                            function: () {
                              setState(() {
                                _quantityTextController.text =
                                    (int.parse(_quantityTextController.text) +
                                            1)
                                        .toString();
                              });
                            },
                            icon: CupertinoIcons.plus,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(.4),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total',
                                  style:
                                      mainStyle().copyWith(color: Colors.red),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      Text(
                                        '\$${totalPrice.toStringAsFixed(2)}/',
                                        style: mainStyle(),
                                      ),
                                      Text(
                                        '${_quantityTextController.text}Kg',
                                        style: subStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12)),
                                child: InkWell(
                                  onTap: isOnCart
                                      ? null
                                      : () async{
                                          final User? user =
                                              authInstance.currentUser;
                                          if (user == null) {
                                            GlobalMethods.errorDialog(
                                              context: context,
                                              supTitle:
                                                  'No user found please login first',
                                            );
                                          }
                                          // cartProvider.addProductToCart(
                                          //   productId: getCurrentProduct.id,
                                          //   quantity: int.parse(
                                          //       _quantityTextController.text),
                                          // );
                                          await GlobalMethods.addToCart(
                                              productId: getCurrentProduct.id,
                                              quantity: int.parse(
                                                  _quantityTextController.text),
                                              context: context);
                                          await  cartProvider.fetchCart();
                                        },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      isOnCart ? 'In cart' : 'Add to cart',
                                      style: mainStyle()
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quantityController({
    required Function function,
    required IconData icon,
    required Color color,
  }) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () {
              function();
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
