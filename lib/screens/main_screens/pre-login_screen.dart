import 'package:flutter/material.dart';
import 'package:karaoke_reservation/components/screens_body/pre-login_body.dart';
import 'package:karaoke_reservation/themes/colors.dart';

class PreLoginScreen extends StatelessWidget {
  const PreLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: ()=> Navigator.pop(context), 
            icon: Icon(Icons.arrow_back_ios_new_rounded,size: 35,),
            color: lightToneColor),
        ),
        body: PreLoginBody()
      ),
    );
  }
}