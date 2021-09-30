import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizoid/Main-Drawer/aboutUs.dart';
import 'package:quizoid/help.dart';
import 'myQuizoid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'userProfile.dart';

class MainDrawer extends StatefulWidget { 
  final String userId;
  final String userEmail;
  final String userName;
  final String userphnNo;
  final List quizByMe;
  MainDrawer(this.userId,this.userEmail,this.userName,this.userphnNo,this.quizByMe);
 
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

  void openMenu(BuildContext context, String title) {

    if(title == 'Logout')
    {
      showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (_)=>AlertDialog(
          title: Text('SignOut'),
          content: Text('Are you sure want to SignOut ?'),
          elevation: 20,
          semanticLabel: 'SignOut',
          actions: [
            FlatButton(
              child: Text('No'),
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
              }
            )
          ],
        )
      );
    }
    else if(title=='Profile'){
      Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProfileScreen(title,widget.userId,widget.userEmail,widget.userName,widget.userphnNo))).then((value){setState(() {});});
    }
    else if(title=='About Us'){
      Navigator.of(context)
        .push(MaterialPageRoute(builder: (context)=>WebViewContainer('https://sith.co.in/','About Us')));//MenuScreen(title)));
    }
    else if(title == 'My Quizoid'){
      Navigator.of(context)
        .push(MaterialPageRoute(builder: (context)=>MyQuizoid(title,widget.quizByMe)));
    }
    else{
      Navigator.of(context)
        .push(MaterialPageRoute(builder: (context)=>Help(title)));
    } 
  }


  Widget buildListTile(BoxConstraints constraints,String title,IconData icon) {
    return Container(
        height: constraints.maxHeight * 0.08,
        width: constraints.maxWidth,
        child: LayoutBuilder(builder: (context, constraints) {
          return ListTile(
            leading: Container(
                width: constraints.maxWidth * 0.2,
                child: Icon(
                  icon,
                  size: 30,
                )
              ),
            title: Container(
                width: constraints.maxWidth * 0.6,
                child: Text(
                  title,
                  style: TextStyle(fontSize: 25),
                )),
            onTap: () => openMenu(context, title),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom,
        child: Drawer(
          child: LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.25,
                  width: constraints.maxWidth,
                  child: UserAccountsDrawerHeader(
                    onDetailsPressed:()=>openMenu(context,'Profile'),  
                    accountName: Text('${widget.userName}'),
                    accountEmail: Text(widget.userEmail),
                    currentAccountPicture: FutureBuilder(
                      future: FirebaseFirestore.instance.collection('Users').doc(widget.userId).get(),
                      builder: (context,snapShot){
                        if (snapShot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return CircleAvatar(maxRadius: constraints.maxHeight * 0.075,backgroundImage:snapShot.data['Image'] != null ?NetworkImage(snapShot.data['Image']): AssetImage('assets/Images/userNull_image.jpg'));
                      },
                    )
                  ),
                ),
                buildListTile(constraints,'Profile',Icons.settings),
                buildListTile(constraints,'My Quizoid',Icons.list_alt),
                buildListTile(constraints,'About Us',Icons.info),
                buildListTile(constraints,'Help',Icons.help),
                buildListTile(constraints,'Logout',Icons.logout),
              ],
            );
          }),
        ),
      ),
    );
  }
}