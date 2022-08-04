import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_store/providers/view_provider.dart';
import 'package:grocery_store/screens/viewed/view_widget.dart';
import 'package:grocery_store/widget/back_widget.dart';
import 'package:provider/provider.dart';

import '../../const/style.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widget/empty_cart.dart';

class ViewScreen extends StatelessWidget {
  static const routeName = '/ViewScreen';

  const ViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final viewedProvider = Provider.of<ViewedProvider>(context);
    final viewedItems =
        viewedProvider.getViewedItems.values.toList().reversed.toList();

    bool isEmpty = true;
    if (viewedItems.isEmpty) {
      return EmptyScreen(
        title: 'No items in your cart',
        subTitle: "Add something and make me happy :",
        imgPath: 'assets/images/history.png',
        textButton: 'Shop now',
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: BackWidget(),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Your views (${viewedItems.length})',
            style: mainStyle().copyWith(color: color),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await GlobalMethods.warningDialog(
                  title: "Empty your history",
                  supTitle: 'Are you sure?',
                  function: () {
                    viewedProvider.clearAllHistory();
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
        body: ListView.separated(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 6),
              child: ChangeNotifierProvider.value(
                value: viewedItems[index],
                child: ViewWidget(),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: color,
              thickness: 1.5,
            );
          },
          itemCount: viewedItems.length,
        ),
      );
    }
  }
}
