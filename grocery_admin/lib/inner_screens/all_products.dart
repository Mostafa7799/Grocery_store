import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/MenuController.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/side_menu.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({Key? key}) : super(key: key);

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    return Scaffold(
      key: context.read<MenuController>().getgridscaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
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
                      title: 'All Products',
                      fct: () {
                        context.read<MenuController>().controlProductsMenu();
                      },
                    ),
                    Responsive(
                      mobile: ProductGrid(
                        crossAxisCount: size.width < 650 ? 2 : 4,
                        childAspectRatio:
                            size.width < 650 && size.width > 350 ? 1.1 : .8,
                        isInMain: false,
                      ),
                      desktop: ProductGrid(
                        childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                        isInMain: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
