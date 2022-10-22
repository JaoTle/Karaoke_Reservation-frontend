import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

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
                height: SizeConfig().getScreenWidth() * 0.7,
                width: SizeConfig().getScreenWidth() * 0.7
                ),
                Spacer(),
                Text("The part of the user that you use as..",style: TextStyle(fontFamily: "MavenPro",fontSize: 18))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      splashRadius: 50,
                      onPressed: () => Navigator.pushNamed(context, '/login',arguments: "service"), 
                      icon: Image.asset("assets/icons/service_provider.png"),
                      iconSize: 80,
                    ),
                    IconButton(
                      splashRadius: 50,
                      onPressed: () => Navigator.pushNamed(context, '/pre-login'), 
                      icon: Image.asset("assets/icons/customers_icon.png"),
                      iconSize: 80,
                    )
                  ],
                ),
                Spacer()
              ],
            ),
          )
        ],
      ),
    );
  }
}