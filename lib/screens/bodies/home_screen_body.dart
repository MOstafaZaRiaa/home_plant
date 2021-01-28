import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreenBody extends StatefulWidget {
  @override
  final Widget widget;

  const HomeScreenBody({ this.widget});
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override

  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('data'),
      ],
    );
  }
}
