import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:home_plant/screens/home_page.dart';

class ConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: ClipPathClass(),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor,
                  BlendMode.softLight,
                ),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaY: 4,
                    sigmaX: 4,
                  ),
                  child: Image.asset('assets/images/plant.jpg'),
                ),
              ),
            ),
            RaisedButton(
              child: Text(
                'Continue shopping',
                style: TextStyle(
                    color: Theme.of(context).accentTextTheme.headline1.color),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (BuildContext context) => HomePage(),),);
                },
            ),
          ],
        ),
      ),
    );
  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
