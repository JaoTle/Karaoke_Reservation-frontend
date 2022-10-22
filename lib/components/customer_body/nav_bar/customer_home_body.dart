import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/contain_card.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/user_model.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';

class CustomerHomeBody extends StatelessWidget {
  UserModel? _activeUser;
  @override
  Widget build(BuildContext context) {
    UserModel _activeUser  =context.watch<UserProvider>().activeUser;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 30,left: 10,right: 10),
        child: Center(
          child: Column(
            children: [
              Container(
                width: SizeConfig.screenWidth! * 0.85,
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/user_card.png"),fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1,color: darkToneColor)
                ),
                child: Stack(
                  children: [
                    Positioned(
                      child: Text("Welcome, ${_activeUser.name}",
                        style: TextStyle(fontFamily: "MavenPro",fontSize: 24,color: darkToneColor),
                      ),
                      top: 10,
                      left: 15,
                    ),
                    Positioned(
                      child: _buildDetailBox("ชั่วโมงสะสม : ${_activeUser.totalHours} ชั่วโมง", Icons.timelapse_rounded),
                      top: 50,
                    ),
                    Positioned(
                      child: (_activeUser.topBranches == null)
                      ?_buildDetailBox("สาขาโปรด : -", Icons.favorite_outline_rounded)
                      :_buildDetailBox("สาขาโปรด : ${_activeUser.topBranches![0]}", Icons.favorite_outline_rounded),
                      bottom: 20,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              centerTitleWidget("REMAINING TOP"),
              (_activeUser.topBranches == null) 
              ? SizedBox()
              :(_activeUser.topBranches!.length > 1)
              ?Column(
                children: [
                  SizedBox(height: 30),
                  _buildTopBranchCard(1),
                  SizedBox(height: 30),
                  _buildTopBranchCard(2)
                ],
              )
              : Container(
                height: SizeConfig.screenHeight! *0.4,
                child: Center(child: Text("No more top branches.",style: infoText,)),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTopBranchCard(int pos){
    if(_activeUser!.topBranches == null){
      return SizedBox();
    }
    else return containCard(
      Padding(
        padding: const EdgeInsets.only(left: 20,right: 10),
        child: Row(
          children: [
            Image.asset('assets/icons/branch.png',width: SizeConfig.screenWidth! * 0.15,),
            SizedBox(width: 20),
            Flexible(
              child: Container(
                child: Text("${_activeUser!.topBranches![pos]}",style: TextStyle(fontFamily: 'MavenPro',fontSize: 25),
                overflow: TextOverflow.ellipsis,
                
                ),
              ),
            )
          ],
        ),
      ),
      0.8
    );
  }

  Widget _buildDetailBox(String text,IconData icon){
  return Padding(
    padding: const EdgeInsets.only(left: 10,right: 10),
    child: Card(
      color: greyBg,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.only(left: 7,right: 7),
        height: 30,
        width: SizeConfig.screenWidth! *0.75   ,
        child: Center(
          child: Row(
            children: [
              Icon(icon,color: secondaryColor),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(fontFamily: 'K2D',fontSize: 20,color: secondaryColor),
              ),
            ],
          )
        ),
      ),
    ),
  );
 }
}