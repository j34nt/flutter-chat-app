import 'package:flutter/material.dart';

class BtnBlue extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  BtnBlue({
    Key? key,
    required this.text,
    required this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      style:ElevatedButton.styleFrom(
        elevation: 2,
        onPrimary: Colors.blue,
        shape: StadiumBorder(),
      ),
      onPressed: this.onPress,
      child: Container(
        width: double.infinity,
        child: Center(
          child: Text('Ingrese', style: TextStyle(color: Colors.white, fontSize: 17),),
        ),
      )
    );
  }
}