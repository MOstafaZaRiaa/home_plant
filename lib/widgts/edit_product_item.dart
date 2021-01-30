import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class EditProductItem extends StatelessWidget {
  @override
  final String productImage;
  final String productName;
  final String productPrice;
  final String productId;
  const EditProductItem({this.productImage, this.productName, this.productPrice,this.productId});

  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: deviceWidth*0.02,vertical: deviceHeight*0.01),
      width: double.infinity,
      height: deviceHeight*0.1,
      child: Card(
        shadowColor: Theme.of(context).primaryColor,
        child: Row(
          children: [
            SizedBox(width: deviceWidth*0.01,),
            CircleAvatar(
                radius: 30,
               backgroundImage:NetworkImage(productImage),
              ),
            SizedBox(width: deviceWidth*0.01,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(productName,style: TextStyle(fontWeight: FontWeight.bold),),
              Text('$productPrice\$',),
            ],),
            Spacer(),
            IconButton(icon: Icon(Icons.edit_rounded,color: Theme.of(context).accentColor,), onPressed: (){
              print(productId);
            },),
            IconButton(icon: Icon(Icons.delete_outline,color: Theme.of(context).accentColor,), onPressed: (){},),
          ],
        ),
      ),
    );
  }
}
