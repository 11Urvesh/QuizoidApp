import 'package:flutter/material.dart';
import 'package:quizoid/Home_Screen.dart';
import 'Authentication/Auth_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizoid',
      theme: ThemeData(
        primaryColor: Colors.lightBlue[900],
        primarySwatch: Colors.lightBlue,
        accentColor: Colors.lightBlue,
        buttonColor: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,userSnapshot){
          if(userSnapshot.connectionState == ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator());
          }
          if(userSnapshot.hasData)
          {
            return HomeScreen(userSnapshot.data.uid.toString().trim());
          }
          return AuthScreen();
        },
      ),
    );
  }
}

