import 'package:flutter/material.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'package:home_plant/home_screen_tabs/accessories_tab.dart';
import 'package:home_plant/home_screen_tabs/all_tab.dart';
import 'package:home_plant/home_screen_tabs/plants_tab.dart';
import 'package:home_plant/home_screen_tabs/flowers_tab.dart';
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
      text: 'Flowers',
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
              FlowersTab(),
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


