import 'package:dio/dio.dart';
import 'package:karaoke_reservation/constants.dart';
import 'package:karaoke_reservation/models/coupon_model.dart';
import 'package:karaoke_reservation/models/user_coupon_model.dart';

class CouponService {
  var _dio = Dio();
  var _couponBaseUrl = baseURL + 'coupons';

  Future<List<CouponModel>> getAllcoupons()async{
    var response = await _dio.get(_couponBaseUrl,
      options: Options(headers: headers)
    );
    if(response.statusCode == 200){
      return (response.data as List).map((data) => CouponModel.fromJson(data)).toList();
    }
    else return [];
  }

  addCoupon(CouponModel coupon)async{
    var response = await _dio.post(_couponBaseUrl,options: Options(headers: headers),data: coupon);
    if(response.statusCode != 200) return "Something Wrong";
    return response.data;
  }

  clearExpireCoupon()async{
    var url = _couponBaseUrl + "/expire";
    await _dio.delete(url,options: Options(headers: headers));
  }

  Future<CouponModel> getCoupon(String id)async{
    var url = baseURL + "coupon?couponId=$id";
    var response = await _dio.get(url,options: Options(headers: headers));
    if(response.statusCode == 200) return CouponModel.fromJson(response.data);
    else throw Exception("Failed");
  }



  var _baseUserCoupon = baseURL + "user/coupons";
  Future<List<UserCouponModel>> getUsercoupons(String user)async{
  var url = _baseUserCoupon + "?username=$user";
  var response = await _dio.get(url,
    options: Options(headers: headers)
  );
  if(response.statusCode == 200){
    return (response.data as List).map((data) => UserCouponModel.fromJson(data)).toList();
  }
  else return [];
  }
  
  collectCoupon(UserCouponModel couPonCollect)async{
    var response = await _dio.post(_baseUserCoupon,
    options: Options(headers: headers),
    data: couPonCollect.toJson());
    if(response.statusCode == 200) return response.data;
    return "Something Wrong";
  }

  updateUseCoupon(String couponId,String username)async{
    var url = _baseUserCoupon + '?couponId=$couponId&username=$username';
    var response = await _dio.put(url,options: Options(headers: headers));
  }
}