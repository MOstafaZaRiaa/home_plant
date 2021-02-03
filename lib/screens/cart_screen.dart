import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_plant/widgts/product_item_in_cart.dart';

class CartScreen extends StatelessWidget {
  @override
  User user = FirebaseAuth.instance.currentUser;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('cart').snapshots(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                final products = snapshot.data.docs;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index)=>ProductItemInCart(
                    productName: products[index]['productName'],
                    productPrice: products[index]['productPrice'],
                    productImagePath: products[index]['imagePath'],
                    productId: products[index]['productId'],
                    user :user,
                    productAmount:  products[index]['productAmount'],
                  ),
                );
              }
            ),
          ),
          InkWell(
            child: FlatButton(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.024),
              child: Text(
                'PROCEED',
                style: TextStyle(
                    color: Theme.of(context).accentTextTheme.headline1.color),
              ),
              onPressed: () {},
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
