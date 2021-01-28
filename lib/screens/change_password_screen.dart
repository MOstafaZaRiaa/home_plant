import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordScreen extends StatelessWidget {
  var _newPassword;
  User user = FirebaseAuth.instance.currentUser;
  final _keyForm = GlobalKey<FormState>();
  final _controller = TextEditingController();

  Future<void> updatePassword(BuildContext ctx) async {
    FocusScope.of(ctx).unfocus();
    final isValid = _keyForm.currentState.validate();
    _keyForm.currentState.save();
    if(isValid && (_newPassword ==_controller.text)){
      try{
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Waiting.....'),backgroundColor: Theme.of(ctx).accentColor,),);
        await user.updatePassword(_newPassword);
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Password updated'),backgroundColor: Theme.of(ctx).primaryColor,),);
      }on FirebaseException catch (error){
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(error.message),backgroundColor: Theme.of(ctx).errorColor,),);
      }
    }
    }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change your password'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.check,
                color: Theme.of(context).buttonColor,
              ),
              onPressed: () => updatePassword(context),
            ),
          ),
        ],
      ),
      body: Form(
        key: _keyForm,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New password',
                ),
                keyboardType: TextInputType.visiblePassword,
                onSaved: (value) {
                  _newPassword = value;
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 8) {
                    return 'Password can not been less than 8 characters';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: TextFormField(
                obscureText: true,
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Confirm new password',
                ),
                keyboardType: TextInputType.visiblePassword,
                onSaved: (value) {},
                validator: (value) {
                  if (value.isEmpty || value.length < 8) {
                    return 'Password can not been less than 8 characters';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
