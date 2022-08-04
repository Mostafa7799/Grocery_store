import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/widgets/text_widget.dart';

import '../services/utils.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget(
      {Key? key,
      required this.price,
      required this.totalPrice,
      required this.productId,
      required this.userId,
      required this.imageUrl,
      required this.userName,
      required this.quantity,
      required this.orderDate})
      : super(key: key);
  final double price, totalPrice;
  final String productId, userId, imageUrl, userName;
  final int quantity;
  final Timestamp orderDate;

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String dateToStr;
  @override
  void initState() {
    // TODO: implement initState
    var date = widget.orderDate.toDate();
    dateToStr ='${date.day}/${date.month}/${date.year}/';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Image.network(
                 widget.imageUrl,

                  fit: BoxFit.fill,
                  // height: screenWidth * 0.15,
                  // width: screenWidth * 0.15,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: '${widget.quantity}x For \$${widget.price.toStringAsFixed(2)}',
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'By ',
                            color: Colors.blue,
                            textSize: 16,
                            isTitle: true,
                          ),
                          TextWidget(
                            text: widget.userName,
                            color: color,
                            textSize: 14,
                            isTitle: true,
                          ),
                        ],
                      ),
                    ),
                     Text(
                      dateToStr,
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
