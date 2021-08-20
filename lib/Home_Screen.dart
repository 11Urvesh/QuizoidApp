import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {

  final String userId;

  HomeScreen(this.userId);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Logout'),
        onPressed: (){
          FirebaseAuth.instance.signOut();
        }
      ),
    );
  }
}