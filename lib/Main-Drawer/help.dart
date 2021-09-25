import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final String title;

  MenuScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('$title'),
      ),
      body: Container(
        child: Center(
          child:Text('$title',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold))
        ),
      ),
    );
  }
}