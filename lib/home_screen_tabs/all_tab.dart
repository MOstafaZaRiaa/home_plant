import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_plant/widgts/poduct_item.dart';

class AllTab extends StatelessWidget {
  @override
  User user = FirebaseAuth.instance.currentUser;
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final products = snapshot.data.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.all(deviceWidth * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Best seller',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: deviceHeight * 0.24,
                      width: deviceWidth * 0.3,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) =>
                            ProductItem(
                          productName: products[index]['productName'],
                          productPrice: products[index]['productPrice'],
                          productImage: products[index]['image_url'],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   margin: EdgeInsets.all(deviceWidth * 0.01),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Sale',
              //         style: TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //       Container(
              //         height: deviceHeight * 0.23,
              //         width: deviceWidth * 0.3,
              //         child: ListView.builder(
              //           scrollDirection: Axis.horizontal,
              //           itemCount: 10,
              //           itemBuilder: (BuildContext context, int index) =>
              //               ProductItem(
              //             productName: snapshot.data['productName'],
              //             productPrice: snapshot.data['productPrice'],
              //             productImage: snapshot.data['image_url'],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.all(deviceWidth * 0.01),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Flowers',
              //         style: TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //       Container(
              //         height: deviceHeight * 0.23,
              //         width: deviceWidth * 0.3,
              //         child: ListView.builder(
              //           scrollDirection: Axis.horizontal,
              //           itemCount: 10,
              //           itemBuilder: (BuildContext context, int index) =>
              //               ProductItem(
              //             productName: snapshot.data['productName'],
              //             productPrice: snapshot.data['productPrice'],
              //             productImage: snapshot.data['image_url'],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.all(deviceWidth * 0.01),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Best seller',
              //         style: TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //       Container(
              //         height: deviceHeight * 0.23,
              //         width: deviceWidth * 0.3,
              //         child: ListView.builder(
              //           scrollDirection: Axis.horizontal,
              //           itemCount: 10,
              //           itemBuilder: (BuildContext context, int index) =>
              //               ProductItem(
              //             productName: snapshot.data['productName'],
              //             productPrice: snapshot.data['productPrice'],
              //             productImage: snapshot.data['image_url'],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}
