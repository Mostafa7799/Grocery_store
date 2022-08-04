import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocery_store/inner_screens/details_screen.dart';
import 'package:grocery_store/model/products_model.dart';
import 'package:grocery_store/providers/cart_provider.dart';
import 'package:grocery_store/providers/view_provider.dart';
import 'package:grocery_store/providers/wishlist_provider.dart';
import 'package:grocery_store/widget/heart_btn.dart';
import 'package:grocery_store/widget/price_widget.dart';
import 'package:provider/provider.dart';

import '../const/style.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isOnCart = cartProvider.getCartItems.containsKey(productModel.id);
    bool? isOnWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    final viewProvider = Provider.of<ViewedProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(.4),
        child: InkWell(
          onTap: () {
            viewProvider.addProductToViewed(productId: productModel.id);
            Navigator.pushNamed(
              context,
              DetailScreen.routeName,
              arguments: productModel.id,
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: productModel.imageUrl,
                width: size.width * .2,
                height: size.height * .21,
                boxFit: BoxFit.fill,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Text(
                        productModel.title,
                        style: mainStyle().copyWith(color: color, fontSize: 20),
                        maxLines: 1,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: HeartButton(
                        productId: productModel.id,
                        isInWishlist: isOnWishlist,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: PriceWidget(
                        isOnSale: productModel.isOnSale,
                        price: productModel.price,
                        textPrice: _quantityTextController.text,
                        salePrice: 2.4,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(
                            child: Text(productModel.isPiece ? "Piece" : 'Kg',
                                style: mainStyle().copyWith(fontSize: 19)),
                          ),
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    _quantityTextController.text = '1';
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
                                    RegExp('[0-9.]'))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: isOnCart
                      ? null
                      : () async {
                          // cartProvider.addProductToCart(
                          //   productId: productsProvider.id,
                          //   quantity: int.parse(_quantityTextController.text),
                          // );
                          await GlobalMethods.addToCart(
                              productId: productModel.id,
                              quantity: int.parse(_quantityTextController.text),
                              context: context);
                          await cartProvider.fetchCart();
                        },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).cardColor.withOpacity(.5)),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          ),
                        ),
                      )),
                  child: Text(
                    isOnCart ? 'In cart' : 'Add to cart',
                    style: mainStyle().copyWith(color: color),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
