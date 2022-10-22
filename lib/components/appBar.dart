import 'package:flutter/material.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
AppBar appBarCustom(bool isHaveBack,BuildContext context,{Function()? function}){
  return AppBar(
    leading: isHaveBack 
    ? IconButton(
        onPressed: (){
          if(function != null) function();
          Navigator.pop(context);
        } , 
        icon: Icon(Icons.arrow_back_ios_new_rounded,size: 35,),
        color: lightToneColor)
    : null,
    elevation: 1,
    backgroundColor: greyBg,
    title: Row(
      children: [
        Image.asset("assets/icons/cc_icon.png",
        ),
        SizedBox(width: 10,),
        titleAppBar("cc KARAOKE")
      ],
    ),
    centerTitle: true,
    titleSpacing: 3,
  );
}