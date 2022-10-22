
class BranchModel {
  String? branchId;
  String branchName;
  int amountRoomS,amountRoomM,amountRoomL;

  BranchModel({this.branchId,required this.branchName,
  required this.amountRoomS,required this.amountRoomM,required this.amountRoomL});

  factory BranchModel.fromJson(Map<String,dynamic> data){
    return BranchModel(
      branchId: data['branchId'],
      branchName: data['branchName'],
      amountRoomS: data['amountRoomS'],
      amountRoomM: data['amountRoomM'],
      amountRoomL: data['amountRoomL']
    );
  }
   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branchName'] = this.branchName;
    data['amountRoomS'] = this.amountRoomS;
    data['amountRoomM'] = this.amountRoomM;
    data['amountRoomL'] = this.amountRoomL;
    return data;
  }
}