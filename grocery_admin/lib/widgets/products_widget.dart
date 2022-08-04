import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/screens/loading_screen.dart';
import 'package:grocery_admin_panel/services/utils.dart';
import 'package:grocery_admin_panel/widgets/text_widget.dart';

import '../inner_screens/edit_product.dart';
import '../services/global_method.dart';

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  bool isLoading =false;
  String title = '';
  String productCat = '';
  String? imageUrl;
  String price = '0.0';
  double salePrice = 0.0;
  bool isOnSale = false;
  bool isPiece = false;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final  DocumentSnapshot productDoc =
      await FirebaseFirestore.instance.collection('products').doc(widget.id).get();
      if (productDoc == null) {
        return;
      } else {
        //email = userDoc.get('email');
         title = productDoc.get('title');
         productCat = productDoc.get('productCategoryName');
         imageUrl = productDoc.get('imageUrl');
         price = productDoc.get('price');
         salePrice = productDoc.get('salePrice');
         isOnSale = productDoc.get('isOnSalePrice');
         isPiece = productDoc.get('isPiece');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      //GlobalMethods.errorDialog(supTitle: '$error', context: context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final color = Utils(context).color;

    return LoadingScreen(
      isLoading: isLoading,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor.withOpacity(.6),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProductScreen(
                    id: widget.id,
                    title: title,
                    price: price,
                    salePrice: salePrice,
                    productCat: productCat,
                    imageUrl: imageUrl == null
                        ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                        : imageUrl!,
                    isOnSale: isOnSale,
                    isPiece: isPiece,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Image.network(
                          imageUrl ==null?
                          "https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png"
                          : imageUrl!,
                          fit: BoxFit.fill,
                          height: size.width * .12,
                        ),
                      ),
                      Spacer(),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text(
                              'Edit',
                            ),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                            value: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: isOnSale
                            ? '\$${salePrice.toStringAsFixed(2)}'
                            : '\$$price',
                        color: color,
                        textSize: 18,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Visibility(
                          visible: isOnSale,
                          child: Text(
                            '\$$price',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: color),
                          )),
                      const Spacer(),
                      TextWidget(
                        text: isPiece ? 'Piece' : '1Kg',
                        color: color,
                        textSize: 18,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  TextWidget(
                    text: title,
                    color: color,
                    isTitle: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
