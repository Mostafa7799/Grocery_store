import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductModel with ChangeNotifier{

  String id,title,imageUrl,productCategoryName;
  double price,salePrice;
  bool isOnSale,isPiece;

  ProductModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.productCategoryName,
    required this.price,
    required this.salePrice,
    required this.isOnSale,
    required this.isPiece,
  });
}