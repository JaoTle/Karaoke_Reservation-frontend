import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/forms/login_form.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LoginBody extends StatelessWidget {
  LoginBody(this.fromPage) ;
  String fromPage;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            GradientText("WELCOME", 
            colors: gradientAppBar,
            gradientDirection: GradientDirection.ltr,
            style: TextStyle(
              fontFamily: 'MajorMono',
              fontSize: 32
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Image.asset("assets/images/CC_karaoke.png",
              height:SizeConfig().getScreenWidth() * 0.65 ,
              width:SizeConfig().getScreenWidth() * 0.65 
            ),
            SizedBox(height: 50),
            LoginFieldForm(fromPage),
          ],
        ),
      ),
    );
  }
}