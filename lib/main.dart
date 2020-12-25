import 'package:flutter/material.dart';
import 'BaseScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Login.dart';
void main() {
  runApp(MyApp());
  print("IN main");
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key:key);
  _MyAppState createState()=> _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Future<void> initialize() async{
    await Firebase.initializeApp();
  }
  @override
  Widget build(BuildContext context) {
    print("Material App");
    return MaterialApp(
      home:
      FutureBuilder(future: initialize(),builder: (context,snapshot){
              print(snapshot.connectionState);
              if(snapshot.hasError){
                print(snapshot.error);
              }
              if(snapshot.connectionState==ConnectionState.done){
                return Login();
              }
              return Center(
                child: Text('Loading Messages'),
              );
            },),
      // home: BaseScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}