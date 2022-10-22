import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/contain_card.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/user_model.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:provider/provider.dart';

class CustomerMenuBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _activeUser = context.watch<UserProvider>().activeUser;
    return Column(
      children: [
        titleWidget("PROFILE"),
        userCard(_buildUserDetails(_activeUser), 0.8),
        Flexible(
          fit: FlexFit.loose,
          child: ListView(
            children: [
              _buildListMenu("My coupons", Icons.confirmation_number_outlined, 
              () => Navigator.pushNamed(context,'/cus_mycoupons',arguments: _activeUser.username)),
              _buildListMenu("Booked", Icons.event, 
              () => Navigator.pushNamed(context, '/cus_check_booked',arguments: _activeUser.username)),
              _buildListMenu("History", Icons.history,
              () => Navigator.pushNamed(context, '/cus_history')),
              _buildListMenu("Logout", Icons.logout,
              () => Navigator.popUntil(context, (route) => route.isFirst))
            ],
          ),
        )
      ],
    );
  }
  Widget _buildUserDetails(UserModel account){
    return Padding(
      padding: const EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 5),
      child: Row(
        children: [
          Image.asset("assets/icons/mic.png",width: 60),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${account.name}",style: TextStyle(fontFamily: 'K2D',fontSize: 20,color: darkToneColor,fontWeight: FontWeight.w500)),
              Text("${account.username}",style: TextStyle(fontFamily: 'K2D',fontSize: 16,color: darkToneColor)),
              Row(
                children: [
                  Icon(Icons.timelapse_rounded,color: secondaryColor),
                  SizedBox(width: 10),
                  Text("ชั่วโมงสะสม : ${account.totalHours} ชั่วโมง",style:TextStyle(fontFamily: 'K2D',fontSize: 16,color: darkToneColor))
                ],
              ),
            ]
          )
        ],
      ),
    );
  }
  Widget _buildListMenu(String label,IconData icon,Function() tap){
    return InkWell(
      onTap: tap,
      child: Card(
        shape: BeveledRectangleBorder(),
        margin: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: secondaryColor))
          ),
          child: ListTile(
            leading: Icon(icon,color: secondaryColor),
            title: Text(label,style: TextStyle(fontFamily: 'MavenPro',color: secondaryColor),),
          ),
        ),
      ),
    );
  }
}