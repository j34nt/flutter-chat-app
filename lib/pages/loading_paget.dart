import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/users_page.dart';

import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/socket_service.dart';


class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 

        return Center(
          child: Text('Autenticando...'),
        );
        },
      ),
   );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final auth = await authService.isLoggedIn();
    if(auth) {
      socketService.connect();
      // Navigator.pushReplacementNamed(context, 'users');
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => UsersPage(),
        transitionDuration: Duration(milliseconds: 0)
      ));
    } else {
      // Navigator.pushReplacementNamed(context, 'login');
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => LoginPage(),
        transitionDuration: Duration(milliseconds: 0)
      ));
    }
  }
}