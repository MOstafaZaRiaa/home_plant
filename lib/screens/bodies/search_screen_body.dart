import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_plant/widgts/poduct_item.dart';

class SearchScreenBody extends StatefulWidget {
  @override
  _SearchScreenBodyState createState() => _SearchScreenBodyState();
}

class _SearchScreenBodyState extends State<SearchScreenBody> {
  @override
  String productName = '';
  void initiateSearch(String val) {
    setState(() {
      productName = val.toLowerCase().trim();
      print(productName);
    });
  }

  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.01, vertical: deviceHeight * 0.01),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shadowColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                children: [
                  SizedBox(
                    width: deviceWidth * 0.02,
                  ),
                  Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: deviceWidth * 0.02,
                  ),
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      cursorColor: Theme.of(context).primaryColor,
                      onChanged: (value) => initiateSearch(value),
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Searching...",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: productName != "" && productName != null
                    ? FirebaseFirestore.instance
                        .collection('products')
                        .where("searchIndex", arrayContains: productName)
                        .snapshots()
                    : FirebaseFirestore.instance.collection("products").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  final products = snapshot.data.docs;
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Text('Loading...');
                    default:
                      return new Container(
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
                            productImagePath: products[index]['imagePath'],
                            productId: products[index]['productId'],
                            productDescription: products[index]['productDescription'],
                            productKind: products[index]['productKind'],
                          ),
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
