import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:min_id/min_id.dart';

class AddProductScreen extends StatefulWidget {
  @override

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  PickedFile newPickedImage;
  var imageFile;
  User user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  bool isUploading = false;
  String _productImagePath = '';
  String productKind = 'Plant';
  String productName = '';
  String productDescription = '';
  double productPrice;
  final productId = MinId.getId();

  Future<void> setProductImage(BuildContext ctx) async {
    newPickedImage = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 500,
    ) ;
    imageFile = File(newPickedImage.path);
    setState(() {

    });
  }

  Future<void> uploadImage()async{
      //upload user image to firestorage server
      final ref = FirebaseStorage.instance
          .ref()
          .child('product_image')
          .child(productId + '.jpg');
      await ref.putFile(imageFile);
      // get the link of uoloaded image
      final productImagePath = await ref.fullPath;
      setState(() {
        _productImagePath = productImagePath;
      });
  }

  void validateProduct(BuildContext ctx)async{
    FocusScope.of(ctx).unfocus();
    setState(() {
      isUploading = true;
    });
    final isValid = _formKey.currentState.validate();
    if(newPickedImage == null){
      Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('You have to chose a photo'),backgroundColor: Theme.of(context).errorColor,),);
    }
    if(isValid && newPickedImage != null ){
      _formKey.currentState.save();
      //create search index
      List<String> splitList= productName.split(" ");
      List<String> indexList= [];
      for(int i =0;i<splitList.length;i++){
        for(int y =1;y<splitList[i].length + 1 ;y++){
          indexList.add(splitList[i].substring(0,y).toLowerCase());
        }
      }

      try{
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Uploading...',),backgroundColor: Theme.of(context).primaryColor,),);
        await uploadImage();
        // //upload product to firebase firestore
        await FirebaseFirestore.instance
            .collection('products').doc(productId)
            .set({
          'productName': productName,
          'productId': productId,
          'productPrice': productPrice,
          'productDescription': productDescription,
          'productKind': productKind,
          'imagePath': _productImagePath,
          'searchIndex':indexList,
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
                      child: imageFile == null
                          ? Image.asset('assets/images/plant_outline_dark.png')
                          : Image(
                              image: FileImage(imageFile),
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
                  maxLines: 20,
                  minLines: 5,
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
                        'Flowers',
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
