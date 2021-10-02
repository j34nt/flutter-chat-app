import 'package:chat_app/models/users_response.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/global/environments.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/models/user.dart';

class UsersService {

  Future<List<User>> getUsers() async {
    final uri = Uri.parse('${Environments.apiUrl}/users/');
    final token = await AuthService.getToken();
    try {
      final resp = await http.get(uri,
        headers: {
          'Content-Type':'application/json',
          'x-token': token != null ? token : ''
        }
      );

      final usersResponse = usersResponseFromJson(resp.body);
      return usersResponse.users;

    } catch(e) {
      return [];
    }

  }
}