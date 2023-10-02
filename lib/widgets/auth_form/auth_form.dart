import 'dart:io';

import 'package:flutter/material.dart';
import 'package:let_us_chat/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, File? image,
      String password, bool isLogin) submitFn;
  bool loading;
  AuthForm(this.submitFn, this.loading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var email = '';
  var username = '';
  var password = '';
  var isLogin = true;
  File? _pickedImage;

  void _pickImage(File image) {
    _pickedImage = image;
  }

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    final form = _formkey.currentState;
    if (_pickedImage == null && !isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please pick an image'),
        ),
      );
      return;
    }
    if (form!.validate()) {
      form.save();
      widget.submitFn(email.trim(), username.trim(), _pickedImage,
          password.trim(), isLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    if (!isLogin) UserImagePicker(_pickImage),
                    TextFormField(
                      key: ValueKey('emial'),
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(labelText: 'Email address'),
                      validator: (value) => value!.isEmpty ||
                              !value.contains('@')
                          ? 'Please enter a valid email'
                          : value.length < 4
                              ? 'Username must be more than three characters'
                              : null,
                      onSaved: (value) => email = value!,
                    ),
                    if (!isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) => value!.isEmpty || value.length < 4
                            ? 'Username must be more than three characters'
                            : null,
                        decoration: InputDecoration(labelText: 'username'),
                        onSaved: (value) => username = value!,
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      onSaved: (value) => password = value!,
                      validator: (value) => value!.isEmpty || value.length < 7
                          ? 'Password must be up to 7 characters'
                          : null,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    widget.loading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _trySubmit,
                            child: Text(isLogin ? 'Login' : 'Sign Up'),
                          ),
                    if (!widget.loading)
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(isLogin
                              ? 'Create new account'
                              : 'I already have an account'))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
