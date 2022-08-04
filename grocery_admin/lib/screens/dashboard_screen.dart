import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/consts/constants.dart';
import 'package:grocery_admin_panel/inner_screens/add_product.dart';
import 'package:grocery_admin_panel/responsive.dart';
import 'package:grocery_admin_panel/widgets/buttons.dart';
import 'package:grocery_admin_panel/widgets/grid_products.dart';
import 'package:grocery_admin_panel/widgets/header.dart';
import 'package:grocery_admin_panel/widgets/order_list.dart';
import 'package:grocery_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../controllers/MenuController.dart';
import '../services/utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              fct: () {
                context.read<MenuController>().controlDashboarkMenu();
              },
              title: 'Dashboard',
            ),
            TextWidget(
              text: 'Latest products',
              color: color,
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonsWidget(
                    onPressed: () {},
                    text: 'View all',
                    icon: Icons.store,
                    backgroundColor: Colors.blue,
                  ),
                  ButtonsWidget(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddProducts(),
                          ));
                    },
                    text: 'Add products',
                    icon: Icons.add,
                    backgroundColor: Colors.blue,
                  ),
                ],
              ),
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Responsive(
                        mobile: ProductGrid(
                            crossAxisCount: size.width < 650 ? 2 : 4,
                            childAspectRatio:
                                size.width < 650 && size.width > 350
                                    ? 1.1
                                    : .8),
                        desktop: ProductGrid(
                            childAspectRatio: size.width < 1400 ? 0.8 : 1.05),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            OrderList()
          ],
        ),
      ),
    );
  }
}
