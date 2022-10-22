import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/models/coupon_model.dart';
import 'package:karaoke_reservation/models/user_coupon_model.dart';
import 'package:karaoke_reservation/providers/customer_page_provider.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/services/coupon_service.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
class CouponWidget extends StatelessWidget {
  CouponWidget({required this.coupon,required this.typeOfShow,this.used});
  CouponModel coupon;
  int typeOfShow;
  bool? used;
  TextStyle couponTitle = TextStyle(fontFamily: 'K2D',fontSize: 21,fontWeight: FontWeight.bold,color: darkToneColor,overflow: TextOverflow.ellipsis);
  TextStyle expText = TextStyle(fontFamily: 'MavenPro',fontSize: 15,color: brightToneColor,fontWeight: FontWeight.w500);
  TextStyle detailsText = TextStyle(fontFamily: 'K2D',fontSize: 16,color: darkToneColor);
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    var userCp = context.watch<CustomerProvider>().userCoupons;
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,bottom: 20),
      child: CouponCard(
        width: SizeConfig.screenWidth! * 0.9,
        curveAxis: Axis.vertical,
        curvePosition: SizeConfig.screenWidth! * 0.55,
        firstChild: Container(
          color: brightToneColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("${coupon.couponName}",style: couponTitle,maxLines: 2,textAlign: TextAlign.center),
                Text("${coupon.details}",style: detailsText,maxLines: 3,textAlign: TextAlign.center),
              ],
            ),
          ),
        ), 
        secondChild: Container(
          color: darkToneColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("EXPIRE DATE : ",style: expText),
                SizedBox(height: 10),
                Text("${Tools().dateText(coupon.couponExpire)}",style: expText),
                SizedBox(height: 10),
                Text("KARAOKE \n COUPON",style: TextStyle(
                  fontFamily: 'Josefin',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: brightToneColor
                )),
                SizedBox(height: 5),
                (typeOfShow == 1)
                ?SizedBox(
                  height: 30,
                  child: (Tools().checkCollectedCoupon(userCp, coupon))
                  ? normalBtn(null, "In Bag", true)
                  :normalBtn(()async{
                    var coupon_service = CouponService();
                    var user = Provider.of<UserProvider>(context,listen: false).activeUser.username;
                    var couponCollect = UserCouponModel(couponId: coupon.couponId, username: user);
                    var result = await coupon_service.collectCoupon(couponCollect);
                    Toast.show("$result",duration: Toast.lengthLong,gravity: Toast.center);
                    if(result == "Collect Success"){
                      userCp.add(couponCollect);
                      context.read<CustomerProvider>().setUserCp(userCp);
                    } 

                  }, "Collect",true))
                :(typeOfShow == 0)?SizedBox()
                  :(used!)? _buildBoxStatus("Used"):_buildBoxStatus("Not Use")
              ],
            ),
          ),
        )
      ),
    );
  }
  Widget _buildBoxStatus(String text){
    return Container(
      height: 30,
      width: 80,
      decoration: BoxDecoration(
        color:Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Center(child: Text(text,style: TextStyle(fontFamily: 'MavenPro',fontSize: 18,fontWeight: FontWeight.bold,color: darkToneColor),)),
      ),
    );
  }
}