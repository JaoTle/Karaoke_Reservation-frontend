import 'package:flutter/material.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

Shader linearGradientTitle = const LinearGradient(
  colors: <Color>[darkToneColor,lightToneColor],
).createShader(const Rect.fromLTWH(120,0, 120, 0));

Shader linearGradientAppBar = const LinearGradient(
  begin: Alignment.center,
  end: Alignment.bottomCenter,
  colors: <Color>[darkToneColor,lightToneColor,secondaryColor],
).createShader(const Rect.fromLTWH(0,185,0,350));

GradientText titlePage(String text){
  return GradientText(
    text, 
    colors: gradientTitle,
    style: TextStyle(
      fontSize: 24,
      fontFamily: 'MavenPro',
      fontWeight: FontWeight.w600
      ),
  );
}

GradientText titleAppBar(String text){
  return GradientText(
    text, 
    colors: gradientAppBar,
    style: TextStyle(
      fontFamily: 'MajorMono',
      fontSize: 30,
    ),
    gradientDirection: GradientDirection.ttb,
  );
}
List<Color> gradientTitle = [darkToneColor,lightToneColor];
List<Color> gradientAppBar = [darkToneColor,lightToneColor,secondaryColor];



TextStyle labelNormalButton =  const TextStyle(
  fontFamily: 'MavenPro',
  fontSize: 24,
  color: secondaryColor
);

TextStyle labelManageButton = const TextStyle(
  fontFamily: 'K2D',
  fontSize: 20,
  color: darkToneColor,
  letterSpacing: 0.5
);

TextStyle labelManageButtonHover = const TextStyle(
  fontFamily: 'K2D',
  fontSize: 20,
  color: Colors.white,
  letterSpacing: 0.5,

);

TextStyle labelTextField = const TextStyle(
  fontFamily: 'MavenPro',
  fontSize: 16,
  color: darkToneColor
);

TextStyle inputField = const TextStyle(
  fontFamily: 'MavenPro',
  fontSize: 18,
  color: darkToneColor
);

OutlineInputBorder inputBorderStyle = OutlineInputBorder(
  borderRadius:BorderRadius.circular(40),
  borderSide: BorderSide(width: 1.5,color: secondaryColor)
);

TextStyle titleAlert = TextStyle(
  color: darkToneColor,
  fontWeight: FontWeight.bold,
  fontSize: 30,
  fontFamily: 'MavenPro'
);

TextStyle detailsAlert = TextStyle(
  fontFamily: 'MavenPro',
  fontSize: 20
);

TextStyle btnAlert = TextStyle(
  fontFamily: 'MavenPro',
  fontSize: 20,
  color: secondaryColor
);

TextStyle navBarTextStyle = TextStyle(
  fontFamily: 'MavenPro',
  fontSize: 16,
  color: Colors.white
);

const BoxShadow navBarShadow = BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3)
                        );


TextStyle labelBranch =  const TextStyle(
  fontFamily: 'MavenPro',
  fontSize: 24,
  color: darkToneColor
);

InputDecoration inputDecor(String text) => InputDecoration(
  labelText: text,
  labelStyle: labelTextField,
  enabledBorder: inputBorderStyle,
  focusedBorder:inputBorderStyle,
  floatingLabelStyle: inputField,
  floatingLabelBehavior: FloatingLabelBehavior.always,
  floatingLabelAlignment: FloatingLabelAlignment.center,
);

TextStyle infoText = TextStyle(
  fontFamily: "K2D",
  fontSize: 20,
  color: darkToneColor
);

TextStyle timeText = TextStyle(
  fontFamily: "K2D",
  fontSize: 16,
  color: lightToneColor
);

TextStyle inputThaiField = const TextStyle(
  fontFamily: 'K2D',
  fontSize: 20,
  color: darkToneColor,
  fontWeight: FontWeight.w600
);


TextStyle bookingLabelStyle = TextStyle(fontSize: 16,fontFamily: 'MavenPro',color: darkToneColor,fontWeight: FontWeight.bold);
TextStyle bookingInfoStyle = TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: secondaryColor);

TextStyle titleAlert_thai = TextStyle(
  color: darkToneColor,
  fontWeight: FontWeight.bold,
  fontSize: 30,
  fontFamily: 'K2D'
);

TextStyle detailsAlert_thai = TextStyle(
  fontFamily: 'K2D',
  fontSize: 16
);

TextStyle btnAlert_thai = TextStyle(
  fontFamily: 'K2D',
  fontSize: 20,
  color: secondaryColor
);

TextStyle dropDownBookingField = const TextStyle(
  fontFamily: 'K2D',
  fontSize: 18,
  color: darkToneColor,
  fontWeight: FontWeight.w600
);

TextStyle priceDetailStyle = TextStyle(
  fontFamily: 'K2D',
  fontSize: 18,
  color: darkToneColor
);