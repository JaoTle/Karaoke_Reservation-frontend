import 'package:flutter/material.dart';
import 'package:karaoke_reservation/components/screens_body/login_body.dart';
import 'package:karaoke_reservation/themes/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fromPage = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: ()=> Navigator.pop(context), 
            icon: Icon(Icons.arrow_back_ios_new_rounded,size: 35,),
            color: lightToneColor)
        ),
        body: LoginBody(fromPage)
      ),
    );
  }
}