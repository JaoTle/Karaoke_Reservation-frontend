import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/appBar.dart';
import 'package:karaoke_reservation/components/couponWidget.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/coupon_model.dart';
import 'package:karaoke_reservation/models/user_coupon_model.dart';
import 'package:karaoke_reservation/providers/customer_page_provider.dart';
import 'package:karaoke_reservation/services/coupon_service.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';

class CustomerCouponsScreen extends StatefulWidget {
  const CustomerCouponsScreen({Key? key}) : super(key: key);

  @override
  State<CustomerCouponsScreen> createState() => _CustomerCouponsScreenState();
}

class _CustomerCouponsScreenState extends State<CustomerCouponsScreen> {
  var username;
  List<CouponModel>? coupons;
  List<UserCouponModel>? userCp;
  @override
  void initState() {
    getCoupon();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    coupons = context.watch<CustomerProvider>().allCoupons;
    userCp = context.watch<CustomerProvider>().userCoupons;
    username = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        appBar: appBarCustom(true, context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              titleWidget("MY COUPONS"),
              SizedBox(height: 10),
              Container(
                height: SizeConfig.screenHeight! * 0.7,
                child: (coupons!.isEmpty)
                ?Center(
                  child: Text("Don't have coupon yet.",style: infoText),
                )
                :ListView.builder(
                  itemBuilder: (context, index) => CouponWidget(coupon: Tools().getCouponDetails(userCp![index],coupons!),
                   typeOfShow: 2,
                   used:(userCp![index].couponStatus == "Used") ? true:false
                   ),
                  itemCount: userCp!.length,
                ),
              )
            ],
          ),
        ),
      )
    );
  }
  getCoupon()async{
    if(coupons == null || userCp == null){
      var coupon_service = CouponService();
      var result = await coupon_service.getAllcoupons();
      var result2 = await coupon_service.getUsercoupons(username);
      if(mounted){
        context.read<CustomerProvider>().setUserCp(result2);
        context.read<CustomerProvider>().setAllCoupons(result);
      }
    } 
  }

  
}