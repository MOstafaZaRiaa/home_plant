import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_plant/screens/forget_password_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  var _userName = '';
  var _userEmail = '';
  var _userPassword = '';
  var _userConfirmPassword = '';
  bool _isLogin = true;
  bool _isLoading = false;
  static const userDummyImage =
      'dummy450x450.jpg';
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  Future<void> trySubmit(BuildContext ctx) async{
    setState(() {
      _isLoading=true;
    });
    FocusScope.of(ctx).unfocus();
    final isValid = _formKey.currentState.validate();
    _formKey.currentState.save();
    if(isValid)
    if (!(_userConfirmPassword.trim() == _userPassword.trim()) && _isLogin == false) {
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Password is not match'),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    }else {

      UserCredential userCredential;
      try {
        if (_isLogin) {
          //login method
          userCredential = await _auth.signInWithEmailAndPassword(
            email: _userEmail.trim(),
            password: _userPassword.trim(),
          );
          setState(() {
            _isLoading=false;
          });
        } else {
          //create a new user
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: _userEmail.trim(),
            password: _userPassword.trim(),
          );
          Scaffold.of(ctx).showSnackBar(
            SnackBar(
              content: Text('Sig up now....'),
              backgroundColor: Theme.of(ctx).primaryColor,
            ),);
          //upload user email,userName into firebase
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user.uid)
              .set({
            'email': _userEmail,
            'username': _userName,
            'imagePath': userDummyImage,
          });

          setState(() {
            _isLoading=false;
          });
        }
      } on FirebaseException catch (err) {
        var errorMessage = 'An error occurred , Please check credential';
        if (err.message != null) {
          errorMessage = err.message;
        }
        //show a snackBar is there is any error with log/sign(in)
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
      } catch (error) {

      }
    }
  }

  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/plant.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image(
                    width: deviceWidth*0.25,
                    height: deviceHeight*0.25,
                    image: AssetImage('assets/images/plant_outline.png'),
                  ),
                  Center(
                      child: Text(
                    'Home Plant',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Lucida',
                      color: Theme.of(context).accentTextTheme.headline1.color,
                    ),
                  )),
                  SizedBox(
                    height: deviceHeight * 0.05,
                  ),

                  //email field
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).backgroundColor,
                    child: TextFormField(
                      key: ValueKey('email'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter vaild email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        prefix: SizedBox(
                          width: 10,
                        ),
                        hintText: "email",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: deviceWidth * 0.03),

                  //username field
                  if(!_isLogin)
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).backgroundColor,
                    child: TextFormField(
                      key: ValueKey('username'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Username should be more than 4 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        prefix: SizedBox(
                          width: 10,
                        ),
                        hintText: "username",
                      ),
                    ),
                  ),

                  if(!_isLogin)
                  SizedBox(height: deviceWidth * 0.03),

                  //password field
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).backgroundColor,
                    child: TextFormField(
                      key: ValueKey('password'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty || value.length < 8) {
                          return 'Password is less 8 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        prefix: SizedBox(
                          width: 10,
                        ),
                        hintText: 'Password',
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: deviceWidth * 0.03),

                  //confirm password field
                  if(!_isLogin)
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).backgroundColor,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty || value.length < 8) {
                          return 'Password is less 8 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userConfirmPassword = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        prefix: SizedBox(
                          width: 10,
                        ),
                        hintText: 'Confirm password',
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: deviceWidth * 0.15),

                  //login or signup field
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                    height: deviceHeight * 0.06,
                    child: Builder(
                      builder: (BuildContext context)=> RaisedButton(
                        textColor:
                            Theme.of(context).accentTextTheme.headline1.color,
                        color: Theme.of(context).primaryColor,
                        child: _isLoading? Center(child: CircularProgressIndicator(),) : Text(_isLogin?'Sign in':'Signup',),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onPressed: ()=>trySubmit(context),
                      ),
                    ),
                  ),

                  //switch login and sign up buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin?'Don\'t have an account?':
                        'Already have an account?',
                        style: TextStyle(
                          color:
                              Theme.of(context).accentTextTheme.headline1.color,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin?'Create':
                          'Sign in',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //forget password button
                  if(_isLogin)
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPasswordScreen(),),);
                    },
                    child: Text(
                      'forget password',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
