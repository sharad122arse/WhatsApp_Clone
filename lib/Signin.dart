import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'BaseScreen.dart';

class Signin extends StatefulWidget {
  const Signin({Key key}) :super(key: key);
  _SigninState createState() => _SigninState();
}
class _SigninState extends State<Signin>{
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final controller_username=TextEditingController();
  final controller_password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsApp"),
        backgroundColor: Color(0xFF2E7D32),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            TextFormField(
              controller: controller_username,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              validator: (String value){
                if(value.isEmpty){
                  return 'Please Enter Your Email id';
                }
                return null;
              },
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            TextFormField(
              controller: controller_password,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password'
              ),
              obscureText: true,
              validator: (String value){
                if(value.isEmpty){
                  return 'Please Enter password';
                }
                return null;
              },
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            RaisedButton(
              child: Text('Sign In'),
              onPressed: (){
                if(_formkey.currentState.validate()){
                  _signin();
                }
              },
            )
          ],
        ),
      ),
    );
  }
  void _signin() async {
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: controller_username.text,
          password: controller_password.text
      );
      var firebaseUser = FirebaseAuth.instance.currentUser;
      Navigator.push(context,MaterialPageRoute(builder: (context)=>BaseScreen(uid:firebaseUser.uid)));
    }on FirebaseAuthException catch(e){
      if(e.code =='user-not-found'){
        openDialog(context,'No User Found');
      }else if(e.code == 'wrong-password'){
        openDialog(context,"Wrong Password");
      }else{
        openDialog(context, e.code);
      }
    }
  }
  openDialog(BuildContext context,String name){
    AlertDialog dialog = AlertDialog(
        title: Text(name),
        content: Text(name),
        actions: [
          FlatButton(
            child: Text("Ok"),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ]
    );
    showDialog(
      context: context,
      builder:(BuildContext context){
        return dialog;
      },
    );
  }
}