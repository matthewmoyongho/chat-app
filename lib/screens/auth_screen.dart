import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';

import '../widgets/auth_form/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _loading = false;
  void showAlertDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('An error occurred!'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok'))
              ],
            ));
  }

  void _trySubmit(String email, String username, File? image, String password,
      bool isLogin) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final storage.FirebaseStorage store = storage.FirebaseStorage.instance;
    if (!isLogin) {
      try {
        setState(() {
          _loading = true;
        });

        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(email: email, password: password);
        final ref = store
            .ref()
            .child('user_image')
            .child(userCredential.user!.uid + '.jpg');
        await ref.putFile(image!).whenComplete(() => null);
        final image_url = await ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
          {
            'userName': username,
            'email': email,
            'image_url': image_url,
          },
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _loading = false;
        });
        String message =
            'An error occurred! please check your credentials and try again';
        if (e.code == 'weak-password') {
          message = 'Password provided is too weak';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        }
        showAlertDialog(context, message);
      } catch (e) {
        setState(() {
          _loading = false;
        });
        showAlertDialog(context, e.toString());
      }
    } else {
      try {
        setState(() {
          _loading = true;
        });
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (e) {
        setState(() {
          _loading = false;
        });
        String message =
            'An error occured! please check your credentials and try agian';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        }
        showAlertDialog(context, message);
      } catch (e) {
        setState(() {
          _loading = false;
        });
        showAlertDialog(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AuthForm(_trySubmit, _loading),
      ),
    );
  }
}
