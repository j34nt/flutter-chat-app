import 'package:chat_app/helpers/show_alert.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/btn_blue.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xfff2f2f2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(title: 'Messenger',),
                _Form(),
                Labels(route: 'register', text: '¿No tienes cuenta?',textButton: 'Crea una ahora!',),
                Text('Terminos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200),)
              ],
            ),
          ),
        ),
      )
   );
  }
}

class _Form extends StatefulWidget {

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: EdgeInsets.only(top:40),
      padding: EdgeInsets.symmetric(horizontal: 50),
       child: Column(
         children: <Widget>[
           CustomeInput(
             icon: Icons.mail_outline,
             placeholder: 'Email',
             keyboardType: TextInputType.emailAddress,
             textController: emailCtrl,
           ),
           CustomeInput(
             icon: Icons.lock_outline,
             placeholder: 'Contraseña',
             textController: passCtrl,
             isPassword: true,
           ),


          //TODO create button
          BtnBlue(
            text: 'Ingrese',
            onPress: authService.isAuth ? null : () async { 
              FocusScope.of(context).unfocus();
              final loginOk = await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());
              if(loginOk) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'users');
              } else {
                // show alert
                showAlert(context, 'Login Incorrecto', 'Revise sus credenciales');
              }
            }
          )
         ],
       ),
    );
  }
}