import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:karaoke_reservation/constants.dart';
import 'package:karaoke_reservation/models/branch_model.dart';
import 'package:karaoke_reservation/models/form/add_branch_form.dart';
import 'package:karaoke_reservation/models/others/branch_key_name.dart';
import 'package:karaoke_reservation/models/price_details_model.dart';
import 'package:karaoke_reservation/models/room_model.dart';

class BranchRoomService {
  var _dio = Dio();
  
  //branch
  var _branchBaseUrl = baseURL + 'branch';

  Future<List<BranchModel>> getBranches(String query)async{
    var url = _branchBaseUrl + "?query=$query";

    var response = await _dio.get(
      url,
      options: Options(
        headers: headers
      )
    );
    if(response.statusCode == 200){
      return (response.data as List).map((data) => BranchModel.fromJson(data)).toList();
    }
    else throw Exception('Failed');
  }

  Future<String> addBranch(AddBranchForm addBranchForm)async{
    var response = await _dio.post(
      _branchBaseUrl,
      options: Options(
        headers: headers
      ),
      data: addBranchForm.toJson()
    );
    if(response.statusCode == 200 || response.statusCode == 204){
      String result = response.data;
      return result;
    }
    else return "Something Wrong.";
  }

  Future<List<BranchKeyName>> getBranchKeyName()async{
    var url = _branchBaseUrl + "/key";
    var response = await _dio.get(url,
    options: Options(headers: headers));
    if(response.statusCode == 200){
      return (response.data as List).map((data) => BranchKeyName.fromJson(data)).toList();
    }
    else throw Exception('Failed');
  }

  //room

  //price
  Future<PriceDetailsModel> getPrice(String branchId,String size)async{
    var url = baseURL + 'priceDetail?branchId=$branchId&size=$size';

    var response = await _dio.get(
      url,
      options : Options(
        headers: headers
      )
    );
    if(response.statusCode == 200){
      return PriceDetailsModel.fromJson(response.data);
    }
    else throw Exception('Failed');
  }

  Future<List<RoomModel>> getRooms(String branchId)async{
    var url = baseURL + "rooms?branchId=$branchId";
    var response = await _dio.get(url,options: Options(headers: headers));
    if(response.statusCode == 200){
      return (response.data as List).map((data) => RoomModel.fromJson(data)).toList();
    }
    else throw Exception('Failed');
  }
}