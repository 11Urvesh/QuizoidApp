import 'package:flutter/material.dart';
import 'tempData.dart';

class QuestionForm extends StatefulWidget {
  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final _formKey = GlobalKey<FormState>();
  
  String question;
  String option1, option2, option3, option4;
  int answer;

  void trySubmit(BuildContext context){
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      questions.add(question);
      answers.add(answer);
      options.add({'1':option1,'2':option2,'3':option3,'4':option4});
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      child: AlertDialog(
        title: Text('Question'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(
                    hintText: 'Enter Question Text',
                    border: OutlineInputBorder()),
                validator: (value) =>
                    value.isEmpty ? 'Please enter valid Question' : null,
                onSaved: (value) {
                  question = null;
                  question = value.trim();
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Option -1',
                ),
                validator: (value) =>
                    value.isEmpty ? 'Please enter valid Option-1' : null,
                onSaved: (value) {
                  option1 = null;
                  option1 = value.trim();
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Option -2',
                ),
                validator: (value) =>
                    value.isEmpty ? 'Please enter valid Option-2' : null,
                onSaved: (value) {
                  option2 = null;
                  option2 = value.trim();
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Option -3',
                ),
                validator: (value) =>
                    value.isEmpty ? 'Please enter valid Option-3' : null,
                onSaved: (value) {
                  option3 = null;
                  option3 = value.trim();
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Option -4',
                ),
                validator: (value) =>
                    value.isEmpty ? 'Please enter valid Option-4' : null,
                onSaved: (value) {
                  option4 = null;
                  option4 = value.trim();
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Correct Option-1/2/3/4',
                ),
                validator: (value) => value.isEmpty
                    ? 'Please Enter Answer'
                    : (num.parse(value) < 1 || num.parse(value) > 4)
                        ? 'Please Enter valid option Index'
                        : null,
                onSaved: (value) {
                  answer = num.parse(value);
                },
              )
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('cancel')),
          TextButton(
              onPressed: ()=>trySubmit(context),
              child: Text('Add')),
        ],
      ),
    );
  }
}
