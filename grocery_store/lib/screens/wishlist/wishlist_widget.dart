import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_store/const/style.dart';
import 'package:grocery_store/inner_screens/details_screen.dart';
import 'package:grocery_store/model/wishlist_model.dart';
import 'package:grocery_store/widget/heart_btn.dart';
import 'package:provider/provider.dart';

import '../../model/products_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final productProvider = Provider.of<ProductProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final getCurrentProduct =
        productProvider.findProdById(wishlistModel.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, DetailScreen.routeName,
              arguments: wishlistModel.productId);
        },
        child: Container(
          height: size.height * .2,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 1),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  // height: size.height * .2,
                  // width: size.width * .24,
                  margin: EdgeInsets.only(left: 8),
                  child: FancyShimmerImage(
                    imageUrl: getCurrentProduct.imageUrl,
                    boxFit: BoxFit.fill,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(IconlyLight.bag2),
                          ),
                          // SizedBox(width: 4,),
                          HeartButton(
                            productId: getCurrentProduct.id,
                            isInWishlist: isInWishlist,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      getCurrentProduct.title,
                      style: mainStyle().copyWith(fontSize: 22),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Flexible(
                      child: Text(
                        '\$${usedPrice.toStringAsFixed(2)}',
                        style: mainStyle().copyWith(fontSize: 19),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
