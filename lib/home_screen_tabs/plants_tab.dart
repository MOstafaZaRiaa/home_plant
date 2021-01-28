import 'package:flutter/material.dart';
import 'package:home_plant/widgts/poduct_item.dart';
class PlantsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 7,
        mainAxisSpacing: 0,
      ),
      itemCount : 20 ,
      itemBuilder: (ctx,index) =>ProductItem(),

    );
  }
}

