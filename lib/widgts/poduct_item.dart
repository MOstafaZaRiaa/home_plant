import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final productName;
  final productPrice;
  final productImage;
  final isProductFavourite;

  const ProductItem(
      {this.productName,
      this.productImage,
      this.productPrice,
      this.isProductFavourite});
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return PhysicalModel(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(20),
      color: Theme.of(context).backgroundColor,
      child: Container(
        padding: EdgeInsets.all(deviceWidth * 0.03),

        child: Stack(
          children: [
            Container(
              height: deviceHeight * 0.25,
              width: deviceWidth * 0.3,
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(20)),
            ),
            Container(
                height: deviceHeight * 0.155,
                width: deviceWidth * 0.3,
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(20)),
                child: FadeInImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    productImage,
                  ),
                  placeholder: AssetImage('assets/images/plant_outline_dark.png'),
                ),
                ),
            Positioned(
              left: deviceWidth * .02,
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$productPrice\$',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: deviceWidth * 0.06,
                  ),
                  IconButton(
                      icon: Icon(Icons.add_circle_rounded), onPressed: () {}),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: Theme.of(context).accentTextTheme.headline1.color,
                ),
                onPressed: () {
                  bool isFavorite = false;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
