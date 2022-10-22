import 'package:intl/intl.dart';

class BookingModel {
  String bookingID,customerName,branchId,roomId;
  String? status,type,responseEmp;
  double price;
  DateTime startDateTime,endDateTime;

  BookingModel({required this.bookingID,required this.customerName,required this.branchId,required this.roomId,
    this.status,this.type,this.responseEmp,required this.price,required this.startDateTime,required this.endDateTime
  });

  factory BookingModel.fromJson(Map<String,dynamic> data){
    return BookingModel(
      bookingID: data['bookingID'],
      customerName: data['customerName'],
      branchId: data['branchId'],
      roomId: data['roomId'], 
      price: data['price'], 
      startDateTime: new DateFormat('dd-MM-yyyy HH:mm:ss').parse(data['startTime']), 
      endDateTime: new DateFormat('dd-MM-yyyy HH:mm:ss').parse(data['endTime']),
      status: data['status'],
      type: data['type'],
      responseEmp: data['responseEmp']
      );
  }
  
  void setPrice(double price){
    this.price = price;
  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingID'] = this.bookingID;
    data['customerName'] = this.customerName;
    data['branchId'] = this.branchId;
    data['roomId'] = this.roomId;
    data['startTime'] = DateFormat("dd-MM-yyyy HH:mm:ss").format(this.startDateTime);
    data['endTime'] = DateFormat("dd-MM-yyyy HH:mm:ss").format(this.endDateTime);
    data['price'] = this.price;
    data['status'] = '';
    data['type'] = '';
    data['responseEmp'] = '';
    return data;
  }
}