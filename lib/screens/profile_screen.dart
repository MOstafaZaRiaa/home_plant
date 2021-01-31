import 'dart:io';

import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    this.imageUrl,
    this.userName,
    this.userEmail,
    this.user,
  });
  final String userName;
  final String imageUrl;
  final String userEmail;
  final User user;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  static const userDummyImage = 'dummy450x450.jpg';
  File newPickedImage;
  String newEmail;
  String newUsername;
  String newPassword;
  User user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  Future<void> updateInUserData(
      String userImagePath, String userEmail, String userName) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .update({
      'email': userEmail,
      'username': userName,
      'imagePath': userImagePath,
    });
  }

  Future<void> updateUserImage(BuildContext ctx) async {
    newPickedImage = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 300,
    );
    try {
      //upload user image to firestorage server
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(widget.user.uid + '.jpg');
      await ref.putFile(newPickedImage);

      //get the link of uoloaded image
      final userImageLink = await ref.fullPath;

      //update link of user image in firestore
      await updateInUserData(userImageLink, widget.userEmail, widget.userName);

      //show snackbar that process is completed
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Updated'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } catch (error) {
      //show snackbar that process is not completed
      Scaffold.of(ctx).showSnackBar(SnackBar(content: error));
    }
  }

  Future<void> deleteUserImage(BuildContext ctx) async {
    updateInUserData(userDummyImage, widget.userEmail, widget.userName);
    setState(() {
      newPickedImage = null;
    });
    Scaffold.of(ctx).showSnackBar(
      SnackBar(
        content: Text('deleted'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Future<void> submitChanges(BuildContext ctx) async {
    FocusScope.of(ctx).unfocus();
    Scaffold.of(ctx).showSnackBar(
      SnackBar(
        content: Text('Updating...'),
        backgroundColor: Theme.of(ctx).primaryColor,
      ),
    );
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      try {
        _formKey.currentState.save();
        //update the email
        await FirebaseAuth.instance.currentUser.updateEmail(newEmail);
        //save changes into firestore
        updateInUserData(widget.imageUrl, newEmail, newUsername);
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Updated'),
            backgroundColor: Theme.of(ctx).primaryColor,
          ),
        );
      } on FirebaseException catch (error) {
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your profile'),
        actions: [
          Builder(
            builder: (BuildContext context) => IconButton(
              icon: Icon(
                Icons.check,
                color: Theme.of(context).buttonColor,
              ),
              onPressed: () => submitChanges(context),
            ),
          ),
        ],
      ),
       body: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 300,
                                width: double.infinity,
                                child: Hero(
                                  tag: 'userImage',
                                  child: Container(
                                    height: 180,
                                    width: double.infinity,
                                    child:newPickedImage==null?
                                    Image(image:FirebaseImage(
                                      'gs://home-plant.appspot.com/${widget.imageUrl}',
                                    ),fit: BoxFit.cover,):Image(image:FileImage(newPickedImage),fit: BoxFit.cover,)
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 15,
                                child: Column(
                                  children: [
                                    Builder(
                                      builder: (BuildContext context) =>
                                          IconButton(
                                        icon: Icon(
                                          Icons.camera_alt,
                                          size: 40,
                                          color: Colors.black,
                                        ),
                                        onPressed: () =>
                                            updateUserImage(context),
                                      ),
                                    ),
                                    Builder(
                                      builder: (context) => IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          size: 40,
                                          color: Theme.of(context).errorColor,
                                        ),
                                        onPressed: () =>
                                            deleteUserImage(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: TextFormField(
                              maxLength: 22,
                              textInputAction: TextInputAction.next,
                              initialValue: widget.userName,
                              decoration: InputDecoration(
                                labelText: 'username',
                              ),
                              onSaved: (value) {
                                newUsername = value;
                              },
                              validator: (value) {
                                if (value.isEmpty || value.length < 4) {
                                  return 'Username should be more than 4 characters';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'email',
                              ),
                              onSaved: (value) {
                                newEmail = value;
                              },
                              validator: (value) {
                                if (value.isEmpty || !value.contains('@')) {
                                  return 'Please enter vaild email';
                                }
                                return null;
                              },
                              initialValue: widget.userEmail,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            title: Text(
                              'Change my password',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => ChangePasswordScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
    );
  }
}
