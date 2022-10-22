import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/coupon_card.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/coupon_model.dart';
import 'package:karaoke_reservation/models/user_coupon_model.dart';
import 'package:karaoke_reservation/providers/customer_page_provider.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/services/coupon_service.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';

class CouponContext extends StatefulWidget {

  @override
  State<CouponContext> createState() => _CouponContextState();
}

class _CouponContextState extends State<CouponContext> {
  List<UserCouponModel>? userCoupons;
  var user;
  var allCoupon;
  @override
  void initState() {
    getAllOfCoupons();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    allCoupon = context.watch<CustomerProvider>().allCoupons;
    userCoupons = context.watch<CustomerProvider>().userCoupons;
    user = context.watch<UserProvider>().activeUser.username;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: centerTitleWidget("COUPONS"),
      content: Container(
        width: SizeConfig.screenWidth! *0.9,
        height: SizeConfig.screenHeight! *0.5,
        child:(userCoupons!.isEmpty) 
        ? Center(child: Text("You don't have a coupon.",style: infoText,),)
        :ListView.builder(
          itemBuilder: (context, index) => CouponWhiteCard(Tools().getNotUseCoupon(userCoupons!)[index]),
          itemCount: Tools().getNotUseCoupon(userCoupons!).length,
        )
        ,
      ),
    );
  }

  void getAllOfCoupons()async{
      if(allCoupon == null || allCoupon.isEmpty || userCoupons == null){
      var coupon_service = CouponService();
      var result = await coupon_service.getAllcoupons();
      var result2 = await coupon_service.getUsercoupons(user);
      context.read<CustomerProvider>().setUserCp(result2);
      context.read<CustomerProvider>().setAllCoupons(result);
    } 
  }
}