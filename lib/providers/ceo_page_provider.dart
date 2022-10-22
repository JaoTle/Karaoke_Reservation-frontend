import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:karaoke_reservation/models/branch_model.dart';
import 'package:karaoke_reservation/models/branch_model.dart';
import 'package:karaoke_reservation/models/coupon_model.dart';
import 'package:karaoke_reservation/models/others/branch_key_name.dart';
import 'package:karaoke_reservation/models/price_details_model.dart';
import 'package:karaoke_reservation/models/user_model.dart';

class CEOProviders extends ChangeNotifier {
  //navBar
  var _selectIndex = 0;
  int get selectIndex => _selectIndex;
  setSelectIndex(int index){
    _selectIndex = index;
    notifyListeners();
  }
  //search & show branch
  var _branchTextQuery = '';
  String get branchTextQuery => _branchTextQuery;
  setBranchTextQuery(String query){
    _branchTextQuery = query;
    notifyListeners();
  }

  var _branches;
  List<BranchModel> get branches {
    if(_branches == null) return [];
    return _branches;
  } 
  setBranches(List<BranchModel> branchList){
    _branches = branchList;
    notifyListeners();
  }

  //branchDetails
  var _roomS,_roomM,_roomL;
  var emptyData = PriceDetailsModel(size: '', oneHour: 0, twoHours: 0, threeHours: 0);
  PriceDetailsModel get priceRoomS{
    if(_roomS == null) return emptyData;
    return _roomS;
  } 
  PriceDetailsModel get priceRoomM{
    if(_roomM == null) return emptyData;
    return _roomM;
  }
  PriceDetailsModel get priceRoomL{
    if(_roomL == null) return emptyData;
    return _roomL;
  }
  setRoomDetails(PriceDetailsModel s,PriceDetailsModel m,PriceDetailsModel l){
    _roomS = s;
    _roomM = m;
    _roomL = l;
    notifyListeners();
  }

  //show employees

   var _employeesTextQuery = '';
  String get employessTextQuery => _employeesTextQuery;
  setEmpTextQuery(String query){
    _employeesTextQuery = query;
    notifyListeners();
  }

  var _employees;
  List<UserModel> get employees{
    if(_employees == null) return [];
    return _employees;
  }
  setEmployees(List<UserModel> emps){
    _employees = emps;
    notifyListeners();
  }

  var _keyName;
  List<BranchKeyName> get keyBranch{
    if(_keyName == null) return [];
    return _keyName;
  }

  setBranchKey(List<BranchKeyName> branchKeys){
    _keyName = branchKeys;
    notifyListeners();
  }


  //manage password field
  bool _isObsecure = true;
  bool get isObsecure => _isObsecure;
  setObsecure(bool isOb){
    _isObsecure = isOb;
    notifyListeners();
  }
  //dropdown
  BranchModel _selectBranch = BranchModel(branchName: "สาขา", amountRoomS: 0, amountRoomM: 0, amountRoomL: 0);
  BranchModel get selectBranch => _selectBranch;
  setSelectedBranch(BranchModel selectBranch){
    _selectBranch = selectBranch;
    notifyListeners();
  }
  //init Emp
  String _initEmp = "";
  String get initEmp => _initEmp;
  setInitEmp(String gen){
    _initEmp = gen;
    notifyListeners();
  }

  int _choiceIndex = 2;
  int get choiceIndex => _choiceIndex;
  setChoiceIndex(int index){
    _choiceIndex = index;
    notifyListeners();
  }

  TextEditingController _ctrl = TextEditingController();
  TextEditingController get ctrl => _ctrl;
  setCtrl(TextEditingController controller){
    _ctrl = controller;
    notifyListeners();
  }

  List<CouponModel> _coupons = [];
  List<CouponModel> get coupons => _coupons;
  setCoupons(List<CouponModel> coupons){
    _coupons = coupons;
    notifyListeners();
  }
  addCoupon(CouponModel coupon){
    _coupons.add(coupon);
    notifyListeners();
  }
}