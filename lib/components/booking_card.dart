import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/models/booking_model.dart';
import 'package:karaoke_reservation/providers/customer_page_provider.dart';
import 'package:karaoke_reservation/services/booking_service.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class BookingCustomerCard extends StatelessWidget {
  BookingCustomerCard({required this.type,required this.booking});
  String type;
  BookingModel booking;
  var keyName;
  var branchName;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    if(context.watch<CustomerProvider>().selectedBranch == null){
      keyName = context.watch<CustomerProvider>().branchKey;
    }
    else{
      branchName = context.watch<CustomerProvider>().selectedBranch!.branchName;
    }
    
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: SizeConfig.screenWidth! * 0.85,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/user_card.png"),fit:BoxFit.cover ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: secondaryColor)
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            (type == "Booked")
            ? _buildCancelBtn(context)
            : SizedBox(),
            Positioned(
              top: 10,
              left: 10,
              child: _headBookingID()
            ),
            _branchName((branchName == null) ?"${findBranchName(booking.branchId)}" :branchName),
            Positioned(
              top: 85,
              child: _bookingDetails())
          ],
        ),
      ),
    );
  }
  String findBranchName(String branchId){
  var result = keyName.indexWhere((element) => element.branchId == branchId);
  if(result != -1) return keyName[result].branchName;
  return "";
  }
  Widget _buildCancelBtn(BuildContext context){
    return Positioned(
      top: 10,
      right: 2,
      child: InkWell(
        onTap: (){
          _alertCheck(context,booking,"customer");
        },
        child: Card(
        color: greyBg,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 90,
          height: 25,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.close_rounded,color: Colors.red,),
              Text(
                'Cancel',
                style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: secondaryColor,fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
  Widget _branchName(String branchName){
    return Positioned(
      left: 12,
      top: 50,
      child: Text("$branchName",style: TextStyle(fontFamily: 'MavenPro',color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)));
  }
  Widget _headBookingID(){
    return Card(
    color: greyBg,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Container(
      width: 210,
      height: 25,
      child: Padding(
        padding: const EdgeInsets.only(left: 8,top: 2,bottom: 2,right: 8),
        child: Text(
          'Booking ID : ${booking.bookingID} ',
          style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: secondaryColor,fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
  }
  Widget _bookingDetails(){
    return Row(
      children: [
        Container(
          width: SizeConfig.screenWidth! *0.15,
          height: SizeConfig.screenWidth! *0.15,
          decoration: BoxDecoration(
            border: Border.all(color: secondaryColor),
            borderRadius: BorderRadius.circular(10),
            color: greyBg
          ),
          child: Center(
            child: Text(
              "${Tools().roomId(booking.roomId)}",
              style: TextStyle(fontFamily: 'MavenPro',fontSize: SizeConfig.screenWidth! * 0.1,color: secondaryColor),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 230,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: secondaryColor),
            borderRadius: BorderRadius.circular(10),
            color: greyBg
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Date : ${Tools().dateText(booking.startDateTime)}",style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: secondaryColor),),
                Text("Time : ${Tools().gapTime(booking.startDateTime, booking.endDateTime)}",style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: secondaryColor),),
                Text("Status : $type",style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: secondaryColor),),
                (type == "Booked")
                ? Text("Remaining price : ${booking.price} ฿",style: TextStyle(fontFamily: 'MavenPro',fontSize: 14,color: secondaryColor),)
                : SizedBox()
              ],
            ),
          ),
        )
      ],
    );
  }
}
void _alertCheck(BuildContext context,BookingModel booking,String type){
  ToastContext().init(context);
  showDialog(
    context: context, 
    builder: (context){
      return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Text("ยกเลิกการจอง",style: titleAlert_thai),
          content: Text(
            (type == "customer")?
            "แน่ใจที่จะยกเลิกการจองใช่หรือไม่? \n เมื่อยกเลิกแล้วไม่สามารถขอเงินมัดจำคืนได้"
            :"ต้องการยกเลิกการใช้บริการของ Booking ID : ${booking.bookingID} ใช่หรือไม่",
            style: detailsAlert_thai
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actions: [
            TextButton(
              onPressed: ()async{
                var booking_service = BookingService();
                var response = await booking_service.cancelBooking(booking.bookingID);
                List<BookingModel> nowBookingList = Provider.of<CustomerProvider>(context,listen: false).bookedList;
                nowBookingList.removeWhere((book) => book.bookingID == booking.bookingID);
                context.read<CustomerProvider>().setBookedList(nowBookingList);
                Toast.show(response,duration: Toast.lengthLong,gravity: Toast.center);
                Navigator.pop(context);
              }, 
              child: Text("ยกเลิก",style: btnAlert_thai)
            ),
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text("ไม่ยกเลิก",style: btnAlert_thai)
            )
          ],
        );
    }
  );
}
class TasksEmpCard extends StatelessWidget {
  TasksEmpCard({required this.type,required this.booking});
  String type;
  BookingModel booking;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: SizeConfig.screenWidth! * 0.85,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/user_card.png"),fit:BoxFit.cover ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: secondaryColor)
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            (type == "walkin")
            ? _buildCancelBtn(context)
            : SizedBox(),
            Positioned(
              top: 10,
              left: 10,
              child: _headBookingID()
            ),
            Positioned(
              top: 60,
              child: _bookingDetails())
          ],
        ),
      ),
    );
  }
  Widget _buildCancelBtn(BuildContext context){
    return Positioned(
      top: 10,
      right: 2,
      child: InkWell(
        onTap: () => _alertCheck(context, booking, "emp"),
        child: Card(
        color: greyBg,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 90,
          height: 25,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.close_rounded,color: Colors.red,),
              Text(
                'Cancel',
                style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: secondaryColor,fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
  Widget _headBookingID(){
    return Card(
    color: greyBg,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Container(
      width: 210,
      height: 25,
      child: Padding(
        padding: const EdgeInsets.only(left: 8,top: 2,bottom: 2,right: 8),
        child: Text(
          'Booking ID : ${booking.bookingID}',
          style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: secondaryColor,fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
  }
  Widget _bookingDetails(){
    return Row(
      children: [
        Container(
          width: SizeConfig.screenWidth! *0.15,
          height: SizeConfig.screenWidth! *0.15,
          decoration: BoxDecoration(
            border: Border.all(color: secondaryColor),
            borderRadius: BorderRadius.circular(10),
            color: greyBg
          ),
          child: Center(
            child: Text(
              "${Tools().roomId(booking.roomId)}",
              style: TextStyle(fontFamily: 'MavenPro',fontSize: SizeConfig.screenWidth! * 0.1,color: secondaryColor),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 230,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: secondaryColor),
            borderRadius: BorderRadius.circular(10),
            color: greyBg
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${booking.customerName}",style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: secondaryColor),),
                Text("Date : ${Tools().dateText(booking.startDateTime)}",style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: secondaryColor),),
                Text("Time : ${Tools().gapTime(booking.startDateTime, booking.endDateTime)}",style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: secondaryColor),),
                Text("Balance : ${booking.price}",style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: secondaryColor),),
                Text("Responsible by: ${booking.responseEmp}",style: TextStyle(fontFamily: 'MavenPro',fontSize: 14,color: secondaryColor),)
              ],
            ),
          ),
        )
      ],
    );
  }
}