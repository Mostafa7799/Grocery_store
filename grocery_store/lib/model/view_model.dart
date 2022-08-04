import 'package:flutter/cupertino.dart';

class ViewedModel with ChangeNotifier {
  final String id, productId;

  ViewedModel({
    required this.id,
    required this.productId,
  });
}
