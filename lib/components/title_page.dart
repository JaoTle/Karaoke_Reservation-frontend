import 'package:flutter/material.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';

Widget titleWidget(String text){
  return Padding(
    padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
    child: Row(
      children: [
        titlePage(text),
        SizedBox(width: 10),
        Expanded(
          child: Divider(
            color: lightToneColor,
            thickness: 3,
          ),
        )
      ],
    ),
  );
}

Widget centerTitleWidget(String branch){
  return Padding(
    padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
    child: Row(
      children: [Expanded(
          child: Divider(
            color: lightToneColor,
            thickness: 3,
          ),
        ),
        SizedBox(width: 10),
        titlePage(branch),
        SizedBox(width: 10),
        Expanded(
          child: Divider(
            color: lightToneColor,
            thickness: 3,
          ),
        )
      ],
    ),
  );
}