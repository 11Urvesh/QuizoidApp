import 'package:flutter/rendering.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class ShareQuizCode extends StatelessWidget {
  final String quizCode;
  ShareQuizCode(this.quizCode);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: constraints.maxHeight * 0.15,
            width: constraints.maxWidth * 0.8,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'Your Quiz is Ready ! \nYou can Share this Quizcode',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
              height: constraints.maxHeight * 0.3,
              width: constraints.maxWidth * 0.8,
              child: Card(
                color: Colors.white.withOpacity(0.7),
                elevation: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: constraints.maxHeight * 0.08,
                        width: constraints.maxWidth * 0.7,
                        alignment: Alignment.center,
                        child: InkWell(
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              prefixText: 'Copy:',
                              suffixIcon: Icon(Icons.copy_rounded),
                              hintText: '$quizCode',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          onTap: () {
                            FlutterClipboard.copy(quizCode.trim());
                          },
                        )),
                    ElevatedButton(
                        child: Text('Share'),
                        onPressed: () {
                          Share.share(
                              'check out my website https://example.com',
                              subject: 'Look what I made!');
                        })
                  ],
                ),
              ))
        ],
      );
    });
  }
}
