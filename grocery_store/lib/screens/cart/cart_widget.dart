import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_store/const/style.dart';
import 'package:grocery_store/inner_screens/details_screen.dart';
import 'package:grocery_store/model/cart_model.dart';
import 'package:grocery_store/model/products_model.dart';
import 'package:grocery_store/providers/cart_provider.dart';
import 'package:grocery_store/providers/product_provider.dart';
import 'package:grocery_store/widget/heart_btn.dart';
import 'package:provider/provider.dart';

import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, required this.q}) : super(key: key);

  final int q;

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _quantityTextController.text = widget.q.toString();
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
    final productProvider = Provider.of<ProductProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrentProduct = productProvider.findProdById(cartModel.productId);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailScreen.routeName,
          arguments: cartModel.productId,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(.4),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: size.width * .25,
                  height: size.height * .2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FancyShimmerImage(
                    imageUrl: getCurrentProduct.imageUrl,
                    boxFit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getCurrentProduct.title,
                      style: mainStyle(),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: size.width * .3,
                      child: Row(
                        children: [
                          _quantityController(
                            function: () {
                              if (_quantityTextController.text == '1') {
                                return;
                              } else {
                                cartProvider
                                    .reduceQuantityByOne(cartModel.productId);
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
                              controller: _quantityTextController,
                              key: ValueKey('10'),
                              style: TextStyle(color: color, fontSize: 18),
                              keyboardType: TextInputType.number,
                              enabled: true,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]'))
                              ],
                            ),
                          ),
                          _quantityController(
                            function: () {
                              cartProvider
                                  .increaseQuantityByOne(cartModel.productId);
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
                    )
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async{
                      await cartProvider.removeOneItem(
                          cartId :cartModel.productId,
                          productId: cartModel.productId,
                          quantity: cartModel.quantity,
                        );
                      },
                      child: Icon(
                        CupertinoIcons.cart_badge_minus,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    HeartButton(
                      productId: getCurrentProduct.id,
                      isInWishlist: isInWishlist,
                    ),
                    Text(
                      '\$${(usedPrice * int.parse(_quantityTextController.text)).toStringAsFixed(2)}',
                      style: TextStyle(color: color, fontSize: 20),
                    ),
                  ],
                ),
              )
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
