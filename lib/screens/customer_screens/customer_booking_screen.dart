import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/appBar.dart';
import 'package:karaoke_reservation/components/booking_part/booking_part_body.dart';
import 'package:karaoke_reservation/components/booking_part/box_status.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/providers/booking_provider.dart';
import 'package:karaoke_reservation/providers/customer_page_provider.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';

class CustomerBookingScreen extends StatelessWidget {
  var dateTimeNow = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var branch = context.watch<CustomerProvider>().selectedBranch;
    return SafeArea(
      child: Scaffold(
        appBar: appBarCustom(true, context,function:((){
          context.read<BookingProvider>().setIsLoading();
          context.read<BookingProvider>().setSelectingRoom(null);
          })),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget("BOOKING"),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/branch.png',width: SizeConfig.screenWidth! *0.1,),
                    SizedBox(width: 20),
                    Text("สาขา : ${branch!.branchName}",style: TextStyle(color: darkToneColor,fontFamily: 'K2D',fontSize: 20),)
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
              BookingPartBody(branch.branchId!,true)
            ],
          ),
        ),
      )
    );
  }
}