import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:home_plant/widgts/poduct_item.dart';

class FavoriteScreenBody extends StatelessWidget {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favoriteProducts')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if(!snapshot.hasData){
          return Center(child: Text('Wait until we add products..'),);
        }
        final products = snapshot.data.docs;
        return Container(
           margin: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: products.length,
            itemBuilder: (ctx, index) => ProductItem(
              productName: products[index]['productName'],
              productPrice: products[index]['productPrice'],
              productImage: products[index]['image_url'],
              productId: products[index]['productId'],
              productDescription: products[index]['productDescription'],
              productKind: products[index]['productKind'],
              isProductFavourite: products[index]['isProductFavourite'],
            ),
          ),
        );
      },
    );
  }
}

