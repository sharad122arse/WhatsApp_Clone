import 'package:flutter/material.dart';

abstract class MyItems{
  Widget buildTitle(BuildContext context);
  Widget buildImage(BuildContext context);
  Widget buildMessage(BuildContext context);
  Widget buildMsgCount(BuildContext context);
}
class MessageItem implements MyItems{
  String sender;
  String body;
  MessageItem(this.sender,this.body);
  Widget buildTitle(BuildContext context){
    return Text(sender);
  }
  Widget buildMessage(BuildContext context){
    return Text(body);
  }
  Widget buildImage(BuildContext context)=>null;
  Widget buildMsgCount(BuildContext context)=>null;
}