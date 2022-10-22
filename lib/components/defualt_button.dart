import 'package:flutter/material.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';

Widget normalButton(Function() onPressed,String label){
  return ElevatedButton(
    onPressed: onPressed, 
    child: Text(label,style: labelNormalButton,),
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(0),
      backgroundColor: MaterialStateProperty.all<Color>(greyBg),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(color: secondaryColor,width: 1.5)
          )
        )
      )
    );
}

Widget normalBtn(Function()? onPressed,String label,bool normal){
  return ElevatedButton(
    onPressed: onPressed, 
    child: Text(label,style: normal ? labelManageButton : labelManageButtonHover,),
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(0),
      backgroundColor: MaterialStateProperty.all<Color>(normal ?Colors.white:darkToneColor),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(color: normal?secondaryColor:Colors.white,width: 1.5)
          )
        )
      )
    );
}

Widget manageButton(Function() onPressed,String label,IconData icon){
  bool isHover = false;
  return ElevatedButton.icon(
    onPressed: onPressed, 
    onHover: (value) => isHover = !isHover,
    icon: Icon(icon,color: isHover ? Colors.white : darkToneColor), 
    label: Text(label,
    style: isHover ? labelManageButtonHover : labelManageButton ),
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states){
        if(states.contains(MaterialState.hovered)) return secondaryColor;
        return Colors.white;
      }),
      shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder?>(
          (Set<MaterialState> states){
            if(states.contains(MaterialState.hovered)) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side:const BorderSide(color: Colors.white,width: 1)
              );
            }
            return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side:const BorderSide(color: secondaryColor,width: 1)
              );
          }
        )
      )
    );
}