import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  final productName;
  final productPrice;
  final productImage;
  final productKind;
  final productDescription;
  final productId;
  bool isProductFavourite;

  ProductItem({
    this.productName,
    this.productImage,
    this.productPrice,
    this.productKind,
    this.productDescription,
    this.productId,
    this.isProductFavourite = false,
  });

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  User user = FirebaseAuth.instance.currentUser;

  Future<void> addToFavorite(BuildContext context) async {
    setState(() {
      widget.isProductFavourite = !widget.isProductFavourite;
    });
    if (widget.isProductFavourite) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favoriteProducts')
          .doc(widget.productId)
          .set({
        'productName': widget.productName,
        'productId': widget.productId,
        'productPrice': widget.productPrice,
        'productDescription': widget.productDescription,
        'productKind': widget.productKind,
        'image_url': widget.productImage,
        'isProductFavourite': widget.isProductFavourite,
      });
      print('pro is added');
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added from favorite list.',
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
          .doc(user.uid)
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

  //set value of favorite
  void initState() {
    final data = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favoriteProducts')
        .doc(widget.productId)
        .get();
    data.then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            widget.isProductFavourite = true;
          });
          // print(documentSnapshot.id.toString());
        } else {
          setState(() {
            widget.isProductFavourite = false;
          });
          print('Document does not exist on the database');
        }
      },
    );
    super.initState();
  }

  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return PhysicalModel(
      color: Theme.of(context).backgroundColor,
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(deviceWidth * 0.03),
        child: Stack(
          children: [
            Container(
              // height: deviceHeight * 0.25,
              // width: deviceWidth * 0.3,
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(20)),
            ),
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: deviceHeight * 0.155,
                    width: deviceWidth * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: widget.productImage == null
                              ? AssetImage(
                                  'assets/images/plant_outline_dark.png')
                              : FirebaseImage(
                                  'gs://home-plant.appspot.com/${widget.productImage}',
                                ),
                          fit: BoxFit.cover),
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productName.length < 7
                                ? widget.productName
                                : widget.productName.substring(0, 7),
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.productPrice}\$',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        // alignment: Alignment.centerRight,
                        icon: Icon(Icons.add_circle_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: Icon(
                  widget.isProductFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Theme.of(context).accentTextTheme.headline1.color,
                ),
                onPressed: () {
                  addToFavorite(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
