import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/appBar.dart';
import 'package:karaoke_reservation/components/booking_card.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/booking_model.dart';
import 'package:karaoke_reservation/providers/booking_provider.dart';
import 'package:karaoke_reservation/providers/customer_page_provider.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:provider/provider.dart';

class SuccessPaymentScreen extends StatelessWidget {
  BookingModel? booking;
  @override
  Widget build(BuildContext context) {
    booking = ModalRoute.of(context)!.settings.arguments as BookingModel;
    return SafeArea(
      child: Scaffold(
        appBar: appBarCustom(false, context),
        body: Center(
          child: Column(
            children: [
              titleWidget("BOOKING"),
              Padding(
                padding: EdgeInsets.all(20),
                child: Icon(Icons.check_circle_outline_rounded,size: 100,color: Colors.tealAccent.shade400),
              ),
              BookingCustomerCard(type: "Booked", booking: booking!),
              Padding(
                padding: EdgeInsets.all(40),
                child: _buildTextBox(),
              ),
              normalBtn((){
                context.read<CustomerProvider>().setIndex(0);
                context.read<BookingProvider>().setIsLoading();
                context.read<BookingProvider>().setSelectingRoom(null);
                context.read<BookingProvider>().setQueueRoom(null);
                Navigator.popUntil(context,ModalRoute.withName("/customer"));
              }, "Complete", true)
            ],
          ),
        ),
      )
    );
  }
  Widget _buildTextBox(){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: secondaryColor,
          width: 1
        ),
      ),
      elevation: 5,
      child: Container(
        width: SizeConfig.screenWidth! * 0.7,
        height: 50,
        child: Center(
          child: Text("Payment & Booking Success!\nThank you & Enjoy your time.",
          textAlign: TextAlign.center,
          style: TextStyle(color: darkToneColor,fontFamily: 'MavenPro',fontWeight: FontWeight.w500,fontSize: 16)
          )
        ),
      ),
    );
  }
}