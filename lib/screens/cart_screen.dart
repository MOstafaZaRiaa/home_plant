import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [],
            ),
          ),
          InkWell(
            child: FlatButton(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.024),
              child: Text(
                'PROCEED',
                style: TextStyle(
                    color: Theme.of(context).accentTextTheme.headline1.color),
              ),
              onPressed: () {},
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
