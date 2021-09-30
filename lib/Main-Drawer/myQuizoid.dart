import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class MyQuizoid extends StatelessWidget {
  final String title;
  final List quizByMe;
  MyQuizoid(this.title, this.quizByMe);

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
          child: quizByMe.isEmpty
          ? Center(child:Text('No Quiz Created Yet'))
          : ListView.builder(
              itemCount: quizByMe.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){
                    FlutterClipboard.copy(quizByMe[index].trim());
                  },
                  title: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      prefixText: 'Copy:',
                      suffixIcon: Icon(Icons.copy_rounded),
                      hintText: '${quizByMe[index]}',
                      border: OutlineInputBorder(),
                    ),
                  ),
                );
              })),
    );
  }
}
