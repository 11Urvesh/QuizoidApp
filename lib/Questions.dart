import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quizoid/tempData.dart';

class QuestionModel extends StatefulWidget {
  @override
  _QuestionModelState createState() => _QuestionModelState();
}

class _QuestionModelState extends State<QuestionModel> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: answers.length,
      itemBuilder: (context, index) {
        return Card(
            child: Container(
          padding: const EdgeInsets.all(5.0),
          child: LayoutBuilder(builder: (context, constraints) {
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.startToEnd,
              background: Container(
                          child: Container(
                            child: Icon(Icons.delete),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(10),
                          ),
                          color: Colors.red),
              onDismissed: (dismissDirection) {
                if (dismissDirection == DismissDirection.endToStart) {
                  return;
                }
                setState(() {
                  questions.removeAt(index);
                  answers.removeAt(index);
                  options.removeAt(index);
                });
              },
              child: ExpansionTile(
                title: Text(questions[index]),
                children: [
                  ListTile(
                    tileColor: answers[index] == 1
                        ? Colors.green.withOpacity(0.3)
                        : Colors.white,
                    title: Text(options[index]['1']),
                    leading: Text('a)'),
                  ),
                  ListTile(
                    tileColor: answers[index] == 2
                        ? Colors.green.withOpacity(0.3)
                        : Colors.white,
                    title: Text(options[index]['2']),
                    leading: Text('b)'),
                  ),
                  ListTile(
                    tileColor: answers[index] == 3
                        ? Colors.green.withOpacity(0.3)
                        : Colors.white,
                    title: Text(options[index]['3']),
                    leading: Text('c)'),
                  ),
                  ListTile(
                    tileColor: answers[index] == 4
                        ? Colors.green.withOpacity(0.3)
                        : Colors.white,
                    title: Text(options[index]['4']),
                    leading: Text('d)'),
                  ),
                ],
              ),
            );
          }),
        ));
      },
    );
  }
}

/*
Card(
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: LayoutBuilder(builder: (context,constraints){
          return ExpansionTile(
            title: Text('Hybridization of first c-atom in Ethene Hybridization of first c-atom in Ethene Hybridization of first c-atom in Ethene ?'),
            children: [
              ListTile(title: Text('Option 1'),leading: Text('a)'),),
              ListTile(title: Text('Option 2'),leading: Text('b)'),),
              ListTile(title: Text('Option 3'),leading: Text('c)'),),
              ListTile(title: Text('Option 4'),leading: Text('d)'),),
            ],
          );
        }),
      ),
*/
