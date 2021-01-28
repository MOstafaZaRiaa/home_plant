import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:home_plant/screens/cart_screen.dart';
class CartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DescribedFeatureOverlay(
      featureId: 'cart',
      targetColor: Theme.of(context).accentTextTheme.headline1.color,
      textColor: Theme.of(context).accentTextTheme.headline1.color,
      backgroundColor: Theme.of(context).primaryColor,
      contentLocation: ContentLocation.trivial,
      overflowMode: OverflowMode.clipContent,
      enablePulsingAnimation: true,
      barrierDismissible: false,
      pulseDuration: Duration(seconds: 1),
      openDuration: Duration(seconds: 1),
      title: Text(
        'This button is',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      description: Text(
        'Here you can fiend more details',
      ),
      tapTarget: Icon(
        Icons.shopping_cart_outlined,
        size: 24,
      ),
      child: Stack(
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
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2.0),
              // color: Theme.of(context).accentColor,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).accentColor,
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                //TODO:put numbers of products variable
                '0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
