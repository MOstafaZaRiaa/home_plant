import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  @override
  static const userDummyImage =
      'https://firebasestorage.googleapis.com/v0/b/chat-4427c.appspot.com/o/dummy450x450.jpg?alt=media&token=5d35f236-0420-4d47-a94d-b10ed0f50c63';

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File newPickedImage;
  User user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  bool isUploading = false;
  String _productImageLink = '';
  String productKind = 'Plant';
  String productName = '';
  String productDescription = '';
  double productPrice;

  Future<void> setProductImage(BuildContext ctx) async {
    newPickedImage = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 500,
    );
    setState(() {

    });
  }
  Future<void> uploadImage()async{
      //upload user image to firestorage server
      final ref = FirebaseStorage.instance
          .ref()
          .child('product_image')
          .child(user.uid + '.jpg');
      await ref.putFile(newPickedImage);
      // get the link of uoloaded image
      final productImageLink = await ref.getDownloadURL();
      setState(() {
        _productImageLink = productImageLink;
      });

      // //upload product to firebase firestore
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(user.uid)
      //     .set({
      //   'email': _userEmail,
      //   'username': _userName,
      //   'image_url': userDummyImage,
      // });

      //show snackbar that process is completed
    //   Scaffold.of(ctx).showSnackBar(
    //     SnackBar(
    //       content: Text('Image uploaded'),
    //       backgroundColor: Theme.of(ctx).primaryColor,
    //     ),
    //   );
    // } catch (error) {
    //   //show snackbar that process is not completed
    //   Scaffold.of(ctx).showSnackBar(SnackBar(content: error.meassage));
    // }
  }

  void validateProduct(BuildContext ctx)async{
    FocusScope.of(ctx).unfocus();
    setState(() {
      isUploading = true;
    });
    final isValid = _formKey.currentState.validate();
    if(isValid || newPickedImage != null ){
      _formKey.currentState.save();
      try{
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Uploading...',),backgroundColor: Theme.of(context).primaryColor,),);
        await uploadImage();
        // //upload product to firebase firestore
        await FirebaseFirestore.instance
            .collection('products')
            .add({
          'productName': productName,
          'productPrice': productPrice,
          'productDescription': productDescription,
          'productKind': productKind,
          'image_url': _productImageLink,
        });
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('it\'s done.'),backgroundColor: Theme.of(context).primaryColor,),);
      }on FirebaseException catch (error){
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(error.message),backgroundColor: Theme.of(context).errorColor,),);
      }
    }
  }

  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add product'),
        actions: [
          Builder(builder: (BuildContext context)=> IconButton(icon: Icon(Icons.check), onPressed: ()=>validateProduct(context),),),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: deviceHeight * 0.01),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: deviceHeight * 0.3,
                      width: double.infinity,
                      child: newPickedImage == null
                          ? Image.asset('assets/images/plant_outline_dark.png')
                          : Image(
                              image: FileImage(newPickedImage),
                            ),
                    ),
                    Positioned(
                      top: 10,
                      right: 15,
                      child: Column(
                        children: [
                          Builder(
                            builder: (BuildContext context) => IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: 32,
                                color: Colors.black,
                              ),
                              onPressed: () => setProductImage(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //product name
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  onSaved: (value){
                    productName = value;
                  },
                  validator: (value){
                    if (value.isEmpty || value.length < 4) {
                      return 'Product name should be more than 4 characters';
                    }
                    return null;
                  },
                ),
                //product price
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  onSaved: (value){
                    productPrice = double.parse(value);
                  },
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please provide a value.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please provide a correct number.';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please provide a correct number2.';
                    }
                    return null;
                  },
                ),
                //product description
                TextFormField(
                  textInputAction: TextInputAction.next,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'description',
                  ),
                  onSaved: (value){
                    productDescription = value;
                  },
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please provide a value.';
                    }
                    if (value.length < 10) {
                      return 'Should be at least 10 characters lang';
                    }
                    return null;
                  },
                ),
                //chose kind of product
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Chose product kind'),
                    DropdownButton<String>(
                      value: productKind,
                      icon: Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color),
                      onChanged: (String newValue) {
                        setState(() {
                          productKind = newValue;
                        });
                      },
                      items: <String>[
                        'Plant',
                        'Flower',
                        'Pot',
                        'Accessories',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
