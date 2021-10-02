import 'dart:io';

import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {


  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _itsWriting = false;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('personal-message', _listenMessages);

    _loadHistory(this.chatService.userTo.uid);
  }

  void _loadHistory(String userId) async {
    List<Message> chat = await this.chatService.getChat(userId);
    final history = chat.map((m) => new ChatMessage(
      text: m.message,
      uid: m.from,
      animationController: new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 0)
      )..forward()
    )
    );
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessages(dynamic payload) {
    ChatMessage message = new ChatMessage(
      text: payload["message"],
      uid: payload["from"],
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200))
    );
    setState(() {
      _messages.insert(0, message);
      
    });
    message.animationController.forward();
  }


  @override
  Widget build(BuildContext context) {
    final userTo = chatService.userTo;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(userTo.name.substring(0,2), style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blueAccent,
              maxRadius: 14,
            ),
            SizedBox(height: 3,),
            Text(userTo.name, style: TextStyle(color: Colors.black87, fontSize: 12),)
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87,),
          onPressed: (){
            Navigator.pop(context);
          },
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
    if(text.length == 0) {
      return;
    }
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      text: text,
      uid: authService.user.uid,
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

    socketService.emit('personal-message', {
      'from': authService.user.uid,
      'to':chatService.userTo.uid,
      'message':text
    });

  }
  void dispose() {
    //TODO off del socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
      
    }
    this.socketService.socket.off('personal-message');

    super.dispose();
  }
}