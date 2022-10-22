class UserCouponModel {
  String couponId,username;
  String? couponStatus;
  UserCouponModel({required this.couponId,required this.username,this.couponStatus});
  factory UserCouponModel.fromJson(Map<String,dynamic> data){
    return UserCouponModel(
      couponId: data['couponId'],
      username: data['username'],
      couponStatus: data['couponStatus']
    );
  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couponId'] = this.couponId;
    data['username'] = this.username;
    return data;
  }
}