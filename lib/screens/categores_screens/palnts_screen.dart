import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:home_plant/screens/categores_screens/grid_for_all_screens.dart';

class PlantsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridForAllScreens(
      title: 'Plants',
      stream: FirebaseFirestore.instance
          .collection('products')
          .where(
        'productKind',
        isEqualTo: 'Plant',
      )
          .snapshots(),
    );
  }
}

