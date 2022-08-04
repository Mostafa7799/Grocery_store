import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/widgets/products_widget.dart';

import '../consts/constants.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    Key? key,
    this.crossAxisCount = 4,
    required this.childAspectRatio,
    this.isInMain = true,
  }) : super(key: key);
  final int crossAxisCount;
  final double childAspectRatio;

  final bool isInMain;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //there was a null error just add those lines
      stream: FirebaseFirestore.instance.collection('products').snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: isInMain && snapshot.data!.docs.length > 4
                    ? 4
                    : snapshot.data!.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: defaultPadding,
                  mainAxisSpacing: defaultPadding,
                ),
                itemBuilder: (context, index) {
                  return ProductsWidget(
                    id: snapshot.data!.docs[index]['id'],
                  );
                });
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('Your store is empty'),
              ),
            );
          }
        }
        return const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        );
      },
    );
  }
}
