import 'package:flutter/material.dart';

import 'package:home_plant/screens/cart_screen.dart';

class CartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.shopping_cart_outlined,
            size: 24,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(),
              ),
            );
          },
        ),
        // Positioned(
        //   right: 8,
        //   top: 8,
        //   child: Container(
        //     padding: EdgeInsets.all(2.0),
        //     // color: Theme.of(context).accentColor,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10.0),
        //       color: Theme.of(context).accentColor,
        //     ),
        //     constraints: BoxConstraints(
        //       minWidth: 16,
        //       minHeight: 16,
        //     ),
        //     child: Text(
        //       _itemInCartCount.toString(),
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //         color: Theme.of(context).primaryColor,
        //         fontSize: 10,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}