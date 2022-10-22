import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/forms/signup_form.dart';
import 'package:karaoke_reservation/themes/colors.dart';

class SignUpBody extends StatelessWidget {

  var screenWidth = SizeConfig().getScreenWidth();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 20,),
            Image.asset("assets/images/header_signup.png",
              width: screenWidth * 0.8,
            ),
            SizedBox(height: 30),
            Container(
              width: screenWidth * 0.8,
              padding: EdgeInsets.only(left: 20,right: 20),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Signup",
                    style: TextStyle(
                      color: darkToneColor,
                      fontFamily: 'MavenPro',
                      fontSize: screenWidth *0.07,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Text("Create your account",
                    style: TextStyle(
                      color: lightToneColor,
                      fontFamily: 'MavenPro',
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth *0.04
                    ),
                  ),
                  SizedBox(height: 20),
                  SignupForm()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}