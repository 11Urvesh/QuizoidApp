import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizoid/QuestionForm.dart';
import 'package:quizoid/Questions.dart';
import 'package:quizoid/ShareQuizCode.dart';
import 'package:quizoid/tempData.dart';
import 'package:intl/intl.dart';


class CreateQuizPage extends StatefulWidget {
  final String userId;
  String quizCode;
  CreateQuizPage(this.userId);

  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  String quizTitle = '';
  bool isDone;

  @override
  void initState() {
    super.initState();
    isDone = false;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final appBar = AppBar(
      title: Text('Crete Quiz'),
      centerTitle: true,
      leading: BackButton(
        onPressed: () {
          questions.clear();
          answers.clear();
          options.clear();
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

    void questionInput(BuildContext context) {
      showDialog(
          context: context,
          barrierDismissible: false,
          useSafeArea: true,
          builder: (_) => QuestionForm()).then((value) {
        setState(() {});
      });
    }

    void createQuiz(BuildContext _context) async {

      SnackBar mySnackbar1 = SnackBar(
          duration: Duration(seconds: 15),
          content: Text('Creating Quiz...Please Wait!',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor:Theme.of(context).primaryColor
        );
        SnackBar mySnackbar2 = SnackBar(
          duration: Duration(seconds: 5),
          content: Text('Some Data is missing',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.yellow
        );

      if (questions.length == options.length && answers.isNotEmpty && quizTitle.isNotEmpty) {
        Scaffold.of(_context).showSnackBar(mySnackbar1);

        try {
          DocumentReference doc = await FirebaseFirestore.instance.collection('Quiz').add({
            'QuizTitle': '$quizTitle',
            'QuestionList': FieldValue.arrayUnion(questions),
            'OptionList': FieldValue.arrayUnion(options),
            'AnswerList': FieldValue.arrayUnion(answers)
         });
         await FirebaseFirestore.instance.collection('Users').doc(widget.userId).update({
           'QuizByMe': FieldValue.arrayUnion([doc.id.toString()])
         }).then((value){
           setState(() {
             widget.quizCode = doc.id.toString();
             isDone = !isDone;
           });
         });
        } catch (err) {
          Scaffold.of(_context).showSnackBar(
            SnackBar(content: Text('$err',style: TextStyle(color:Colors.white)),backgroundColor: Colors.red,)
          );
        }
      }
      else{
        Scaffold.of(_context).showSnackBar(mySnackbar2);
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: isDone 
        ? Container(
          height: bodyHeight,
          width: bodyWidth,
          padding: const EdgeInsets.all(8.0),
          color: Colors.black,
          child: ShareQuizCode(widget.quizCode)
        )
        : SingleChildScrollView(
          child: Container(
            height: bodyHeight,
            width: bodyWidth,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.1,
                      width: constraints.maxWidth,
                      padding: const EdgeInsets.only(bottom: 0.3),
                      child: Card(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Enter Quiz Title',
                              hintStyle: TextStyle(fontSize: 25),
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            if (value == null || value == '') {
                              quizTitle = 'Quiz - ${DateFormat.yMd("en_US").format(DateTime.now())}';
                            }
                            quizTitle = value.trim();
                          },
                        ),
                        elevation: 3,
                      ),
                    ),
                    Container(
                        height: constraints.maxHeight * 0.80,
                        width: constraints.maxWidth,
                        padding: const EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0),bottomLeft: Radius.circular(25.0)),
                          color: questions.isEmpty ? Colors.blueGrey[100] : Colors.black,
                        ),
                        child: questions.isEmpty
                            ? Center(
                                child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: constraints.maxWidth * 0.1,
                                    width: constraints.maxWidth * 0.6,
                                    child: FittedBox(child: Text('No Questions yet'),fit: BoxFit.contain)
                                  ),
                                  SizedBox(
                                    height: constraints.maxWidth * 0.7,
                                    width: constraints.maxWidth * 0.7,
                                    child: Image(fit: BoxFit.contain,image: AssetImage('assets/Images/stack-icon.png'),),
                                  )
                                ],
                              ))
                            : QuestionModel()),
                    Container(
                      height: constraints.maxHeight * 0.1,
                      width: constraints.maxWidth,
                      alignment: Alignment.topLeft,
                      child:
                          RaisedButton(child: Text('Create'), onPressed: () =>createQuiz(context)),
                    )
                  ],
                );
              }),
            ),
          ),
        ),
        floatingActionButton: isDone
        ? null
        : FloatingActionButton(
            child: Icon(Icons.add), onPressed: () => questionInput(context)
          ),
      ),
    );
  }
}
