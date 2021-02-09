import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:home_plant/home_screen_tabs/tabs_body/grid_view_for_tabs_body.dart';

class FlowersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridViewForTabsBody(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where(
        'productKind',
        isEqualTo: 'Flowers',
      )
          .snapshots(),
    );
  }
}

