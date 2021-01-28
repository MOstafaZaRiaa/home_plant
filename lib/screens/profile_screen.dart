import 'dart:io';

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
  static const userDummyImage =
      'https://firebasestorage.googleapis.com/v0/b/chat-4427c.appspot.com/o/dummy450x450.jpg?alt=media&token=5d35f236-0420-4d47-a94d-b10ed0f50c63';
  File newPickedImage;
  String newEmail;
  String newUsername;
  String newPassword;
  User user = FirebaseAuth.instance.currentUser;
  bool isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> updateInUserData(
      String userImageLink, String userEmail, String userName) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .update({
      'email': userEmail,
      'username': userName,
      'image_url': userImageLink,
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
      final userImageLink = await ref.getDownloadURL();

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

    Scaffold.of(ctx).showSnackBar(
      SnackBar(
        content: Text('deleted'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Future<void> submitChanges(BuildContext ctx) async {
    FocusScope.of(ctx).unfocus();
    setState(() {
      isSubmitting = true;
    });
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
    setState(() {
      isSubmitting = false;
    });
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            bool isWaiting =
                snapshot.connectionState == ConnectionState.waiting;
            return (isSubmitting || isWaiting)
                ? Center(
              child: CircularProgressIndicator(),
            )
                : SingleChildScrollView(
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
                              child: isWaiting
                                  ? Center(
                                child: CircularProgressIndicator(),
                              )
                                  : FadeInImage.assetNetwork(
                                placeholder:
                                'assets/images/pic.png',
                                image: snapshot.data['image_url'],
                                width: double.infinity,
                                height: 180,
                                // placeholderCacheHeight: 180,
                                // placeholderCacheWidth: double.infinity.toInt(),
                                fit: BoxFit.cover,
                              ),
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
                        initialValue: snapshot.data['username'],
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
                        initialValue: snapshot.data['email'],
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
                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ChangePasswordScreen(),),);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
