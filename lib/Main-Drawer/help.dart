import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  final String title;
  Help(this.title);

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