import 'package:dio/dio.dart';
import 'package:karaoke_reservation/constants.dart';
import 'package:karaoke_reservation/models/booking_model.dart';
import 'package:karaoke_reservation/models/price_details_model.dart';

class BookingService {
  var _dio = Dio();

  var _bookingBaseUrl = baseURL + 'booking/';

  Future<List<BookingModel>> getBookingHistory(String username)async{
    var url = _bookingBaseUrl + 'user/history?username=$username';
    var response = await _dio.get(url,options: Options(headers: headers));
    if(response.statusCode == 200){
      return (response.data as List).map((data) => BookingModel.fromJson(data)).toList();
    }
    else throw Exception('Failed');
  }
  
  Future<List<BookingModel>> getBookingForUser(String username,bool isBooking)async{
    var url = _bookingBaseUrl + 'user?name=$username&isBooking=$isBooking';
    var response = await _dio.get(url,options: Options(headers: headers));
    if(response.statusCode == 200){
      return (response.data as List).map((data) => BookingModel.fromJson(data)).toList();
    }
    else throw Exception('Failed');
  }

  cancelBooking(String bookingID)async{
    var url = _bookingBaseUrl + 'cancel?bookingID=$bookingID';
    var response = await _dio.delete(url,options: Options(headers: headers));
    if(response.statusCode == 200 || response.statusCode == 204){
      if(response.statusCode == 200) return "Cancel Success";
      return response.data;
    }
    else return "Somthing Wrong";
  }

  Future<List<BookingModel>> getBookingForEmp(String branchId,String query)async{
    var url = _bookingBaseUrl + 'emp?branchId=$branchId&query=$query';
    var response = await _dio.get(url,options: Options(headers: headers));
    if(response.statusCode == 200){
      return (response.data as List).map((data) => BookingModel.fromJson(data)).toList();
    }
    else throw Exception('Failed');
  }

  confirmBookingPayment(String bookingId,String empName)async{
    var url = _bookingBaseUrl + "update/status?bookingId=$bookingId&responseBy=$empName";
    var response = await _dio.put(url,options: Options(headers: headers));
    if(response.statusCode == 200) return "Already paid";
    else return "Failed to update";
  }

  Future<List<BookingModel>> getBooking_walkinTaskForEmp(String branchId,String query,bool isBooking)async{
    var url =  _bookingBaseUrl + "tasks?branchId=$branchId&query=$query&isBooking=$isBooking";
    var response = await _dio.get(url,options: Options(headers: headers));
    if(response.statusCode == 200){
      return (response.data as List).map((data) => BookingModel.fromJson(data)).toList();
    }
    else throw Exception('Failed');
  }

  Future<List<BookingModel>> getQueueOfRoom(String roomId)async{
    var url = _bookingBaseUrl + "?roomId=$roomId";
    var response = await _dio.get(url,options: Options(headers: headers));
    if(response.statusCode == 200){
      return (response.data as List).map((data) => BookingModel.fromJson(data)).toList();
    }
    else throw Exception('Failed');
  }

  addBooking(BookingModel book,String type)async{
    var url = _bookingBaseUrl + "$type";
    var response = await _dio.post(
      url,
      data: book.toJson(),
      options: Options(headers: headers)
    );
    if(response.statusCode == 200) return "Success";
    else "Failed";
  }

  checkTimeBooking(BookingModel book)async{
    var url = _bookingBaseUrl + "checktime";
    var response = await _dio.post(
      url,
      options: Options(headers: headers),
      data: book.toJson()
    );
    if(response.statusCode == 200) return response.data;
    else return "Something Wrong";
  }

  updateToHistory()async{
    var url = _bookingBaseUrl + 'user/history/update';
    var response = await _dio.put(url,options: Options(headers: headers));
  }
}