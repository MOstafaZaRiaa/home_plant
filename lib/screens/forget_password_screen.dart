import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  var email = '';

  Future<void> resetPassword(BuildContext ctx) async {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState.validate();
    _formKey.currentState.save();
    if (isValid) {
      try {
        await _auth.sendPasswordResetEmail(email: email.trim());

        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Reset email has been sent..!'),
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

  final _controller = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset my password.'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: TextFormField(
                controller: _controller,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Please enter vaild email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'email'),
              ),
            ),
            Builder(
              builder: (BuildContext context)=>
                  FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () => resetPassword(context),
                child: Text(
                  'reset',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
