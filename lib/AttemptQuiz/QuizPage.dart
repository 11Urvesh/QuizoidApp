import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizoid/AttemptQuiz/QuizAnalysis.dart';
import '../CreateQuiz/tempData.dart';
import 'package:quizoid/AttemptQuiz/QuestionModel.dart';

class QuizPage extends StatefulWidget {
  final String userId;
  final String quizCode;
  final String userName;

  int flag;
  int positiveCount;
  int negativeCount;

  QuizPage(this.userId, this.quizCode, this.userName) {
    this.flag = 0;
    this.positiveCount = 0;
    this.negativeCount = 0;
  }

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  void submit() async {
    for (int i = 0; i < answers.length; i++) {
      if (choosenOption[i] != null) {
        if (choosenOption[i] == answers[i]) {
          widget.positiveCount++;
        } else {
          widget.negativeCount++;
        }
      }
    }

    await FirebaseFirestore.instance
        .collection('Quiz')
        .doc('${widget.quizCode}')
        .update({
      'AttemptedBy': FieldValue.arrayUnion([
        {
          '${widget.userName}':
              (widget.positiveCount / choosenOption.length) * 100
        }
      ])
    });

    setState(() {
      widget.flag = 1;
    });
  }

  Future<void> loadData(AsyncSnapshot<dynamic> snapshot) async {
    List questions1 = await snapshot.data['QuestionList'];
    List options1 = await snapshot.data['OptionList'];
    List answers1 = await snapshot.data['AnswerList'];

    for (int i = 0; i < questions1.length; i++) {
      questions.add(questions1[i]);
      options.add(options1[i]);
      answers.add(answers1[i]);
    }

    return Future.delayed(Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Quiz')
            .doc(widget.quizCode)
            .get(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (questions.isEmpty && answers.isEmpty && options.isEmpty) {
            loadData(snapShot);
          }
          return Card(
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: constraints.maxHeight * 0.05,
                    width: constraints.maxWidth,
                    color: Colors.cyan,
                    padding: const EdgeInsets.all(3.0),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        '${snapShot.data['QuizTitle']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                      height: constraints.maxHeight * 0.8,
                      width: constraints.maxWidth,
                      color: Colors.cyan.withOpacity(0.3),
                      child: widget.flag <= 1
                          ? widget.flag == 0
                              ? Center(
                                  child: ElevatedButton(
                                      child: Text('Start Quiz'),
                                      onPressed: () {
                                        setState(() {
                                          widget.flag = 2;
                                        });
                                      }))
                              : Center(
                                  child: SizedBox(
                                      height: constraints.maxHeight * 0.4,
                                      width: constraints.maxWidth * 0.8,
                                      child: Card(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('Score Board',
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                          Text('Right: ${widget.positiveCount}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.green)),
                                          Text(
                                              'Wrong: ${widget.negativeCount} ',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red)),
                                          Text(
                                              'Not Attempted: ${choosenOption.length - (widget.positiveCount + widget.negativeCount)}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.cyan)),
                                          TextButton(
                                              child: Text('Analyse',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Analyse(),
                                                        fullscreenDialog:
                                                            true));
                                              })
                                        ],
                                      ))))
                          : ListView.builder(
                              itemCount: questions.length,
                              itemBuilder: (context, index) {
                                return QuestionDesign(index);
                              })),
                  Container(
                    height: constraints.maxHeight * 0.05,
                    width: constraints.maxWidth,
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text('Submit'),
                      onPressed: () => submit(),
                    ),
                  )
                ],
              );
            }),
          );
        });
  }
}

/*
ListView.builder(
                      itemCount: snapShot.data['QuestionList'].length,
                      itemBuilder: (context, index) {
                        // This part will go in Questionn model file 
                        return ExpansionTile(
                          title:
                              Text('${snapShot.data['QuestionList'][index]}'),
                          children: [
                            RadioListTile(
                                value: null,
                                groupValue: null,
                                onChanged: null,
                                title: Text('Option1')),
                            RadioListTile(
                                value: null,
                                groupValue: null,
                                onChanged: null,
                                title: Text('Option1')),
                            RadioListTile(
                                value: null,
                                groupValue: null,
                                onChanged: null,
                                title: Text('Option1')),
                            RadioListTile(
                                value: null,
                                groupValue: null,
                                onChanged: null,
                                title: Text('Option1')),
                          ],
                        );
                      },
                    ),
*/
