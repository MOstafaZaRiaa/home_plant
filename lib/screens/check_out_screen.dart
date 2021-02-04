import 'package:flutter/material.dart';
class CheckOutScreen extends StatelessWidget {
  @override
  final int;
  const CheckOutScreen({this.int});
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(int.toString()),),
    );
  }
}
