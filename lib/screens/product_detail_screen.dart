import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  @override
  final productName;
  final productPrice;
  final productImagePath;
  final productKind;
  final productDescription;
  final user;
  final productId;
  bool isProductFavourite;

  ProductDetailScreen({
    this.productName,
    this.productImagePath,
    this.productPrice,
    this.productKind,
    this.user,
    this.productDescription,
    this.productId,
    this.isProductFavourite = false,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    Future<void> addToFavorite(BuildContext context) async {
      setState(() {
        widget.isProductFavourite = !widget.isProductFavourite;
      });
      if (widget.isProductFavourite) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .collection('favoriteProducts')
            .doc(widget.productId)
            .set({
          'productName': widget.productName,
          'productId': widget.productId,
          'productPrice': widget.productPrice,
          'productDescription': widget.productDescription,
          'productKind': widget.productKind,
          'image_url': widget.productImagePath,
          'isProductFavourite': widget.isProductFavourite,
        });
        print('pro is added');
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Added to favorite list.',
              style: TextStyle(
                color: Theme.of(context).accentTextTheme.headline1.color,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .collection('favoriteProducts')
            .doc(widget.productId)
            .delete();
        print('pro is deleted');
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Deleted to favorite list.',
              style: TextStyle(
                color: Theme.of(context).accentTextTheme.headline1.color,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      }
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon:
                  Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            expandedHeight: deviceHeight * 0.4,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: EdgeInsets.symmetric(vertical: 1.5),
                width: double.infinity,
                // color: Theme.of(context).primaryColor.withOpacity(0.5),
                child: Text(
                  widget.productName,
                  textAlign: TextAlign.left,
                ),
              ),
              background: Container(
                color: Theme.of(context).backgroundColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                    image: DecorationImage(
                      image: FirebaseImage(
                          'gs://home-plant.appspot.com/${widget.productImagePath}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.productPrice}\$',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Builder(
                     builder: (context)=> IconButton(
                          icon: Icon(
                            widget.isProductFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () =>
                            addToFavorite(context),

                     )
                    )],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description :',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.productDescription,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 800,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
