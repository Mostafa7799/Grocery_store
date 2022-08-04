import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/const/style.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget(
      {Key? key,
      required this.salePrice,
      required this.price,
      required this.textPrice,
      required this.isOnSale})
      : super(key: key);

  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;

  @override
  Widget build(BuildContext context) {
    double userPrice = isOnSale ? salePrice : price;
    return FittedBox(
      child: Row(
        children: [
          Text(
            '\$${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}',
            style: mainStyle().copyWith(color: Colors.green, fontSize: 25),
          ),
          SizedBox(
            width: 5,
          ),
          Visibility(
            visible: isOnSale ? true : false,
            child: Text(
              '\$${(price * int.parse(textPrice)).toStringAsFixed(2)}',
              style: subStyle().copyWith(
                  decoration: TextDecoration.lineThrough,
                  fontSize: 20,
                  color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
