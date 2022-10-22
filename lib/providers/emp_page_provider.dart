import 'package:flutter/material.dart';
import 'package:karaoke_reservation/models/booking_model.dart';
import 'package:karaoke_reservation/models/others/branch_key_name.dart';

class EmpProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  setIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }
  // password
  bool _isObsecure = true;
  bool get isObsecure => _isObsecure;
  setIsObsecure(){
    _isObsecure = !_isObsecure;
    notifyListeners();
  }
  //home
  List<BranchKeyName> _branchKey = [];
  List<BranchKeyName> get branchKey => _branchKey;
  setBranchKey(List<BranchKeyName> key){
    _branchKey = key;
    notifyListeners();
  }

  String _textQuery = '';
  String get textQuery => _textQuery;
  setTextQuery(String query){
    _textQuery = query;
    notifyListeners();
  }

  List<BookingModel> _bookings = [];
  List<BookingModel> get bookings => _bookings;
  setBookings(List<BookingModel> books){
    _bookings = books;
    notifyListeners();
  }

  //task
  String _tasksQuery = '';
  String get tasksQuery => _tasksQuery;
  setTasksQuery(String query){
    _tasksQuery = query;
    notifyListeners();
  }

  List<BookingModel> _bookingTasks = [];
  List<BookingModel> get bookingTasks => _bookingTasks;
  setBookingTask(List<BookingModel> books){
    _bookingTasks = books;
    notifyListeners();
  }

  List<BookingModel> _walkinTasks = [];
  List<BookingModel> get walkinTasks => _walkinTasks;
  setWalkinTask(List<BookingModel> walkin){
    _walkinTasks = walkin;
    notifyListeners();
  }
}