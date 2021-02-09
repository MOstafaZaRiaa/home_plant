import 'package:flutter/material.dart';

import 'package:home_plant/widgts/poduct_item.dart';

class GridViewForTabsBody extends StatefulWidget {
  @override
  final Stream stream;

  const GridViewForTabsBody({@required this.stream});

  @override
  _GridViewForTabsBodyState createState() => _GridViewForTabsBodyState();
}

class _GridViewForTabsBodyState extends State<GridViewForTabsBody> {
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
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
              productImagePath: products[index]['imagePath'],
              productId: products[index]['productId'],
              productDescription: products[index]['productDescription'],
              productKind: products[index]['productKind'],
            ),
          ),
        );
      },
    );
  }
}
