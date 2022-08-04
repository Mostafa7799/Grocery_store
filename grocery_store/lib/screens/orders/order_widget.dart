import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/const/style.dart';
import 'package:grocery_store/inner_screens/details_screen.dart';
import 'package:grocery_store/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../../model/order_model.dart';
import '../../services/utils.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final orderModel = Provider.of<OrderModel>(context);
    var orderD = orderModel.orderDate.toDate();
    orderDateToShow = '${orderD.day}/${orderD.month}/${orderD.year}';
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final orderModel = Provider.of<OrderModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getProduct = productProvider.findProdById(orderModel.productId);
    return ListTile(
      subtitle: Text(
        'Paid \$ ${double.parse(orderModel.price).toStringAsFixed(2)}',
        style: subStyle().copyWith(fontSize: 18, color: color),
      ),
      onTap: () {
        //Navigator.pushNamed(context, DetailScreen.routeName);
      },
      leading: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: FancyShimmerImage(
          width: size.width * .2,
          imageUrl: getProduct.imageUrl,
          boxFit: BoxFit.fill,
        ),
      ),
      title: Text(
        '${getProduct.title} x${orderModel.quantity}',
        style: mainStyle().copyWith(fontSize: 20),
      ),
      trailing: Text(
        orderDateToShow,
        style: mainStyle().copyWith(fontSize: 20),
      ),
    );
  }
}
