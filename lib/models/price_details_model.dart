
class PriceDetailsModel {
  String? branchId;
  String size;
  double oneHour,twoHours,threeHours;

  PriceDetailsModel({this.branchId,required this.size,
  required this.oneHour,required this.twoHours,required this.threeHours});

  factory PriceDetailsModel.fromJson(Map<String,dynamic> data){
    return PriceDetailsModel(
      branchId: data['branchId'],
      size: data['size'], 
      oneHour: data['oneHourPrice'], 
      twoHours: data['twoHoursPrice'], 
      threeHours: data['threeHoursPrice']
    );
  }
    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size'] = this.size;
    data['oneHourPrice'] = this.oneHour;
    data['twoHoursPrice'] = this.twoHours;
    data['threeHoursPrice'] = this.threeHours;
    return data;
  }
}