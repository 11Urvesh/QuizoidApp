import 'package:flutter/material.dart';
import 'package:quizoid/Main-Drawer/mainDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizoid/CreateQuiz/create_Quiz.dart';
import 'package:quizoid/AttemptQuiz/attempteQuiz.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen(this.userId);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .get(),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: appBar,
          drawer: MainDrawer(widget.userId, snapShot.data['Email'],
              snapShot.data['Name'], snapShot.data['phnNo']),
          body: Container(
              height: bodyHeight,
              width: bodyWidth,
              color: Colors.black,
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: constraints.maxWidth * 0.3,
                      width: constraints.maxWidth * 0.9,
                      child: FittedBox(
                        child: Text('Welcome, ${snapShot.data['Name']}',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Container(
                      height: constraints.maxWidth * 0.6,
                      width: constraints.maxWidth * 0.9,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CreateQuizPage(widget.userId)));
                        },
                        splashColor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        child: Card(
                          elevation: 5,
                          color: Theme.of(context).primaryColorLight,
                          child: Center(child: Text('Create Quiz')),
                        ),
                      ),
                    ),
                    Container(
                        height: constraints.maxWidth * 0.6,
                        width: constraints.maxWidth * 0.9,
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => AttemptQuizPage(widget.userId,snapShot.data['Name'])));
                          },
                          child: Card(
                            elevation: 5,
                            color: Theme.of(context).primaryColorLight,
                            child: Center(child: Text('Attempt Quiz')),
                          ),
                        )),
                  ],
                );
              })),
        );
      },
    );
  }
}
