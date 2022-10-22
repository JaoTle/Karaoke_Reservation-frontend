import 'package:flutter/material.dart';
import 'package:karaoke_reservation/models/booking_model.dart';
import 'package:karaoke_reservation/models/branch_model.dart';
import 'package:karaoke_reservation/models/coupon_model.dart';
import 'package:karaoke_reservation/models/others/branch_key_name.dart';
import 'package:karaoke_reservation/models/user_coupon_model.dart';

class CustomerProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  setIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }
  //Booking
  var _branches;
  List<BranchModel> get branches {
    if(_branches == null) return [];
    return _branches;
  } 
  setBranches(List<BranchModel> branchList){
    _branches = branchList;
    notifyListeners();
  }

  var _branchTextQuery = '';
  String get branchTextQuery => _branchTextQuery;
  setBranchTextQuery(String query){
    _branchTextQuery = query;
    notifyListeners();
  }

  BranchModel? _selectedBranch;
  BranchModel? get selectedBranch => _selectedBranch;
  setSelectedBranch(BranchModel branch){
    _selectedBranch = branch;
    notifyListeners();
  }

  //Coupon-Collect
  bool _couponLoading = true;
  bool get couponLoading => _couponLoading;
  setCouponLoading(){
    _couponLoading = !_couponLoading;
    notifyListeners();
  }
  List<CouponModel> _allCoupons = [];
  List<CouponModel> get allCoupons => _allCoupons;
  setAllCoupons(List<CouponModel> coupons){
    _allCoupons = coupons;
  notifyListeners();
  }
  
List<UserCouponModel> _userCoupons = [];
List<UserCouponModel> get userCoupons => _userCoupons;
setUserCp(List<UserCouponModel> userCp){
  _userCoupons = userCp;
  notifyListeners();
}



  //Menu-History
  List<BookingModel> _historyBookingList =[];
  List<BookingModel> get historyBookingList => _historyBookingList;
  setHistoryList(List<BookingModel> historyList){
    _historyBookingList = historyList;
    notifyListeners();
  }
  List<BranchKeyName> _branchKey = [];
  List<BranchKeyName> get branchKey => _branchKey;
  setBranchKey(List<BranchKeyName> key){
    _branchKey = key;
    notifyListeners();
  }

  //Menu-Booked
  List<BookingModel> _bookedList = [];
  List<BookingModel> get bookedList => _bookedList;
  setBookedList(List<BookingModel> booked){
    _bookedList = booked;
    notifyListeners();
  }

  List<BookingModel> _activeList = [];
  List<BookingModel> get activeList => _activeList;
  setActiveList(List<BookingModel> active){
    _activeList = active;
    notifyListeners();
  }

  //useCoupon
  UserCouponModel? _selectUseCoupon;
  UserCouponModel? get selectUseCoupon => _selectUseCoupon;
  CouponModel? _selectCouponDetail;
  CouponModel? get selectCouponDetail => _selectCouponDetail;

  setSelectUseCoupon(UserCouponModel? selectedCoupon){
    if(selectedCoupon == null) _selectCouponDetail = null;
    else{
      var index = _allCoupons.indexWhere((element) => element.couponId == selectedCoupon.couponId);
      _selectCouponDetail = _allCoupons[index];
    }
    _selectUseCoupon = selectedCoupon;
  
    notifyListeners();
  }
}