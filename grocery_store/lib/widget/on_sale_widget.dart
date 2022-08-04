import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_store/inner_screens/details_screen.dart';
import 'package:grocery_store/inner_screens/on_sale_screen.dart';
import 'package:grocery_store/services/utils.dart';
import 'package:grocery_store/const/style.dart';
import 'package:grocery_store/widget/heart_btn.dart';
import 'package:grocery_store/widget/price_widget.dart';
import 'package:provider/provider.dart';

import '../const/firebase_const.dart';
import '../model/products_model.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/view_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final themeState = Utils(context: context).getTheme;
    final size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final productsProvider = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isOnCart = cartProvider.getCartItems.containsKey(productsProvider.id);
    bool? isInWishlist =
    wishlistProvider.getWishlistItems.containsKey(productsProvider.id);
    final viewProvider = Provider.of<ViewedProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme
            .of(context)
            .cardColor
            .withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            viewProvider.addProductToViewed(productId: productsProvider.id);
            Navigator.pushNamed(
              context,
              DetailScreen.routeName,
              arguments: productsProvider.id,
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FancyShimmerImage(
                      imageUrl: productsProvider.imageUrl,
                      width: size.width * .20,
                      height: size.height * .15,
                      boxFit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          productsProvider.isPiece ? '1Piece' : '1KG',
                          style: mainStyle().copyWith(fontSize: 19),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async{
                                final User? user = authInstance.currentUser;
                                if (user == null) {
                                  GlobalMethods.errorDialog(
                                    context: context,
                                    supTitle:
                                    'No user found please login first',
                                  );
                                }
                               await GlobalMethods.addToCart(
                                    productId: productsProvider.id,
                                    quantity: 1,
                                    context: context);

                              await  cartProvider.fetchCart();
                              },
                              child: Icon(
                                isOnCart ? IconlyBold.bag2 : IconlyLight.bag,
                                color: isOnCart ? Colors.green : color,
                                size: 23,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            HeartButton(
                              productId: productsProvider.id,
                              isInWishlist: isInWishlist,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                PriceWidget(
                  isOnSale: true,
                  price: productsProvider.price,
                  textPrice: '1',
                  salePrice: productsProvider.salePrice,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  productsProvider.title,
                  style: mainStyle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
