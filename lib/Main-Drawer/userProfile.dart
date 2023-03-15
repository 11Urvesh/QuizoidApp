import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  final String _menu;
  final String _userId;
  final String _userEmail;
  final String _userName;
  final String _userphnNo;
  String _school;
  String _std;
  String _about;

  ProfileScreen(this._menu, this._userId, this._userEmail, this._userName,
      this._userphnNo);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _pickedImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateEdits(BuildContext _context) async {
    SnackBar mySnackbar = SnackBar(
      duration: Duration(seconds: 20),
      content: Text('Updating...Please Wait!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: Theme.of(context).primaryColor,
    );
    ScaffoldMessenger.of(_context).showSnackBar(mySnackbar);
    try {
      if (_pickedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('User_Images')
            .child(widget._userId + 'jpg');
        await ref.putFile(_pickedImage).whenComplete(() => null);
        final img_url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget._userId)
            .update({'Image': img_url});
      }
      if (widget._school != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget._userId)
            .update({'School': widget._school});
      }
      if (widget._std != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget._userId)
            .update({'Standard': widget._std});
      }
      if (widget._about != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget._userId)
            .update({'About': widget._about});
      }
    } catch (err) {
      ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
        content: Text(
          '$err',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _pickImage(BuildContext _context) async {
    File pickedImageFile;

    try {
      ImageSource _source;
      await showDialog(
          context: _context,
          builder: (_) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                        child: Text('Take New Photo'),
                        onPressed: () {
                          _source = ImageSource.camera;
                          Navigator.of(context).pop();
                        }),
                    ElevatedButton(
                        child: Text('Choose Existing Photo'),
                        onPressed: () {
                          _source = ImageSource.gallery;
                          Navigator.of(context).pop();
                        })
                  ],
                ),
              ));
      if (_source != null) {
        pickedImageFile = await ImagePicker.pickImage(source: _source);
      }
    } finally {
      setState(() {
        _pickedImage = pickedImageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final appBar = AppBar(
      title: Text(widget._menu),
      centerTitle: true,
      actions: [
        Builder(builder: (context) {
          return Visibility(
            visible: ((widget._school != null || widget._std != null) ||
                    (widget._about != null || _pickedImage != null))
                ? true
                : false,
            child: TextButton(
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => updateEdits(context)),
          );
        })
      ],
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
          child: LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(widget._userId)
                      .get(),
                  builder: (context, snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.blueGrey.withOpacity(0.5),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                radius: constraints.maxHeight * 0.12,
                                backgroundImage: _pickedImage != null
                                    ? FileImage(_pickedImage)
                                    : (snapShot.data['Image'] != null
                                        ? NetworkImage(snapShot.data['Image'])
                                        : AssetImage(
                                            'assets/Images/userNull_image.jpg')),
                              ),
                              Container(
                                height: constraints.maxHeight * 0.07,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.add_a_photo,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () => _pickImage(context)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.blueGrey.withOpacity(0.5),
                          height: constraints.maxHeight * 0.06,
                        ),
                        Container(
                          color: Colors.white.withOpacity(0.5),
                          height: constraints.maxHeight * 0.08,
                          child: ListTile(
                              leading: Text('Standard:',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold)),
                              title: widget._std != null
                                  ? Text(widget._std)
                                  : (snapShot.data['Standard'] != null
                                      ? Text(snapShot.data['Standard'])
                                      : Text('eg. 11 science',
                                          style:
                                              TextStyle(color: Colors.grey))),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  String input;
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text('Standard'),
                                            content: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: 'Enter your Standard',
                                              ),
                                              onChanged: (value) {
                                                input = value;
                                              },
                                            ),
                                            actions: [
                                              IconButton(
                                                  icon: Icon(Icons.done),
                                                  onPressed: () {
                                                    widget._std = input;
                                                    Navigator.of(context).pop();
                                                  })
                                            ],
                                          ));
                                },
                              )),
                        ),
                        Container(
                          color: Colors.white.withOpacity(0.5),
                          height: constraints.maxHeight * 0.12,
                          child: ListTile(
                              leading: Text('Scl/Clg:',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold)),
                              title: widget._school != null
                                  ? Text(widget._school)
                                  : (snapShot.data['School'] != null
                                      ? Text(snapShot.data['School'])
                                      : Text(
                                          'eg. K J Somaiya Jr college of Science and commerce',
                                          style:
                                              TextStyle(color: Colors.grey))),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  String input;
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text('Standard'),
                                            content: TextFormField(
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Enter your School/ College',
                                              ),
                                              onChanged: (value) {
                                                input = value;
                                              },
                                            ),
                                            actions: [
                                              IconButton(
                                                  icon: Icon(Icons.done),
                                                  onPressed: () {
                                                    widget._school = input;
                                                    Navigator.of(context).pop();
                                                  })
                                            ],
                                          ));
                                },
                              )),
                        ),
                        Container(
                          color: Colors.white.withOpacity(0.5),
                          height: constraints.maxHeight * 0.2,
                          child: ListTile(
                              leading: Text('About:',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold)),
                              title: widget._about != null
                                  ? Text(widget._about)
                                  : (snapShot.data['About'] != null
                                      ? Text(snapShot.data['About'])
                                      : Text('Type Something about you :)',
                                          style:
                                              TextStyle(color: Colors.grey))),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  String input;
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text('About'),
                                            content: TextFormField(
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: 5,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Type something About you :)',
                                              ),
                                              onChanged: (value) {
                                                input = value;
                                              },
                                            ),
                                            actions: [
                                              IconButton(
                                                  icon: Icon(Icons.done),
                                                  onPressed: () {
                                                    widget._about = input;
                                                    Navigator.of(context).pop();
                                                  })
                                            ],
                                          ));
                                },
                              )),
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  top: constraints.maxHeight * 0.70,
                  height: constraints.maxHeight * 0.30,
                  width: constraints.maxWidth,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(30),
                          topRight: const Radius.circular(30),
                        )),
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Text('Name:'),
                          title: Text('${widget._userName}'),
                        ),
                        ListTile(
                          leading: Text('Email:'),
                          title: Text('${widget._userEmail}'),
                        ),
                        ListTile(
                          leading: Text('Contact:'),
                          title: Text('${widget._userphnNo}'),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
        ));
  }
}
