import 'package:flutter/material.dart';
import '../CreateQuiz/tempData.dart';
import 'package:flutter/rendering.dart';

class Analyse extends StatelessWidget {
  final ScrollController _controllerOne = ScrollController();
  final ScrollController _controllertwo = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz Analysis'),
        ),
        body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          padding: const EdgeInsets.all(5.0),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Container(
                  height: constraints.maxHeight *  0.04,
                  width: constraints.maxWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Icon(Icons.circle,color: Colors.green),
                            Text('Right')
                          ],
                        )
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Icon(Icons.circle,color: Colors.red),
                            Text('Wrong')
                          ],
                        )
                      ),              
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Icon(Icons.circle,color: Colors.cyan),
                            Text('Not attempted')
                          ],
                        )
                      ),
                    ],
                  )
                ),
                Container(
                  height: constraints.maxHeight * 0.56,
                  width: constraints.maxWidth,
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _controllerOne,
                    child: ListView.builder(
                      controller: _controllerOne,
                      itemBuilder: (context, index) {
                        return Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, right: 5.0),
                                child: ListTile(
                                  leading: Text('${index+1}'),
                                  title: Text('${questions[index]}'),
                                  tileColor: choosenOption[index] ==
                                          answers[index]
                                      ? Colors.green.withOpacity(0.3)
                                      : (choosenOption[index] == null
                                          ? Colors.cyan.withOpacity(0.3)
                                          : Colors.red.withOpacity(0.3)),
                                ),
                              );
                      },
                      itemCount: questions.length,
                    ),
                  ),
                ),
                Container(
                  height: constraints.maxHeight * 0.4,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)
                    )
                  ),
                  child: LayoutBuilder(builder: (context, constraints2) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            height: constraints2.maxHeight * 0.15,
                            width: constraints2.maxWidth * 0.3,
                            child: FittedBox(
                              child: const Text('Answers :',style: TextStyle(fontWeight: FontWeight.bold),),
                              fit: BoxFit.contain,
                            )),
                        Container(
                            height: constraints2.maxHeight * 0.75,
                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Scrollbar(
                              controller: _controllertwo,
                              isAlwaysShown: true,
                              child: ListView.builder(
                                controller: _controllertwo,
                                itemBuilder: (context, index) {
                                  return Padding(
                                          padding: EdgeInsets.only(top: 3),
                                          child: Text(
                                            '${index+1} -   ${options[index]['${answers[index]}']}',
                                            style: TextStyle(fontSize: 16),
                                            maxLines: 3,
                                          ),
                                        );
                                },
                                itemCount: answers.length,
                              ),
                            ))
                      ],
                    );
                  }),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}



