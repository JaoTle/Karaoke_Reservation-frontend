import 'dart:math' as math;
import 'package:karaoke_reservation/models/coupon_model.dart';
import 'package:karaoke_reservation/models/user_coupon_model.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:intl/intl.dart';
class Tools {
  String generateEmpUser(String branchId){
    var rnd = new math.Random();
    var next = rnd.nextDouble() * 10000;
    while (next < 1000) {
      next *= 10;
    }
    return "Emp" + next.toInt().toString()+ "@" +branchId;
  }

  String roomId(String roomId){
    var id = roomId.split('-');
    if(id[1][1] == '0') return id[1][0] + id[1][2];
    return id[1];
  }

  String gapTime(DateTime start,DateTime end){
    String startTime = DateFormat('HH:mm').format(start);
    String endTime = DateFormat('HH:mm').format(end);
    return startTime + " - " +endTime;
  }
  String dateText(DateTime date){
    return DateFormat('d MMM yyy').format(date);
  }

  List<DateTime> listOfTime(){
    var defualt_time = DateTime.now();
    defualt_time = defualt_time.toLocal();
    var close_time = new DateTime(defualt_time.year,defualt_time.month,defualt_time.day,22,00);
    var open_time = new DateTime(defualt_time.year,defualt_time.month,defualt_time.day,11,00);
    var now = DateTime.now();
    var time = (now.compareTo(open_time) == 1) ?open_time:now;
    var diff_time = close_time.difference(time).inHours;
    var listTime = List<DateTime>.generate( (time.minute != 0)?diff_time+1:diff_time, (index) => 
      DateTime.utc(
        now.year,
        now.month,
        now.day,
        (now.minute != 0) ? now.hour +1 : now.hour,
        0
      ).add(Duration(hours: index))
    );
    return listTime;
  }
  String timeFormat(DateTime t){
    return DateFormat('HH:mm').format(t);
  }

  int calFee(double price){
    return (price * 0.3).toInt();
  }

  bool checkCollectedCoupon(List<UserCouponModel> userCp,CouponModel coupon){
    for(UserCouponModel cp in userCp){
      if(cp.couponId == coupon.couponId) return true;
    }
    return false;
  }

  List<UserCouponModel> sortCouponList(List<UserCouponModel> userCoupons){
    List<UserCouponModel> notUsed =[];
    List<UserCouponModel> used =[];
    for(UserCouponModel coupon in userCoupons){
      if(coupon.couponStatus == "Used") used.add(coupon);
      else notUsed.add(coupon);
    }
    List<UserCouponModel> sortCoupon = notUsed+used;
    return sortCoupon;
  }

  CouponModel getCouponDetails(UserCouponModel userCoupon,List<CouponModel> coupons){
    var couponId = userCoupon.couponId;
    var couponIndex = coupons.indexWhere((element) => element.couponId == couponId);
    return coupons[couponIndex];
  }

  List<UserCouponModel> getNotUseCoupon(List<UserCouponModel> userCoupons){
    return userCoupons.where((element) => element.couponStatus != "Used").toList();
  }
}


class GenId{
  var _st1 = Uuid().v4().toString().replaceAll("-", "");
  var _st2 = Uuid().v4().toString().replaceAll("-", "");
  var _st3 = Uuid().v4().toString().replaceAll("-", "");
  var _st4 = Uuid().v4().toString().replaceAll("-", "");

  String genId(int digit){
    String data = "";
    data = data + _st1 + _st2 + _st3 + _st4;
    int beginIndex = math.Random().nextInt(100);
    int endIndex = beginIndex + digit;
    return data.substring(beginIndex,endIndex).toUpperCase();
  }
  //ref payment
  String genRef(){
    String ref = "REF" + genId(10);
    return ref;
  }

  String genUid(){
    return Uuid().v4().toString();
  }
}