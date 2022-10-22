import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/booking_part/booking_part_body.dart';
import 'package:karaoke_reservation/components/booking_part/box_status.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/providers/emp_page_provider.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:provider/provider.dart';

class EmpManageRoomBody extends StatelessWidget {
  var _branchNow,branchKey;
  @override
  Widget build(BuildContext context) {
     var dateTimeNow = DateTime.now();
    _branchNow = context.watch<UserProvider>().activeUser.stationedBranchId;
    branchKey = context.watch<EmpProvider>().branchKey;
    return SingleChildScrollView(
      child: Column(
        children: [
          titleWidget("MANAGE ROOMS"),
          Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/branch.png',width: SizeConfig.screenWidth! *0.1,),
                    SizedBox(width: 20),
                    Text("สาขา : ${findBranchName(_branchNow)}",style: TextStyle(color: darkToneColor,fontFamily: 'K2D',fontSize: 20),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                child: Text("${DateFormat("dd MMMM yyyy").format(dateTimeNow)}",style: TextStyle(color: darkToneColor,fontFamily: 'K2D',fontSize: 20),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BoxStatus(status: "Available now"),
                    BoxStatus(status: "Unavailable now"),
                    BoxStatus(status: "Selecting")
                  ],
                ),
              ),
              BookingPartBody(_branchNow,false)
        ],
      ),
    );
  }

    String findBranchName(String branchId){
    var result = branchKey.indexWhere((element) => element.branchId == branchId);
    if(result != -1) return branchKey[result].branchName;
    return "";
  }
}