import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttemptedByUsers extends StatelessWidget {
  final String quizId;

  AttemptedByUsers(this.quizId);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final appBar = AppBar(
      title: Text('Quizoid'),
      centerTitle: true,
    );

    final bodyHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;

    final bodyWidth = mediaQuery.size.width -
        mediaQuery.padding.left -
        mediaQuery.padding.right;

    return Scaffold(
      appBar:appBar,
      body: Container(
        height: bodyHeight,
        width: bodyWidth,
        color: Colors.black,
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('Quiz').doc(quizId).get(),
          builder: (context,snapShots){
            if (snapShots.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if(snapShots.data['AttemptedBy'].isEmpty) {
              return Center(child:Text('No one has engaged with your quiz yet :(',style: TextStyle(color: Colors.white)));
            }
            return ListView.builder(
              itemCount: snapShots.data['AttemptedBy'].length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white.withOpacity(0.5),
                  elevation: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: double.maxFinite,
                    height: 30,
                    child: Text(' ${index+1} - ${snapShots.data['AttemptedBy'][index]}',overflow: TextOverflow.clip)
                  ),
                );
              });
          }
        )
      ),
    );
  }
}