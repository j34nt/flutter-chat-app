import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {


  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _itsWriting = false;
  List<ChatMessage> _messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blueAccent,
              maxRadius: 14,
            ),
            SizedBox(height: 3,),
            Text('Test 1', style: TextStyle(color: Colors.black87, fontSize: 12),)
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_,i) => _messages[i],
                reverse: true,
              )
            ),
            Divider(height: 1,),
            //TODO textBox
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      )
   );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String text) {
                  setState(() {
                    if(text.trim().length > 0) {
                      _itsWriting = true;
                    } else {
                      _itsWriting = false;
                    }
                  });

                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              )
            ),
            //SEND button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
              ? CupertinoButton(
                child: Text('Enviar'),
                onPressed: _itsWriting ? () => _handleSubmit(_textController.text.trim()) : null,
              )
              : Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.send),
                    onPressed: _itsWriting ? () => _handleSubmit(_textController.text.trim()) : null,
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    print(text);
    if(text.length == 0) {
      return;
    }
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      text: text,
      uid: '123',
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400)
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _itsWriting = false;
    });

  }
  void dispose() {
    //TODO off del socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
      
    }

    super.dispose();
  }
}