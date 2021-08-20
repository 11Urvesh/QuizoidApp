import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class AuthForm extends StatefulWidget {
  
  final bool _isLogin;
  final bool _isLoding;

  final void Function({
    BuildContext ctx,
    @required String email,
    @required String password,
    String userName,
    String phnNo,
  }) _submitAuthForm;

  AuthForm(this._isLogin,this._submitAuthForm,this._isLoding);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _controllerOne = ScrollController();
  bool _passwordVisible;

  String _userName;
  String _phnNo;
  String _emailId;
  String _password;


  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  void _trySubmit(BuildContext context)
  {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget._submitAuthForm(
        ctx:context,
        email: _emailId,
        password : _password,
        phnNo: _phnNo,
        userName: _userName,
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: ! widget._isLogin,
      controller: _controllerOne,
      child: SingleChildScrollView(
        controller: _controllerOne,
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(!widget._isLogin)
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(6.0),
                  child: TextFormField(
                    key: ValueKey('Name'),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter Full Name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) => value.isEmpty
                        ? 'Please enter your name'
                        : (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                .hasMatch(value))
                            ? 'Invalid name'
                            : null,
                    onSaved: (value) {
                      _userName = value.trim();
                    },
                  ),
                ),
                if(!widget._isLogin)
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(6.0),
                  child: TextFormField(
                    key: ValueKey('Mobile Number'),
                    decoration: InputDecoration(
                      labelText: 'Phone.No',
                      hintText: 'Enter your mobile number',
                      prefixText: '+91',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        (!RegExp(r'(^(?:[+0]9)?[0-9]{10}$)').hasMatch(value) ||
                                value.length == 0)
                            ? 'Invalid phone number'
                            : null,
                    keyboardType: TextInputType.phone,
                    onSaved: (value) {
                      _phnNo = value.trim();
                    },
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(6.0),
                  child: TextFormField(
                    key: ValueKey('Email-Id'),
                    decoration: InputDecoration(
                      labelText: 'Email Id',
                      hintText: 'Enter your email address',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => !EmailValidator.validate(value, true)
                        ? 'Invalid email id'
                        : null,
                    onSaved: (value) {
                      _emailId = value.trim();
                    },
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(6.0),
                  child: TextFormField(
                    key: ValueKey('Password'),
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: (widget._isLogin ? 'Enter your password' : 'Set Password'),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      return value.length < 7
                          ? 'Password must be at least 7 characters long.'
                          : null;
                    },
                    onSaved: (value){
                      _password= value.trim();
                    },
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                if(widget._isLoding)
                CircularProgressIndicator(),
                if(!widget._isLoding)
                Container(
                    alignment: Alignment.center,
                    child: FlatButton(
                      height: MediaQuery.of(context).size.height * 0.05,
                      minWidth: MediaQuery.of(context).size.width * 0.25,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.025),
                      ),
                      child: Text(widget._isLogin ? 'Login ':'Sign Up',
                          style: TextStyle(color: Colors.white)),
                      onPressed: ()=>_trySubmit(context),
                      color: Theme.of(context).primaryColor,
                    )
                )
              ],
            )),
      ),
    );
  }
}