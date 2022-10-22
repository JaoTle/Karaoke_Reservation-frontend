import 'dart:convert';

import 'package:karaoke_reservation/constants.dart';
import 'package:dio/dio.dart';
import 'package:karaoke_reservation/models/user_model.dart';

class AccountService {
  var _dio = Dio();


  var _accountBaseUrl = baseURL + 'user/';
  signIn(String type,String username,String password)async{
    var url = _accountBaseUrl+"signin?type=$type";
    Map<String,dynamic> data = {
    "username" : username.trim(),
    "password" : password.trim()
    };
    var response = await _dio.post(
      url,
      data: data,
      options: Options(
        headers: headers
      )
    );
    if(response.statusCode == 200){
      UserModel user = UserModel.fromJson(response.data);
      return user;
    }
    else {
      return "Failed";
    }
  }

  Future<String> signUp(String role,String name,String email,String username,String password,String branchId)async{
    var url = _accountBaseUrl + "signup/$role";
    Map<String,dynamic> user = {
      "username" :username,
      "password" :password,
      "email":email,
      "name" :name,
      "stationedBranchId" :branchId
    };
    var response = await _dio.post(
      url,
      data: user,
      options: Options(
        headers: headers
      )
    );
    if(response.statusCode == 200 || response.statusCode == 204){
      String result = response.data;
      if(response.statusCode == 204) result = "Duplicated Account";
      return result;
    }
    else return "Something Wrong.";
  }

  Future<List<UserModel>> getEmployees(String query)async{
    var url = _accountBaseUrl + "employees?query=$query";

    var response = await _dio.get(
      url,
      options: Options(
        headers: headers
      )
    );
    if(response.statusCode == 200) return (response.data as List).map((data) => UserModel.fromJson(data)).toList();
    else throw Exception('Failed');
  }

  //delete emp
  Future<String> deleteEmp(String username)async{
    var url = _accountBaseUrl + "delete?username=$username";

    var response = await _dio.delete(
      url,
      options: Options(
        headers: headers
      )
    );
    if(response.statusCode == 200){
      return "Delete Succes";
    }
    else if(response.statusCode == 204){
      return "Failed to Delete";
    }
    else return "Something Wrong";
  }

  Future<String> changePassword(String username,String oldPass,String newPass)async{
    var url = _accountBaseUrl +"changePwd";
    print(oldPass);
    Map<String,dynamic> body = {
      "username":username,
      "oldPassword" : oldPass,
      "newPassword":newPass
    };
    var response = await _dio.put(
      url,
      data:body,
      options: Options(
        headers: headers
      )
    );
    if(response.statusCode == 200) return response.data;
    else return "Error";
  }
}