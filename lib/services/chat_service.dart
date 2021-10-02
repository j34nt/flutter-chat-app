import 'package:chat_app/global/environments.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/models/user.dart';

class ChatService with ChangeNotifier {
  late User userTo;

  Future<List<Message>> getChat(String userId) async {
    final token = await AuthService.getToken();
    final uri = Uri.parse('${Environments.apiUrl}/messages/$userId');
    final resp = await http.get(uri,
      headers: {
        'Content-Type':'application/json',
        'x-token': token != null ? token : ''
      }
    );

    final messagesResp = messagesResponseFromJson(resp.body);

    return messagesResp.messages;

  }
}