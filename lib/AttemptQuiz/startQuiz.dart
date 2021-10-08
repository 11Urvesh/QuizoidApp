import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StartQuiz extends StatefulWidget {
  final Function throwOnQuizPage;
  String quizCode;
  StartQuiz(this.throwOnQuizPage);

  @override
  _StartQuizState createState() => _StartQuizState();
}

class _StartQuizState extends State<StartQuiz> {
  final _formKey = GlobalKey<FormState>();

  Future<void> checkCode(BuildContext ctx) async {
    final isValid = _formKey.currentState.validate();
    int flag;

    if (isValid) {
       _formKey.currentState.save();

      Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text('Fetching data...please wait !'),
          backgroundColor: Theme.of(ctx).primaryColor));

      try {
        await FirebaseFirestore.instance
            .collection('Quiz')
            .doc(widget.quizCode.trim())
            .get()
            .then((doc) {
          if (doc.exists) {
            flag = 1;
          } else {
            flag = 0;
          }
        });

        if(flag == 0){
          Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Invalid Quiz code'),backgroundColor: Theme.of(ctx).errorColor));
        }
        else if(flag == 1){
          widget.throwOnQuizPage(widget.quizCode);
        }
      } catch (err) {
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('${err.code.toString()}'),backgroundColor: Theme.of(ctx).errorColor));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Best of luck!', style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Quiz Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value.isEmpty ? 'Invalid Quiz Code' : null,
                onSaved: (value) {
                  widget.quizCode = value.trim();
                },
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                  child: Text('Start'), onPressed: () => checkCode(context))
            ],
          ),
        ),
      ),
    );
  }
}
