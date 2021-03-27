import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  @override
  final productKind;
  final productImagePath;
  final productName;
  final productPrice;
  final productDescription;
  final productId;
  const EditProductScreen(
      {this.productKind,
      this.productImagePath,
      this.productName,
      this.productId,
      this.productPrice,
      this.productDescription});

  static const userDummyImage =
      'gs://home-plant.appspot.com/dummy450x450.jpg';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  PickedFile newPickedImage;
  var imageFile;
  User user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  bool isUploading = false;
  bool isEditing = false;
  String _productImagePath = '';
  String productKind = 'Plant';
  String productName = '';
  String productDescription = '';
  double productPrice;

  void initState(){
    productKind = widget.productKind;
    super.initState();
  }

  Future<void> setProductImage(BuildContext ctx) async {
    newPickedImage = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 500,
    );
    imageFile = File(newPickedImage.path);
    setState(() {
      isEditing=true;
    });
  }

  Future<void> uploadNewImage() async {
    //upload user image to firestorage server
    if(newPickedImage !=null)
    {
      final ref = FirebaseStorage.instance
          .ref()
          .child('product_image')
          .child(user.uid + '.jpg');
      await ref.putFile(imageFile);
      // get the link of uoloaded image
      final productImagePath = ref.fullPath;
      setState(() {
        _productImagePath = productImagePath;
      });
    }
  }

  void validateProduct(BuildContext ctx) async {
    FocusScope.of(ctx).unfocus();
    setState(() {
      isUploading = true;
    });
    final isValid = _formKey.currentState.validate();
    // if (newPickedImage == null) {
    //   Scaffold.of(ctx).showSnackBar(
    //     SnackBar(
    //       content: Text('You have to chose a photo'),
    //       backgroundColor: Theme.of(context).errorColor,
    //     ),
    //   );
    // }
    if (isValid) {
      _formKey.currentState.save();
      //create search index
      List<String> splitList= productName.split(" ");
      List<String> indexList= [];
      for(int i =0;i<splitList.length;i++){
        for(int y =1;y<splitList[i].length + 1 ;y++){
          indexList.add(splitList[i].substring(0,y).toLowerCase());
        }
      }
      try {
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'Uploading...',
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
        await uploadNewImage();
        // //upload product to firebase firestore
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.productId)
            .update({
          'productName': productName,
          'productId': widget.productId,
          'productPrice': productPrice,
          'productDescription': productDescription,
          'productKind': productKind,
          'imagePath': isEditing?_productImagePath:widget.productImagePath,
          'searchIndex':indexList,
        });
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text('it\'s done.'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      } on FirebaseException catch (error) {
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: [
          Builder(
            builder: (BuildContext context) => IconButton(
              icon: Icon(Icons.check),
              onPressed: () => validateProduct(context),
            ),
          ),
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
                      child: isEditing
                          ? Image(
                              image: FileImage(imageFile),
                            ):Image(image:FirebaseImage('gs://home-plant.appspot.com/${widget.productImagePath}',), ),
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
                  initialValue: widget.productName,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  onSaved: (value) {
                    productName = value;
                  },
                  validator: (value) {
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
                  initialValue: widget.productPrice,
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  onSaved: (value) {
                    productPrice = double.parse(value);
                  },
                  validator: (value) {
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
                  initialValue: widget.productDescription,
                  decoration: InputDecoration(
                    labelText: 'description',
                  ),
                  onSaved: (value) {
                    productDescription = value;
                  },
                  validator: (value) {
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
