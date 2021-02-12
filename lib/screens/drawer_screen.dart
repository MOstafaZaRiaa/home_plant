import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_plant/getX/theme.dart';
import 'package:home_plant/screens/my_products_screen.dart';
import 'package:home_plant/screens/profile_screen.dart';
import 'package:get/get.dart';

import 'add_product_screen.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('رايح فين يا اعمي'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you Sure.'),
                Text('Would you like to logout of the app?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes',style: TextStyle(color: Theme.of(context).errorColor,),),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    final controller = Get.put(ThemeProvide());
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(0),
                    //elevation: 5,
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * .02,
                            vertical: MediaQuery.of(context).size.width * .02,
                          ),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).accentColor,
                            radius: MediaQuery.of(context).size.width * .12,
                            backgroundImage:FirebaseImage('gs://home-plant.appspot.com/${snapshot.data['imagePath']}',) ,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data['username'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .accentTextTheme
                                    .headline1
                                    .color,
                              ),
                            ),
                            Text(
                              snapshot.data['email'],
                              style: TextStyle(
                                color: Theme.of(context)
                                    .accentTextTheme
                                    .headline1
                                    .color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  //edit profile
                  ListTile(
                    leading: Icon(
                      Icons.person_rounded,
                      color: Theme.of(context).textTheme.headline1.color,
                    ),
                    title: Text(
                      'Profile',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            userName: snapshot.data['username'],
                            userEmail: snapshot.data['email'],
                            imageUrl: snapshot.data['imagePath'],
                            user: user,
                          ),
                        ),
                      );
                    },
                  ),
                  //add product
                  ListTile(
                    leading: Icon(
                      Icons.add,
                      color: Theme.of(context).textTheme.headline1.color,
                    ),
                    title: Text(
                      'Add product',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddProductScreen(),
                        ),
                      );
                    },
                  ),
                  //edit products
                  if(user.email == 'test@test.com')
                  ListTile(
                    leading: Icon(
                      Icons.edit_rounded,
                      color: Theme.of(context).textTheme.headline1.color,
                    ),
                    title: Text(
                      'Edit products',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyProductScreen(),
                        ),
                      );
                    },
                  ),
                  Spacer(),
                  //theme mode
                  SimpleBuilder(builder: (_) => ListTile(
                      title: Text(
                        'Dark mode',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline1.color,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: Switch(
                        value: controller.isDark,
                        onChanged:controller.changeTheme,
                        activeTrackColor: Theme.of(context).accentColor,
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  //logout
                  ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).textTheme.headline1.color,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color),
                    ),
                    onTap: () {
                      _showMyDialog(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
