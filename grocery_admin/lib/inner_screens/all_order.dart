import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/widgets/order_list.dart';
import 'package:provider/provider.dart';

import '../controllers/MenuController.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/header.dart';
import '../widgets/side_menu.dart';

class AllOrder extends StatefulWidget {
  const AllOrder({Key? key}) : super(key: key);

  @override
  State<AllOrder> createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    return Scaffold(
      key: context.read<MenuController>().getOrdersScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    children: [
                      Header(
                        showText: false,
                        title: 'All Orders',
                        fct: () {
                          context.read<MenuController>().controlAllOrders();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: OrderList()
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
