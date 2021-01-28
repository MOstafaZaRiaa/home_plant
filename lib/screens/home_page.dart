import 'package:flutter/material.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'package:home_plant/home_screen_tabs/accessories_tab.dart';
import 'package:home_plant/home_screen_tabs/all_tab.dart';
import 'package:home_plant/home_screen_tabs/plants_tab.dart';
import 'package:home_plant/home_screen_tabs/post_tab.dart';
import 'package:home_plant/widgts/bottom_navigation_bar.dart';
import 'package:home_plant/widgts/cart_widget.dart';
import 'bodies/search_screen_body.dart';
import 'drawer_screen.dart';
import 'bodies/home_screen_body.dart';
import 'bodies/favorite_screen_body.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  int _bottomNavigatorSelectedIndex = 1;
  Widget tapBarChild = AllTab();

  void getSelectedScreenFromBottomNavigation(int index) {
    setState(() {
      _bottomNavigatorSelectedIndex = index;
      print(index);
    });
  }

  //bottom navigation bar screens
  static List<Widget> _bottomNavigationBarScreens = <Widget>[
    SearchScreenBody(),
    HomeScreenBody(),
    FavoriteScreenBody(),
  ];

  //tap bar names and count
  TabController _tabController;
  final List<Tab> myTabs = <Tab>[
    Tab(
      text: 'All',
    ),
    Tab(
      text: 'Plants',
    ),
    Tab(
      text: 'Post',
    ),
    Tab(
      text: 'Accessories',
    ),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context, <String>[
        'bottomNavigation',
        'cart',
      ]);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: PreferredSize(
        preferredSize: _bottomNavigatorSelectedIndex == 1
            ? Size.fromHeight(
                MediaQuery.of(context).size.height * 0.135,
              )
            : Size.fromHeight(
                MediaQuery.of(context).size.height * 0.08,
              ),
        child: AppBar(
          centerTitle: true,
          elevation: _bottomNavigatorSelectedIndex == 0 ? 0 : 4,
          title: Text(
            'Home Plant',
            style: TextStyle(fontFamily: 'Lucida'),
          ),
          bottom: _bottomNavigatorSelectedIndex == 1
              ? TabBar(
                  tabs: myTabs,
                  isScrollable: true,
                  controller: _tabController,
                )
              : null,
          actions: [
            CartWidget(),
          ],
        ),
      ),
      body: _bottomNavigatorSelectedIndex == 1
          ? TabBarView(controller: _tabController, children: [
              AllTab(),
              PlantsTab(),
              PostTab(),
              AccessoriesTab(),
            ]) //tapBarChild
          : Center(
              child: _bottomNavigationBarScreens
                  .elementAt(_bottomNavigatorSelectedIndex)),
      bottomNavigationBar: BottomNavigation(
        getSelectedScreenFromBottomNavigation:
            getSelectedScreenFromBottomNavigation,
      ),
    );
  }
}

// class CartWidget extends StatelessWidget {
//   const CartWidget({
//     Key key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return DescribedFeatureOverlay(
//       featureId: 'cart',
//       targetColor: Theme.of(context).accentTextTheme.headline1.color,
//       textColor: Theme.of(context).accentTextTheme.headline1.color,
//       backgroundColor: Theme.of(context).primaryColor,
//       contentLocation: ContentLocation.trivial,
//       overflowMode: OverflowMode.clipContent,
//       enablePulsingAnimation: true,
//       barrierDismissible: false,
//       pulseDuration: Duration(seconds: 1),
//       openDuration: Duration(seconds: 1),
//       title: Text(
//         'This button is',
//         style: TextStyle(
//           fontSize: 20,
//         ),
//       ),
//       description: Text(
//         'Here you can fiend more details',
//       ),
//       tapTarget: Icon(
//         Icons.shopping_cart_outlined,
//         size: 24,
//       ),
//       child: Stack(
//         children: [
//           IconButton(
//             icon: Icon(
//               Icons.shopping_cart_outlined,
//               size: 24,
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CartScreen(),
//                 ),
//               );
//             },
//           ),
//           Positioned(
//             right: 8,
//             top: 8,
//             child: Container(
//               padding: EdgeInsets.all(2.0),
//               // color: Theme.of(context).accentColor,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.0),
//                 color: Theme.of(context).accentColor,
//               ),
//               constraints: BoxConstraints(
//                 minWidth: 16,
//                 minHeight: 16,
//               ),
//               child: Text(
//                 //TODO:put numbers of products variable
//                 '0',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Theme.of(context).primaryColor,
//                   fontSize: 10,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

