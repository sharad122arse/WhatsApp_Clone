import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MyItems.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Lets_chat.dart';
class BaseScreen extends StatefulWidget{
  final String uid;
  const BaseScreen({Key key,this.uid}) : super(key: key);
  // BaseScreen(this.collectionReference);
  _BaseScreenState createState()=> _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen>{
  MessageItem temp=MessageItem('ok', 'ok');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsApp"),
        backgroundColor: Color(0xFF2E7D32),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context,snapshot){
          print(snapshot.connectionState);
          if(snapshot.connectionState==ConnectionState.active){
            print(snapshot);
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,i){
                temp.sender=snapshot.data.docs[i].data()['name'];
                temp.body=snapshot.data.docs[i].data()['message'];
                print(widget.uid+" "+snapshot.data.docs[i].data()['id']);
                if(snapshot.data.docs[i].data()['id']!=widget.uid) {
                  return Container(
                    child: GestureDetector(
                        child: display(temp),
                        onTap: (){
                          print("it is tapped");
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Lets_chat(id1: widget.uid,id2:snapshot.data.docs[i].data()['id'],name: snapshot.data.docs[i].data()['name'],)));
                          // openDialog(context,snapshot.data.docs[i].data()['name']);
                        }
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          }
          return Text('Loading');
          print(snapshot);
        },
      )
    );
  }
  ListTile display(MessageItem msg){
    String sender=msg.sender;
    String message=msg.body;
    return ListTile(
      title: Text(sender),
      subtitle: Text(message),
    );
  }
}