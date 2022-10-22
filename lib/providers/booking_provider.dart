import 'package:flutter/material.dart';
import 'package:karaoke_reservation/models/booking_model.dart';
import 'package:karaoke_reservation/models/room_model.dart';

class BookingProvider extends ChangeNotifier {
  //roomSelecting
  RoomModel? _selectingRoom;
  RoomModel? get selectingRoom =>_selectingRoom;
  setSelectingRoom(RoomModel? selecting){
    _selectingRoom = selecting;
    notifyListeners();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  setIsLoading(){
    _isLoading = !_isLoading;
    notifyListeners();
  }



  List<BookingModel>? _queueRoom;
  List<BookingModel>? get queueRoom => _queueRoom;
  setQueueRoom(List<BookingModel>? queue){
    _queueRoom = queue;
    notifyListeners();
  }

  String _accessToken = '';
  String get accessToken => _accessToken;
  setAccessToken(String token){
    _accessToken = token;
    notifyListeners();
  }

  String _qrText = '';
  String get qrText => _qrText;
  setQrText(String qr){
    _qrText = qr;
    notifyListeners();
  }


}