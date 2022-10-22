import 'package:intl/intl.dart';

class CouponModel {
  String couponId,couponName,details;
  int hours;
  bool isTotalHours;
  double discount;
  DateTime couponExpire;
  CouponModel({required this.couponId,required this.couponName,required this.details,required this.hours,required this.discount,required this.isTotalHours,required this.couponExpire});
  factory CouponModel.fromJson(Map<String,dynamic> data){
    return CouponModel(
      couponId: data['couponId'], 
      couponName: data['couponName'],
       details: data['detail'], 
       hours: data['hours'], 
       discount: data['discount'], 
       isTotalHours: data['totalHours'],
       couponExpire: new DateFormat('dd-MM-yyyy HH:mm:ss').parse(data['couponExpire'])
      );
  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['couponId'] = this.couponId;
      data['couponName'] = this.couponName;
      data['detail'] = this.details;
      data['hours'] = this.hours;
      data['discount'] = this.discount;
      data['totalHours'] = this.isTotalHours;
      data['couponExpire'] = DateFormat("dd-MM-yyyy HH:mm:ss").format(this.couponExpire);
      return  data;
  }
}