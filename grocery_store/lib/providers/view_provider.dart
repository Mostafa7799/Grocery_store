import 'package:flutter/cupertino.dart';
import 'package:grocery_store/model/wishlist_model.dart';

import '../model/view_model.dart';

class ViewedProvider with ChangeNotifier {
  Map<String, ViewedModel> _viewedItems = {};

  Map<String, ViewedModel> get getViewedItems {
    return _viewedItems;
  }

  void addProductToViewed({required productId}) {
      _viewedItems.putIfAbsent(
        productId,
            () => ViewedModel(
          id: DateTime.now().toString(),
          productId: productId,
        ),
      );
    notifyListeners();
  }

  void clearAllHistory() {
    _viewedItems.clear();
    notifyListeners();
  }
}
