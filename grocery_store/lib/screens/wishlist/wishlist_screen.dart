import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery_store/const/style.dart';
import 'package:grocery_store/screens/wishlist/wishlist_widget.dart';
import 'package:grocery_store/widget/back_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/wishlist_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widget/empty_cart.dart';

class WishListScreen extends StatefulWidget {
  static const routeName = '/WishListScreen';

  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {

    final size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItems = wishlistProvider.getWishlistItems.values.toList().reversed.toList();

    return wishlistItems.isEmpty
        ? EmptyScreen(
            title: 'No items in your cart',
            subTitle: "Add something and make me happy :",
            imgPath: 'assets/images/wishlist.png',
            textButton: 'Shop now',
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Wishlist(${wishlistItems.length})',
                style: mainStyle().copyWith(color: color),
              ),
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: BackWidget(),
              actions: [
                IconButton(
                  onPressed: () async {
                    await GlobalMethods.warningDialog(
                      title: "Empty your wishlist",
                      supTitle: 'Are you sure?',
                      function: () async{
                       await wishlistProvider.deleteOnlineWishlist();
                        wishlistProvider.clearAllWishlist();
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
            body: MasonryGridView.count(
              itemCount: wishlistItems.length,
              crossAxisCount: 2,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                    value: wishlistItems[index],
                    child: WishlistWidget());
              },
            ),
          );
  }
}
