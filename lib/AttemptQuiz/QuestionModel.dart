import 'package:flutter/material.dart';
import 'package:quizoid/CreateQuiz/tempData.dart';

class QuestionDesign extends StatefulWidget {
  final int index;
  int _value ;

  QuestionDesign(this.index){
    choosenOption = List(answers.length);
    this._value = choosenOption.isEmpty ? 0 : choosenOption[index];
  }

  @override
  _QuestionDesignState createState() => _QuestionDesignState();
}

class _QuestionDesignState extends State<QuestionDesign> {

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('${questions[widget.index]}'),
      children: [
        RadioListTile(
            key: ValueKey('option1'),
            value: 1,
            groupValue: widget._value,
            onChanged: (val){
              setState(() {
                widget._value = val;
                choosenOption[widget.index] = widget._value;
              }); 
            },
            title: Text('${options[widget.index]['1']}')),
        RadioListTile(
            key: ValueKey('option2'),
            value: 2,
            groupValue: widget._value,
            onChanged: (val){
              setState(() {
                widget._value = val;
                choosenOption[widget.index] = widget._value;
              }); 
            },
            title: Text('${options[widget.index]['2']}')),
        RadioListTile(
            key: ValueKey('option3'),
            value: 3,
            groupValue: widget._value,
            onChanged: (val){
              setState(() {
                widget._value = val;
                choosenOption[widget.index] = widget._value;
              }); 
            },
            title: Text('${options[widget.index]['3']}')),
        RadioListTile(
            key: ValueKey('option4'),
            value: 4,
            groupValue: widget._value,
            onChanged: (val){
              setState(() {
                widget._value = val;
                choosenOption[widget.index] = widget._value;
              }); 
            },
            title: Text('${options[widget.index]['4']}')),
      ],
    );
  }
}
