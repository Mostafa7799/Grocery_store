import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/products_model.dart';

class ProductProvider with ChangeNotifier {
  static  List<ProductModel> _productsList = [];

  Future<void> fetchProduct() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((productSnapshot) {
          _productsList = [];
      productSnapshot.docs.forEach((element) {
        _productsList.insert(
          0,
          ProductModel(
            id: element.get('id'),
            title: element.get('title'),
            imageUrl: element.get('imageUrl'),
            productCategoryName: element.get('productCategoryName'),
            price: double.parse(element.get('price')),
            salePrice: element.get('salePrice'),
            isOnSale: element.get('isOnSale'),
            isPiece: element.get('isPiece'),
          ),
        );
      });
    });
    notifyListeners();
  }

  List<ProductModel> get getProductsModel {
    return _productsList;
  }

  List<ProductModel> get getOnSaleProductsModel {
    return _productsList.where((element) => element.isOnSale).toList();
  }

  ProductModel findProdById(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findByCategory(String categoryName) {
    List<ProductModel> _categoryList = _productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<ProductModel> search(String searchText) {
    List<ProductModel> _searchList = _productsList
        .where((element) => element.title
        .toLowerCase()
        .contains(searchText.toLowerCase()))
        .toList();
    return _searchList;
  }
}
