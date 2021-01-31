import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_plant/screens/edit_product_screen.dart';

class EditProductItem extends StatelessWidget {
  @override
  final String productImage;
  final String productName;
  final String productPrice;
  final String productId;
  final String productKind;
  final String productDescription;
  const EditProductItem(
      {this.productImage, this.productName, this.productPrice, this.productId,this.productKind,this.productDescription,});

  //delete product dialog
  Future<void> deleteProduct(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('راجع نفسك في الي انت بتعمله..'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you Sure.',),
                Text('Would you need to delete this product?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes',style: TextStyle(color: Theme.of(context).errorColor,),),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('products')
                    .doc(productId)
                    .delete();
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Product deleted successfully.')));
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No',),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.02, vertical: deviceHeight * 0.01),
      width: double.infinity,
      height: deviceHeight * 0.1,
      child: Card(
        shadowColor: Theme.of(context).primaryColor,
        child: Row(
          children: [
            SizedBox(
              width: deviceWidth * 0.01,
            ),
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(productImage,),
            ),
            SizedBox(
              width: deviceWidth * 0.01,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$productPrice\$',
                ),
              ],
            ),
            Spacer(),
            //edit product button
            IconButton(
              icon: Icon(
                Icons.edit_rounded,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProductScreen(
                  productName: productName,
                  productImageLink: productImage,
                  productKind: productKind,
                  productPrice: productPrice,
                  productId: productId,
                  productDescription: productDescription,
                ),),);
              },
            ),
            //delete product button
            Builder(
              builder: (BuildContext context) => IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => deleteProduct(
                  context,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
