import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_store/const/contss.dart';
import 'package:grocery_store/const/style.dart';
import 'package:grocery_store/inner_screens/feeds_screen.dart';
import 'package:grocery_store/inner_screens/on_sale_screen.dart';
import 'package:grocery_store/services/utils.dart';
import 'package:grocery_store/widget/feeds_widget.dart';
import 'package:grocery_store/widget/on_sale_widget.dart';
import 'package:provider/provider.dart';

import '../model/products_model.dart';
import '../providers/product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Utils utils = Utils(context: context);
    final themeState = utils.getTheme;
    Size size = utils.getScreenSize;
    final color = utils.color;
    final productsProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> allProducts = productsProvider.getProductsModel;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * .33,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    Consts.offerImage[index],
                    fit: BoxFit.fill,
                  );
                },
                itemCount: Consts.offerImage.length,
                pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.white,
                      activeColor: Colors.red,
                    )),
                autoplay: true,
                control: SwiperControl(color: Colors.amber),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, OnSaleScreen.routeName);
              },
              child: Text(
                'View all',
                style: TextStyle(color: Colors.blue, fontSize: 22),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: Row(
                    children: [
                      Text(
                        'on sale'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        IconlyLight.discount,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: SizedBox(
                    height: size.height * .3,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: allProducts.length > 5 ? 5 : allProducts.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: allProducts[index],
                            child:OnSaleWidget()
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Our product',
                    style: mainStyle().copyWith(fontSize: 22, color: color),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, FeedsScreen.routeName);
                    },
                    child: Text(
                      'Browse all',
                      style: mainStyle()
                          .copyWith(color: Colors.blue, fontSize: 22),
                    ),
                  )
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              childAspectRatio: size.width / size.height * 1.1,
              children: List.generate(
                allProducts.length < 4 ? allProducts.length : 6,
                (index) {
                  return ChangeNotifierProvider.value(
                    value: allProducts[index],
                    child: FeedsWidget(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
