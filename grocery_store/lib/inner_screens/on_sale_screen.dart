import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_store/const/style.dart';
import 'package:grocery_store/widget/empty_cart.dart';
import 'package:grocery_store/widget/empty_product.dart';
import 'package:grocery_store/widget/on_sale_widget.dart';
import 'package:provider/provider.dart';

import '../model/products_model.dart';
import '../providers/product_provider.dart';
import '../services/utils.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = '/OnSaleScreen';

  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Utils utils = Utils(context: context);
    Size size = utils.getScreenSize;
    final color = utils.color;
    final productsProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> productsOnSale = productsProvider.getOnSaleProductsModel;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Icon(
            IconlyLight.arrowLeft2,
            color: color,
            size: 30,
          ),
        ),
        title: Text(
          'Product on sale',
          style: mainStyle().copyWith(color: color),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: productsOnSale.isEmpty
          ? EmptyProduct(text: 'Not products is on sale yet!,\n Stay tuned',)
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  padding: EdgeInsets.zero,
                  childAspectRatio: size.width / size.height * 1.4,
                  children: List.generate(
                    productsOnSale.length,
                    (index) {
                      return ChangeNotifierProvider.value(
                          value: productsOnSale[index],
                          child: OnSaleWidget()
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
