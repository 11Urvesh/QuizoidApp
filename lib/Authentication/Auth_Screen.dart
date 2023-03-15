import 'package:flutter/material.dart';
import 'package:quizoid/Authentication/Auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLogin;
  bool _isLoding;

  @override
  void initState() {
    super.initState();
    _isLogin = true;
    _isLoding = false;
  }

  void _submitAuthForm({
    BuildContext ctx,
    @required String email,
    @required String password,
    String userName,
    String phnNo,
  }) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoding = true;
      });

      if (_isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(authResult.user.uid)
            .set({
          'Name': userName,
          'Email': email,
          'Password': password,
          'phnNo': phnNo,
          'Image': null,
          'Standard': null,
          'School': null,
          'About': null,
          'QuizByMe': FieldValue.arrayUnion([])
        });
      }
    } catch (err) {
      var message = 'Please check your internet connection';

      if (err.code == null) {
        message = err.message;
      }

      switch (err.code.toString()) {
        case 'wrong-password':
          message = ' Oops! Invalid Password.';
          break;
        case 'user-not-found':
          message = ' User does not exist, Sign Up to proceed.';
          break;
        case 'network-request-failed':
          message = ' Please check your internet connection. ';
          break;
        case 'email-already-in-use':
          message = ' User already exist with this Email-Id. ';
          break;
        case 'operation-not-allowed':
          message = ' Server error, please try again later.';
          break;
        default:
          message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(message), backgroundColor: Theme.of(ctx).errorColor));
    } finally {
      setState(() {
        _isLoding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool _keyboardIsOpen = mediaQuery.viewInsets.bottom != 0;

    double _screenHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    double _screenWidth = mediaQuery.size.width -
        mediaQuery.padding.left -
        mediaQuery.padding.right;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: _screenHeight,
          width: _screenWidth,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.white,
              Colors.cyan,
              Colors.blue.withOpacity(0.5)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      height: constraints.maxHeight * 0.11,
                      width: constraints.maxWidth * 0.7,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 7,
                            fit: FlexFit.tight,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text('𝕼𝖚𝖎𝖟𝖔𝖎𝖉',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10)),
                            ),
                          ),
                          Flexible(
                              flex: 3,
                              child: Image.asset('assets/Images/appIcon.png'))
                        ],
                      )),
                  Container(
                      height: constraints.maxHeight * 0.45,
                      width: constraints.maxWidth * 0.9,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AuthForm(_isLogin, _submitAuthForm, _isLoding),
                        ),
                      )),
                ]);
          }),
        ),
      )),
      floatingActionButton: Visibility(
        visible: !_keyboardIsOpen,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          elevation: 4,
          label: Text(
            _isLogin
                ? 'Don\'t have an account ? Sign up'
                : 'Have an account ? Login now !',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            setState(() {
              FocusScope.of(context).unfocus();
              _isLogin = !_isLogin;
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
