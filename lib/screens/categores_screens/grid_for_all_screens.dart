import 'package:flutter/material.dart';

import 'package:home_plant/screens/drawer_screen.dart';
import 'package:home_plant/widgts/poduct_item.dart';

class GridForAllScreens extends StatefulWidget {
  @override
  final Stream stream;
  final  title;

  const GridForAllScreens({@required this.stream,@required this.title,});

  @override
  _GridForAllScreensState createState() => _GridForAllScreensState();
}

class _GridForAllScreensState extends State<GridForAllScreens> {
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: StreamBuilder(
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
      ),
    );
  }
}
