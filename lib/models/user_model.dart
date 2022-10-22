import 'package:intl/intl.dart';

class UserModel {
  String username,password;
  String name,role;
  String? email;
  List<dynamic>? topBranches;
  int? totalHours;
  DateTime? recentLogin;
  String? stationedBranchId;

  UserModel({required this.username,required this.password,required this.name,required this.email,required this.role,this.topBranches,this.totalHours,this.recentLogin,required this.stationedBranchId});
  
  factory UserModel.fromJson(Map<String,dynamic> data){
    var time = null;
    if(data['recentLogin'] != null) new DateFormat('dd-MM-yyyy HH:mm:ss').parse(data['recentLogin']);
    return UserModel(
      username: data['username'],
      password: data['password'],
      name: data['name'],
      email: data['email'],
      role: data['role'],
      topBranches: data['topBranches'],
      totalHours: data['totalHours'],
      recentLogin: time,
      stationedBranchId: data['stationedBranchId']
    );
  }
}