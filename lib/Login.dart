import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'BaseScreen.dart';
import 'Signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Login extends StatefulWidget{
  const Login({Key key}) : super(key:key);
  _LoginState createState()=> _LoginState();
}

class _LoginState extends State<Login>{
  final controller_username=TextEditingController();
  final controller_password=TextEditingController();
  final controller_name=TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void dispose(){
    controller_username.dispose();
    controller_password.dispose();
    controller_name.dispose();
    super.dispose();
  }
  String username="",password="";
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("WhatsApp"),
          backgroundColor: Color(0xFF2E7D32),
        ),
        body: Form(
          key: _formKey,
              child: Center(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    Container(
                      child: Center(child: Text('Sign Up')),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    TextFormField(
                      controller: controller_name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                      validator: (String value){
                        if(value.isEmpty){
                          return 'Enter your Name';
                        }
                        return null;
                      },
                    ),
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
                      child: Text("Ok"),
                      onPressed: () async {
                        print("pressed");
                        username=controller_username.text;
                        password=controller_password.text;
                        if(_formKey.currentState.validate()){
                          _register();
                        }
                      }
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    RaisedButton(
                      child: Text('Sign In'),
                      onPressed: (){
                        Navigator.push(context,
                          MaterialPageRoute( builder: (context)=>Signin()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
      );
  }
  void _register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
      var firebaseUser = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('Users').doc(firebaseUser.uid).set(
        {
          "name" : controller_name.text,
          "message" : "i am a new user",
          'id' : firebaseUser.uid,
        }
      ).then((_){
        print("success!");
      });
      Navigator.push(context,MaterialPageRoute(builder: (context)=>BaseScreen(uid:firebaseUser.uid)));
    }on FirebaseAuthException catch (e){
      openDialog(context,e.code);
    }
    catch (e){
      openDialog(context, e.toString());
    }
  }
  openDialog(BuildContext context,String name){
    AlertDialog dialog = AlertDialog(
        title: Text(name),
        content: Text("do you want to read the chat"),
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