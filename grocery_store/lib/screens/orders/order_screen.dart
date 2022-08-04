import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/widget/back_widget.dart';
import 'package:provider/provider.dart';

import '../../const/style.dart';
import '../../providers/order_provider.dart';
import '../../services/utils.dart';
import '../../widget/empty_cart.dart';
import 'order_widget.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/OrderScreen';

  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final orderProvider = Provider.of<OrdersProvider>(context);
    final ordersList = orderProvider.getOrders;
    return FutureBuilder(
      future: orderProvider.fetchOrders(),
      builder: (context, snapshot) {
        return ordersList.isEmpty
            ? EmptyScreen(
                title: 'No items in your cart',
                subTitle: "Add something and make me happy :",
                imgPath: 'assets/images/basket.png',
                textButton: 'Add a wish',
              )
            : Scaffold(
                appBar: AppBar(
                  leading: BackWidget(),
                  elevation: 0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Text(
                    'Your orders(${ordersList.length})',
                    style: mainStyle().copyWith(color: color),
                  ),
                ),
                body: ListView.separated(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 6),
                      child: ChangeNotifierProvider.value(
                        value: ordersList[index],
                        child: OrderWidget(),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: color,
                      thickness: 2,
                    );
                  },
                  itemCount: ordersList.length,
                ),
              );
      },
    );
  }
}
