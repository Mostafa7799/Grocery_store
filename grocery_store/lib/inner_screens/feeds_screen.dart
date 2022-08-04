import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_store/const/contss.dart';
import 'package:grocery_store/model/products_model.dart';
import 'package:grocery_store/providers/product_provider.dart';
import 'package:grocery_store/widget/back_widget.dart';
import 'package:grocery_store/widget/feeds_widget.dart';
import 'package:provider/provider.dart';

import '../const/style.dart';
import '../services/utils.dart';
import '../widget/empty_product.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = '/FeedsScreen';

  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController? _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<ProductModel> listSearch = [];

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController!.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Utils utils = Utils(context: context);
    Size size = utils.getScreenSize;
    final color = utils.color;
    final productsProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> allProducts = productsProvider.getProductsModel;
    return Scaffold(
      appBar: AppBar(
        leading: BackWidget(),
        title: Text(
          'All Products',
          style: mainStyle().copyWith(color: color),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 15),
              child: Container(
                height: size.height * .077,
                child: TextFormField(
                  focusNode: _searchFocusNode,
                  enabled: true,
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      listSearch = productsProvider.search(value);
                    });
                  },
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.green, width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.green, width: 2)),
                      hintText: "  What's in your mind!",
                      prefix: Icon(
                        Icons.search,
                      ),
                      suffix: IconButton(
                          onPressed: () {
                            _searchController!.clear();
                            _searchFocusNode.unfocus();
                          },
                          icon: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 5),
                            child: Icon(
                              Icons.close,
                              color: _searchFocusNode.hasFocus
                                  ? Colors.red
                                  : Colors.greenAccent,
                            ),
                          ))),
                ),
              ),
            ),
            _searchController!.text.isNotEmpty && listSearch.isEmpty
                ? EmptyProduct(
                    text: 'No products found, please enter a valid keyword')
                : GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    padding: EdgeInsets.zero,
                    childAspectRatio: size.width / size.height * 1.1,
                    children: List.generate(
                      _searchController!.text.isNotEmpty
                          ? listSearch.length
                          : allProducts.length,
                      (index) {
                        return ChangeNotifierProvider.value(
                          value: _searchController!.text.isNotEmpty
                              ? listSearch[index]
                              : allProducts[index],
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
