import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_plant/widgts/poduct_item.dart';

class AccessoriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where(
            'productKind',
            isEqualTo: 'Accessories',
          )
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final products = snapshot.data.docs;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.7,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: products.length,
          itemBuilder: (ctx, index) => ProductItem(
            productName: products[index]['productName'],
            productPrice: products[index]['productPrice'],
            productImage: products[index]['image_url'],
          ),
        );
      },
    );
  }
}
