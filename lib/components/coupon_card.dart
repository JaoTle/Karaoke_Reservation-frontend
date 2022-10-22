import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/models/coupon_model.dart';
import 'package:karaoke_reservation/models/user_coupon_model.dart';
import 'package:karaoke_reservation/providers/customer_page_provider.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:provider/provider.dart';

class CouponWhiteCard extends StatelessWidget {
  CouponWhiteCard(this.userCoupon);
  UserCouponModel userCoupon;
  List<CouponModel>? allCoupon;
  @override
  Widget build(BuildContext context) {
    allCoupon = context.watch<CustomerProvider>().allCoupons;
    var details = Tools().getCouponDetails(userCoupon, allCoupon!);
    return Card(
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: secondaryColor),
          borderRadius: BorderRadius.circular(10)
        ),
        height:90,
        width: SizeConfig.screenWidth! * 0.8,
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${details.couponName}",style: TextStyle(fontFamily: 'K2D',fontWeight: FontWeight.w700,color: darkToneColor),),
                  Text("${details.details}",maxLines: 2,style: TextStyle(fontFamily: 'K2D',color: darkToneColor),),
                  Text("Expire : ${Tools().dateText(details.couponExpire)}",style: TextStyle(fontFamily: 'K2D',color: secondaryColor),)
                ],
              ),
            ),
            SizedBox(
              height: 30,
              width: 60,
              child: normalBtn((){
                context.read<CustomerProvider>().setSelectUseCoupon(userCoupon);
                Navigator.pop(context);
              }, "ใช้", true)
            )
          ],
        )
      ),
    );
  }
}