import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/ceo_body/add_coupon_form.dart';
import 'package:karaoke_reservation/components/couponWidget.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/coupon_model.dart';
import 'package:karaoke_reservation/providers/ceo_page_provider.dart';
import 'package:karaoke_reservation/services/coupon_service.dart';
import 'package:provider/provider.dart';

class AddPromotionBody extends StatefulWidget {
  @override
  State<AddPromotionBody> createState() => _AddPromotionBodyState();
}

class _AddPromotionBodyState extends State<AddPromotionBody> {
  List<CouponModel>? _coupons;
  @override
  void initState() {
    getCoupons();
    super.initState();
  }
 @override
  Widget build(BuildContext context) {
    _coupons = context.watch<CEOProviders>().coupons;
    return SingleChildScrollView(
      child: Column(
        children: [
          titleWidget("ADD PROMOTIONS"),
          SizedBox(height: 10),
          manageButton(() => _addCoupon(), "เพิ่มคูปอง", Icons.add),
          SizedBox(height: 10),
          (_coupons == null || _coupons!.isEmpty)? SizedBox()
          :Container(
            height: SizeConfig.screenHeight! *0.7,
            child: ListView.builder(
              itemBuilder: (context, index) => CouponWidget(coupon:_coupons![index],typeOfShow: 0,),
              itemCount: _coupons!.length,
            ),
          )
        ],
      ),
    );
  }

  _addCoupon(){
    showDialog(
      context: context, 
      builder: (context) => AddCouponForm()
    );
  }

  getCoupons()async{
    var coupon_services = CouponService();
    var result = await coupon_services.getAllcoupons();
    context.read<CEOProviders>().setCoupons(result);
  }
}