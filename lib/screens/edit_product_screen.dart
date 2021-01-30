import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:home_plant/widgts/edit_product_item.dart';

class EditProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your products'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final products = snapshot.data.docs;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => EditProductItem(
                productName: products[index]['productName'],
                productImage: products[index]['image_url'],
                productPrice: products[index]['productPrice'].toString(),
            ),
          );
        },
      ),
    );
  }
}
