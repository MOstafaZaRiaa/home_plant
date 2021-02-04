import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_plant/screens/check_out_screen.dart';
import 'package:home_plant/widgts/product_item_in_cart.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  int length = 0;
  double total = 0;

  User user = FirebaseAuth.instance.currentUser;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final products = snapshot.data.docs;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductItemInCart(
                        productName: products[index]['productName'],
                        productPrice: products[index]['productPrice'],
                        productImagePath: products[index]['imagePath'],
                        productId: products[index]['productId'],
                        user: user,
                        totalPrice: products[index]['totalPrice'],
                        productAmount: products[index]['productAmount'],
                      );
                    },
                  ),
                ),
                InkWell(
                  child: FlatButton(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.024),
                    child: Text(
                      'PROCEED',
                      style: TextStyle(
                          color: Theme.of(context)
                              .accentTextTheme
                              .headline1
                              .color),
                    ),
                    onPressed: products.length == 0
                        ? () {}
                        : () async {
                      total = 0;
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('cart')
                                .get()
                                .then((QuerySnapshot querySnapshot) => {
                                      querySnapshot.docs.forEach((doc) {
                                        total = total + doc['totalPrice'] ;
                                      }),
                                    });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckOutScreen(
                                  int: total,
                                ),
                              ),
                            );
                          },
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
