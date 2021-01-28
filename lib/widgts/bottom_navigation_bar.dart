import 'package:feature_discovery/feature_discovery.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
class BottomNavigation extends StatefulWidget {
  @override
  final void Function(int index) getSelectedScreenFromBottomNavigation;
  const BottomNavigation({this.getSelectedScreenFromBottomNavigation});

  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _bottomNavigatorSelectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return DescribedFeatureOverlay(
      featureId: 'bottomNavigation',
      targetColor: Theme.of(context).accentTextTheme.headline1.color,
      textColor: Theme.of(context).accentTextTheme.headline1.color,
      backgroundColor: Theme.of(context).primaryColor,
      contentLocation: ContentLocation.above,
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
        Icons.home,
        size: 24,
      ),
      child: FFNavigationBar(
        selectedIndex: _bottomNavigatorSelectedIndex,
        onSelectTab: (index) {
          setState(() {
            _bottomNavigatorSelectedIndex = index;
            widget.getSelectedScreenFromBottomNavigation(index);
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.search_sharp,
            label: 'Search',
          ),
          FFNavigationBarItem(
            iconData: Icons.home,
            label: 'Home',
          ),
          FFNavigationBarItem(
            iconData: Icons.favorite_border,
            label: 'Favorite',
          ),
        ],
        theme: FFNavigationBarTheme(
          barBackgroundColor: Theme.of(context).primaryColor,
          selectedItemBorderColor: Theme.of(context).buttonColor,
          selectedItemBackgroundColor: Theme.of(context).primaryColor,
          selectedItemIconColor: Theme.of(context).accentColor,
          selectedItemLabelColor: Theme.of(context).buttonColor,
          unselectedItemIconColor: Theme.of(context).buttonColor,
          unselectedItemLabelColor:
          Theme.of(context).accentTextTheme.headline1.color,
        ),
      ),
    );
  }
}




// DescribedFeatureOverlay buildDescribedFeatureOverlay(BuildContext context) {
// return DescribedFeatureOverlay(
// featureId: 'bottomNavigation',
// targetColor: Theme.of(context).accentTextTheme.headline1.color,
// textColor: Theme.of(context).accentTextTheme.headline1.color,
// backgroundColor: Theme.of(context).primaryColor,
// contentLocation: ContentLocation.above,
// overflowMode: OverflowMode.clipContent,
// enablePulsingAnimation: true,
// barrierDismissible: false,
// pulseDuration: Duration(seconds: 1),
// openDuration: Duration(seconds: 1),
// title: Text(
// 'This button is',
// style: TextStyle(
// fontSize: 20,
// ),
// ),
// description: Text(
// 'Here you can fiend more details',
// ),
// tapTarget: Icon(
// Icons.home,
// size: 24,
// ),
// child: FFNavigationBar(
// selectedIndex: _bottomNavigatorSelectedIndex,
// onSelectTab: (index) {
// setState(() {
// _bottomNavigatorSelectedIndex = index;
// });
// },
// items: [
// FFNavigationBarItem(
// iconData: Icons.search_sharp,
// label: 'Search',
// ),
// FFNavigationBarItem(
// iconData: Icons.home,
// label: 'Home',
// ),
// FFNavigationBarItem(
// iconData: Icons.favorite_border,
// label: 'Favorite',
// ),
// ],
// theme: FFNavigationBarTheme(
// barBackgroundColor: Theme.of(context).primaryColor,
// selectedItemBorderColor: Theme.of(context).buttonColor,
// selectedItemBackgroundColor: Theme.of(context).primaryColor,
// selectedItemIconColor: Theme.of(context).accentColor,
// selectedItemLabelColor: Theme.of(context).buttonColor,
// unselectedItemIconColor: Theme.of(context).buttonColor,
// unselectedItemLabelColor:
// Theme.of(context).accentTextTheme.headline1.color,
// ),
// ),
// );
// }
