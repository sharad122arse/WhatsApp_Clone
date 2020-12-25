import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
class Lets_chat extends StatefulWidget{
  final String id1,id2,name;
  const Lets_chat({Key key,this.id1,this.id2,this.name}):super(key: key);
  _Lets_chat_State createState()=>_Lets_chat_State();
}

class _Lets_chat_State extends State<Lets_chat>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Color(0xFF2E7D32),
      ),
      body: Container(
        child: Chat_Space(id1: widget.id1,id2: widget.id2),
      ),
    );
  }
}

class Chat_Space extends StatefulWidget{
  final String id1,id2;
  const Chat_Space({Key key,this.id1,this.id2}):super(key: key);
  _Chat_Space_State createState()=> _Chat_Space_State();
}

class _Chat_Space_State extends State<Chat_Space>{
  final controller_message=TextEditingController();
  @override
  void dispose() {
    controller_message.dispose();
    super.dispose();
  }
  int msg_count;
  // var database = FirebaseFirestore.instance.collection('message');
  @override
  Widget build(BuildContext context) {
    // push_messages();
    print(widget.id1+" "+widget.id2);
    double mh = MediaQuery.of(context).size.height;
    double mw = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // Flex(
        //   direction: Axis.vertical,
        //   children:[
            Expanded(
            child: Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Users').doc(widget.id1).collection(widget.id2).orderBy('createAt',descending: true).snapshots(),
                builder: (context,snapshot){
                  print("Snapshot Stream "+snapshot.connectionState.toString());
                  if(snapshot.connectionState==ConnectionState.active){
                    msg_count=snapshot.data.docs.length;
                    if(msg_count==null){
                      msg_count=0;
                    }
                    return ListView.builder(
                      reverse: true,
                      padding:EdgeInsets.only(left: 5.0,top: 5.0,right: 5.0),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context,i){
                        print(snapshot);
                        if(snapshot.data.docs.length==0){
                          return Container(
                            child: Text('no messages'),
                          );
                        }else{
                          if(snapshot.data.docs[i].data()['id']==widget.id1){
                            return
                              Flex(
                                direction: Axis.horizontal,
                                children:[ Flexible(
                              child: Align(
                                alignment: Alignment.centerRight,
                                    child: Container(
                                      // width: ,
                                      padding: EdgeInsets.all(7.0),
                                      decoration:BoxDecoration(
                                        // color: Colors.grey,
                                        border: Border.all(
                                          color:Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      // child: Expanded(
                                        child: Text(
                                            snapshot.data.docs[i].data()['message'],
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.justify,
                                            maxLines: 10,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17.0,
                                            ),
                                        ),
                                      // ),
                                    ),
                                  ),
                                ),
                                ]
                            );
                          }
                          return
                             Flex(
                                direction: Axis.horizontal,
                                children:[ Flexible(
                             child: Align(
                               alignment:Alignment.centerLeft,
                                    child: Container(
                                      // width: 150,
                                      padding: EdgeInsets.all(7.0),
                                      decoration: BoxDecoration(
                                        // color: Colors.amberAccent,
                                        border: Border.all(
                                          color: Colors.amberAccent,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)
                                        )
                                      ),
                                      child: Text(
                                        snapshot.data.docs[i].data()['message'],
                                        style: TextStyle(
                                          color:Colors.black,
                                          fontSize: 17.0,
                                        ),
                                        maxLines: 10,
                                        // textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                // ),
                            ),
                        ]
                              );
                        }
                      },
                    );
                  }else{
                    print('Yes\n');
                    return Container();
                  }
                },
              ),
            ),
          ),
        //   ]
        // ),
        Container(
          child: Row(
            children: [
              // Expanded(
              Container(
                width: 0.75*mw,
                height: 0.09*mh,
                padding: EdgeInsets.only(top: 10.0),
                child: Center(
                  child: TextField(
                    controller: controller_message,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write your own message',
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                width: 0.25*mw,
                height: 0.09*mh,
                child: RaisedButton(
                  child: Text('Send'),
                  onPressed: (){
                    push_messages();
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
  void push_messages(){
    if(controller_message.text==""){
      return;
    }
    FirebaseFirestore.instance.collection('Users').doc(widget.id1).collection(widget.id2).doc('messgae$msg_count').set({
      'message':controller_message.text,
      'id':widget.id1,
      'createAt':Timestamp.now(),
      'number':msg_count,
    });
    FirebaseFirestore.instance.collection('Users').doc(widget.id2).collection(widget.id1).doc('message$msg_count').set({
      'message':controller_message.text,
      'id':widget.id1,
      'createAt':Timestamp.now(),
      'number':msg_count,
    });
    controller_message.text="";
  }
}