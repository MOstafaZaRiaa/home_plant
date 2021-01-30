import 'package:flutter/material.dart';
import 'package:home_plant/widgts/poduct_item.dart';

class GridViewForTabsBody extends StatelessWidget {
  @override
  final Stream stream;

  const GridViewForTabsBody({@required this.stream});
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
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
