import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/themes/colors.dart';

Widget containCard(Widget child,double fixSize){
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: secondaryColor,
          width: 1
        ),
      ),
      elevation: 5,
      child: Container(
        width: SizeConfig.screenWidth! * fixSize,
        height: 90,
        child: child,
      ),
    ),
  );
}

Widget userCard(Widget child,double fixSize){
  return Padding(
    padding: const EdgeInsets.only(bottom: 10,top: 10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: secondaryColor,
          width: 1
        ),
      ),
      elevation: 5,
      child: Container(
        width: SizeConfig.screenWidth! * fixSize,
        height: 100,
        child: child,
      ),
    ),
  );
}