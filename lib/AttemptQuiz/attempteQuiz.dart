import 'package:flutter/material.dart';
import 'package:quizoid/AttemptQuiz/QuizPage.dart';
import 'package:quizoid/AttemptQuiz/startQuiz.dart';
import '../CreateQuiz/tempData.dart';

class AttemptQuizPage extends StatefulWidget {
  
  final String userId;
  String _quizCode;
  final String userName;

  AttemptQuizPage(this.userId,this.userName);
  @override
  _AttemptQuizPageState createState() => _AttemptQuizPageState();
}

class _AttemptQuizPageState extends State<AttemptQuizPage> {
  bool _newAttempt;

  void throwOnQuizPage(String quizCode){
    setState(() {
      widget._quizCode = quizCode;
      _newAttempt = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _newAttempt = true;
  }
  
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final appBar = AppBar(
      title: Text('Attempt Quiz'),
      centerTitle: true,
      leading: BackButton(
        onPressed: (){
          questions.clear();
          answers.clear();
          options.clear();
          choosenOption.fillRange(0, choosenOption.length,null);
          Navigator.of(context).pop();
        },
      ),
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
          color: Colors.black,
          padding: const EdgeInsets.all(8.0),
          child: _newAttempt 
          ? Center(child: StartQuiz(throwOnQuizPage))
          : QuizPage(widget.userId,widget._quizCode,widget.userName)
        ));
  }
}
