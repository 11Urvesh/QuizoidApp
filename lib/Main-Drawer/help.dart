import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  final String title;
  Help(this.title);

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = false;
  }

  void deleteUser()async{
    try {
      String userId = FirebaseAuth.instance.currentUser.uid;
      await FirebaseFirestore.instance.collection('Users').doc(userId).delete();
      await FirebaseAuth.instance.currentUser.delete();

    } catch (err) {
      if(err.code == 'requires-recent-login'){
        FirebaseAuth.instance.signOut();
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title: Text('${widget.title}'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ExpansionTile(
              title: Text('How to know who all have engaged with my Quiz ?',style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Goto MyQuizoid Long press on Quiz Code to get list of People Engaged with your Quiz.'),
                )
              ],
            ),
            ExpansionTile(
              title: Text('What is Quiz code and How I can get quiz code of my existing Quiz?',style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Quiz code is unique for every quiz and Quiz code for all quiz by you will be listed in MyQuizoid.'),
                )
              ],
            ),
            ExpansionTile(
              title: Text('How to create new Quiz ?',style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Goto Home page then click on create quiz add Title and Question Data. Once you done adding required data for quiz click on create button on bottomLeft corner, you are done.'),
                )
              ],
            ),
            ExpansionTile(
              title: Text('Can I edit my Data ?',style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Yes, You can edit some of your data (like Photograph, Standard, School/College details etc). But you can\'t change your User name , Phone Number and Email Id Linked with your account.'),
                )
              ],
            ),
            ExpansionTile(
              title: Text('Can I Create two accounts with same Email Id ?',style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('No, You can\'t create two account on Quizoid App with same email Id '),
                )
              ],
            ),
            ExpansionTile(
              title: Text('How do I delete my account Permenantly?',style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                TextButton(
                  child: Text('Delete my account'),
                  onPressed: ()=>deleteUser(), 
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Note that when you will click above button for the first time you will be signed out automatically, You need to login again within few minutes and again click on the same button to delete your account permenantly.',overflow: TextOverflow.visible,),
                )
              ],
            ),
            SwitchListTile(
              activeColor: Theme.of(context).primaryColor,
              title: Text('Dark Mode',style: TextStyle(fontWeight: FontWeight.bold)),
              value: _isDarkMode, 
              onChanged: (value){
                setState(() {
                  _isDarkMode = value;
                });
              }
            )
          ],
        )
      ),
    );
  }
}