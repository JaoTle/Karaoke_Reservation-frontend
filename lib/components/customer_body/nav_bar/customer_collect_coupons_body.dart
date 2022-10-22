import 'package:flutter/material.dart';
import 'package:karaoke_reservation/components/couponWidget.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/coupon_model.dart';
import 'package:karaoke_reservation/models/user_coupon_model.dart';
import 'package:karaoke_reservation/providers/customer_page_provider.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/services/coupon_service.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';

class CustomerCollectBody extends StatefulWidget {
  const CustomerCollectBody({Key? key}) : super(key: key);

  @override
  State<CustomerCollectBody> createState() => _CustomerCollectBodyState();
}

class _CustomerCollectBodyState extends State<CustomerCollectBody> {
  List<CouponModel>? coupons;
  List<UserCouponModel>? userCp;
  bool? couponLoading;
  var user;

  @override
  void initState() {
    getCoupon();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    user = context.watch<UserProvider>().activeUser.username;
    coupons = context.watch<CustomerProvider>().allCoupons;
    userCp = context.watch<CustomerProvider>().userCoupons;
    couponLoading = context.watch<CustomerProvider>().couponLoading;
    return Column(
      children: [
        titleWidget("COUPONS"),
        SizedBox(height: 10),
        Expanded(
          child: (couponLoading!)
          ?Center(child: CircularProgressIndicator(color: secondaryColor))
          :(coupons!.isEmpty)
          ?Center(
            child: Text("Don't have coupon yet.",style: infoText),
          )
          :ListView.builder(
            itemBuilder: (context, index) => CouponWidget(coupon: coupons![index], typeOfShow: 1),
            itemCount: coupons!.length,
          )
        )
      ],
    );
  }

  getCoupon()async{
    var coupon_service = CouponService();
    var result = await coupon_service.getAllcoupons();
    var result2 = await coupon_service.getUsercoupons(user);
    if(mounted){
      context.read<CustomerProvider>().setUserCp(result2);
      context.read<CustomerProvider>().setAllCoupons(result);
      context.read<CustomerProvider>().setCouponLoading();
    }
  }
}