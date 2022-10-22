import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/themes/colors.dart';

class PreLoginBody extends StatelessWidget {
  const PreLoginBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return SizedBox(
    width: double.infinity,
    child: Column(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Spacer(),
              Image.asset("assets/images/CC_karaoke.png",
              height: SizeConfig().getScreenWidth() * 0.65 ,
              width:SizeConfig().getScreenWidth() * 0.65 
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 50,right: 50),
                child: Text("Entertainment service that makes you relax and enjoy your time.",
                style:TextStyle(fontFamily: "MavenPro",fontSize: 16),
                textAlign: TextAlign.center,
                ),
              )
            ],
          )
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Spacer(),
              SizedBox(
                width: 200,
                child: normalButton(
                  () => Navigator.pushNamed(context, "/login",arguments: "customer")
                  , "SIGN IN")
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ",
                  style: TextStyle(
                    color: darkToneColor,
                    fontFamily: "MavenPro",
                    fontSize: 16
                    )
                  ),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                    child: Text("Sign up",
                    style: TextStyle(
                      color: darkToneColor,
                      fontFamily: "MavenPro",
                      decoration: TextDecoration.underline,
                      fontSize: 16
                      ),
                    ),
                  )
                ],
              ),
              Spacer(),
            ],
          )
        )
      ],
    ),  
   );
  }
}