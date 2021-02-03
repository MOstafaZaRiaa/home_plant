import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductItemInCart extends StatefulWidget {
  @override
  final productImagePath;
  final productName;
  final productPrice;
  final productId;
  final productAmount;
  final User user;
  const ProductItemInCart({
    this.productImagePath,
    this.productName,
    this.productAmount,
    this.productPrice,
    this.productId,
    this.user,
  });
  _ProductItemInCartState createState() => _ProductItemInCartState();
}

class _ProductItemInCartState extends State<ProductItemInCart> {
  @override
  int productAmount = 1;
  Future<void> deleteFromCart(BuildContext context)async{

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('cart')
        .doc(widget.productId)
        .delete();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Deleted from cart.',
          style: TextStyle(
            color: Theme.of(context).accentTextTheme.headline1.color,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );

  }
  Future<void> increaseAndDecreaseProductAmount(int proAmount)async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('cart')
        .doc(widget.productId)
        .update({
      'productAmount' : proAmount,
    });
  }

  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: deviceHeight * 0.18,
      margin: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.02, vertical: deviceHeight * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: deviceWidth * 0.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: widget.productImagePath == null
                      ? AssetImage(
                      'assets/images/plant_outline_dark.png')
                      : FirebaseImage(
                    'gs://home-plant.appspot.com/${widget.productImagePath}',
                  ),
                  fit: BoxFit.cover,
                ),
            ),
          ),
          SizedBox(
            width: deviceWidth * 0.03,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.productName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.02,
              ),
              Text(
                '${widget.productPrice}\$',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Builder(builder:(context)=> IconButton(
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: ()=>deleteFromCart(context),
              ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.minimize_rounded,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        setState(() {
                          if (productAmount > 1) {
                            productAmount = productAmount -1;
                            increaseAndDecreaseProductAmount(productAmount);
                          }
                        });
                      }),
                  Container(
                    child: Text(
                      widget.productAmount.toString(),
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        setState(() {
                          productAmount = productAmount + 1;
                          increaseAndDecreaseProductAmount(productAmount);
                        });
                      }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
