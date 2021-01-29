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
      child:Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StreamBuilder(
                  stream:FirebaseFirestore.instance.collection('products').where('productKind',
                    isEqualTo: 'Plant',).limit(15).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final products = snapshot.data.docs;
                    return Container(
                      height: deviceHeight * 0.31,
                      margin: EdgeInsets.all(deviceWidth * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Plants',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(onPressed: (){}, child: Text('See more >',style: TextStyle(color: Theme.of(context).textTheme.headline1.color,),),),

                            ],
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
                    );
                  }
                ),
                StreamBuilder(
                  stream:FirebaseFirestore.instance.collection('products').where('productKind',
                    isEqualTo: 'Flowers',).limit(15).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final products = snapshot.data.docs;
                    return Container(
                      height: deviceHeight * 0.31,
                      margin: EdgeInsets.all(deviceWidth * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Flowers',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(onPressed: (){}, child: Text('See more >',style: TextStyle(color: Theme.of(context).textTheme.headline1.color,),),),
                            ],
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
                    );
                  }
                ),
                StreamBuilder(
                  stream:FirebaseFirestore.instance.collection('products').where('productKind',
                    isEqualTo: 'Accessories',).limit(15).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final products = snapshot.data.docs;
                    return Container(
                      height: deviceHeight * 0.31,
                      margin: EdgeInsets.all(deviceWidth * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Accessories',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(onPressed: (){}, child: Text('See more >',style: TextStyle(color: Theme.of(context).textTheme.headline1.color,),),),
                            ],
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
                    );
                  }
                ),
                StreamBuilder(
                  stream:FirebaseFirestore.instance.collection('products').where('productKind',
                    isEqualTo: 'Pot',).limit(15).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final products = snapshot.data.docs;
                    return Container(
                      height: deviceHeight * 0.31,
                      margin: EdgeInsets.all(deviceWidth * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pot',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(onPressed: (){}, child: Text('See more >',style: TextStyle(color: Theme.of(context).textTheme.headline1.color,),),),
                            ],
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
                    );
                  }
                ),
              ],
            ),

    );
  }
}
