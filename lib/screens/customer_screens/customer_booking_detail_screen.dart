import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/appBar.dart';
import 'package:karaoke_reservation/components/booking_card.dart';
import 'package:karaoke_reservation/components/booking_part/coupon_dialog.dart';
import 'package:karaoke_reservation/components/countdown.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/booking_model.dart';
import 'package:karaoke_reservation/models/coupon_model.dart';
import 'package:karaoke_reservation/providers/booking_provider.dart';
import 'package:karaoke_reservation/providers/customer_page_provider.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/services/booking_service.dart';
import 'package:karaoke_reservation/services/coupon_service.dart';
import 'package:karaoke_reservation/services/payment_service.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class BookingDetailScreen extends StatefulWidget {
  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  BookingModel? booking;

  String qrImage = '';

  CouponModel? _selectedCoupon;

  var priceDiscount;

  int? _timeCountDown;
  @override
  Widget build(BuildContext context) {
    _selectedCoupon = context.watch<CustomerProvider>().selectCouponDetail;
    ToastContext().init(context);
    booking = ModalRoute.of(context)!.settings.arguments as BookingModel;
    //qrImage = context.watch<BookingProvider>().qrText;
    priceDiscount = (_selectedCoupon!=null)?
    (booking!.price.toInt() - _selectedCoupon!.discount.toInt())
    :booking!.price.toInt();
    return SafeArea(
      child: Scaffold(
        appBar: appBarCustom(true, context,function:((){
          context.read<BookingProvider>().setSelectingRoom(null);
          context.read<BookingProvider>().setQueueRoom(null);
          context.read<CustomerProvider>().setSelectUseCoupon(null);
          })),  
        body: SingleChildScrollView(
          child: Column(
            children: [
              titleWidget("BOOKING"),
              BookingCustomerCard(type: "Pending payment", booking: booking!),
              _priceDetails(),
              _couponBox(context),
              SizedBox(height: 20),
              Container(
                width: SizeConfig.screenWidth! * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 120,
                      child: normalBtn(()async{
                        if(_selectedCoupon!=null){
                          if(!checkCondition(context)){
                            Toast.show("ไม่สามารถใช้คูปองได้\nเนื่องจากไม่ตรงตามเงื่อนไขของคูปอง",duration: Toast.lengthLong,gravity: Toast.center);
                            return null;
                          }
                        }
                        var payment_service = PaymentService();
                        var accessToken = await payment_service.oauth();
                        String ref = GenId().genRef();
                        String qr = await payment_service.getQrCodePayment(accessToken, 
                        Tools().calFee(priceDiscount.toDouble()).toDouble(),ref);
                        setState(() {
                          _timeCountDown = 30;
                          qrImage = qr;
                        });
                        Future.delayed(Duration(seconds:2));
                        Timer.periodic(Duration(seconds: 1), (timer)async{
                        if(timer.tick == 30){
                          Toast.show("You doesn't paid in time.",
                          duration: Toast.lengthLong,
                          gravity: Toast.center);
                          if(mounted){
                            context.read<BookingProvider>().setQrText('');
                            context.read<BookingProvider>().setIsLoading();
                            context.read<BookingProvider>().setSelectingRoom(null);
                            context.read<BookingProvider>().setQueueRoom(null);
                            context.read<CustomerProvider>().setSelectUseCoupon(null);
                          }
                          
                          Navigator.popUntil(context,ModalRoute.withName("/customer"));
                          timer.cancel();
                        }
                        String result = await payment_service.getResultPayment(ref);
                        if(result == "Success") {
                          timer.cancel();
                          var booking_service = BookingService();
                          booking!.setPrice((booking!.price.toInt() - Tools().calFee(priceDiscount.toDouble())).toDouble());
                          await booking_service.addBooking(booking!, "book");
                          var coupon_service = CouponService();
                          var user = Provider.of<UserProvider>(context,listen: false).activeUser.username;
                          if(_selectedCoupon != null) await coupon_service.updateUseCoupon(_selectedCoupon!.couponId, user);
                          context.read<CustomerProvider>().setSelectUseCoupon(null);
                          Navigator.pushReplacementNamed(context, '/cus_success_pay',arguments: booking);
                        }
                        });
                        
                      }, "Confirm", true),
                    ),
                    SizedBox(
                      width: 120,
                      child: normalBtn((){
                        context.read<BookingProvider>().setSelectingRoom(null);
                        context.read<BookingProvider>().setQueueRoom(null);
                        context.read<BookingProvider>().setQrText('');
                        context.read<CustomerProvider>().setSelectUseCoupon(null);
                        Navigator.pop(context);
                      }, "Cancel", false),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              (qrImage == '') ? SizedBox():Text("QR Code",style: infoText),
              SizedBox(height: 20),
              (qrImage == '') ? SizedBox()
              :Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: secondaryColor)
                ),
                width: 200,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Image.memory(base64.decode(qrImage)),
                ),
              ),
              (qrImage == '') ? SizedBox():CountDownTimer(_timeCountDown!)
            ],
          ),
        ),
      )
    );
  }

  bool checkCondition(BuildContext context){
    var totalHour = Provider.of<UserProvider>(context,listen: false).activeUser.totalHours;
    var singHour = booking!.endDateTime.difference(booking!.startDateTime).inHours;
    if(_selectedCoupon!.isTotalHours){
      if(totalHour! >= _selectedCoupon!.hours) return true;
      else return false;
    }
    else{
      if(singHour >= _selectedCoupon!.hours) return true;
      else return false;
    }
  }

  Widget _priceDetails(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        width: SizeConfig.screenWidth! *0.8,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ส่วนลด",style: priceDetailStyle),
                Text((_selectedCoupon == null) ?
                "-0 ฿"
                :"-${_selectedCoupon!.discount.toInt()} ฿"
                ,style: priceDetailStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ราคาทั้งหมด",style: priceDetailStyle),
                Text("$priceDiscount ฿" 
                ,style: priceDetailStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("มัดจำที่ต้องชำระ(30%)",style: priceDetailStyle),
                Text("${Tools().calFee(priceDiscount.toDouble())} ฿",style: priceDetailStyle),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _couponBox(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: SizeConfig.screenWidth! * 0.8,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: secondaryColor)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text((_selectedCoupon == null)
              ?"Coupon"
              :"${_selectedCoupon!.couponId}"
              ,style: priceDetailStyle),
              SizedBox(
                width: 100,
                child: (_selectedCoupon == null)
                ?normalBtn((){
                  _dialogCoupon(context);
                }, "คูปอง",true)
                :normalBtn((){
                  context.read<CustomerProvider>().setSelectUseCoupon(null);
                }, "ยกเลิก",true)
                )
                ,
            ],
          ),
        ),
      ),
    );
  }

  void _dialogCoupon(BuildContext context){
    showDialog(
      context: context, 
      builder: (context) => CouponContext()
    );
  }
}

