import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizoid/Main-Drawer/AttemptedByUsers.dart';

class MyQuizoid extends StatelessWidget {
  final String title;
  final String userId;
  MyQuizoid(this.title, this.userId);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final appBar = AppBar(
      title: Text('$title'),
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
      appBar: appBar,
      body: Container(
        height: bodyHeight,
        width: bodyWidth,
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('Users').doc(userId).get(),
          builder: (context,snapShot1){
            if (snapShot1.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if(snapShot1.data['QuizByMe'].isEmpty) {
              return Center(child:Text('No Quiz Created Yet'));
            }
            return ListView.builder(
              itemCount: snapShot1.data['QuizByMe'].length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text('Copy:'),
                  trailing: IconButton(
                        icon: Icon(Icons.copy_rounded,color: Theme.of(context).primaryColor),
                        onPressed: (){
                          FlutterClipboard.copy(snapShot1.data['QuizByMe'][index].trim());
                        }
                      ),
                  title: Text('${snapShot1.data['QuizByMe'][index]}',overflow: TextOverflow.clip),
                  onLongPress: (){
                    Navigator.of(context)
                      .push(MaterialPageRoute(fullscreenDialog: true,builder: (context)=>AttemptedByUsers(snapShot1.data['QuizByMe'][index].toString())));
                  },
                );
              });
        })      
      ),
    );
  }
}

/*
quizByMe.isEmpty
          ? Center(child:Text('No Quiz Created Yet'))
          : ListView.builder(
              itemCount: quizByMe.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  leading: IconButton(
                        icon: Icon(Icons.copy_rounded,color: Theme.of(context).primaryColor),
                        onPressed: (){
                          FlutterClipboard.copy(quizByMe[index].trim());
                        }
                      ),
                  title: Text('C-Programming and Data structures'),
                  subtitle: Text('${quizByMe[index]}',overflow: TextOverflow.clip),
                  children: [
                    ListTile(title: Text('Trivedi Urvesh'),subtitle: Text('30/9/21'),trailing: Text('17/20'),)
                  ],
                );
              })

FutureBuilder(
                      future: FirebaseFirestore.instance.collection('Quiz').doc(quizId).get(),
                      builder: (context,snapShot2){
                         if (snapShot2.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                         }
                         if(snapShot2.data['AttemptedBy'].isEmpty){
                           return Center(child:Text('No one has interacted with your Quiz yet'));
                         }
                          return ListView.builder(
                            itemCount: 2,//snapShot2.data['AttemptedBy'].length,
                            itemBuilder: (context,index){
                              String name = snapShot2.data['AttemptedBy'][index].key;
                              var marks = snapShot2.data['AttemptedBy'][index][key];

                              return ListTile(
                                title: Text('$name'),
                                trailing: Text('$marks'),
                              );
                            },
                          );
                      }
                    )
*/
