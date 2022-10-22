import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/themes/colors.dart';

class BoxStatus extends StatelessWidget {
  BoxStatus({this.status});
  String? status;
  Color? cl;
  @override
  Widget build(BuildContext context) {
    if(status == "Available now") cl = Colors.white;
    else if(status == "Unavailable now") cl = darkToneColor;
    else if(status == "Selecting") cl = lightToneColor;
    return Row(
      children: [
        Container(
          width: SizeConfig.screenWidth! * 0.07,
          height: SizeConfig.screenWidth! * 0.07,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: secondaryColor),
            color: cl
          ),
        ),
        SizedBox(width: 5),
        Text(status!,style: TextStyle(color: darkToneColor,fontFamily: 'MavenPro',fontSize: 14),)
      ],
    );
  }
}