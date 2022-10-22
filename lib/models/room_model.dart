class RoomModel {
  String roomId,branchId,roomStatus,size;

  RoomModel({required this.roomId,required this.branchId,required this.size,required this.roomStatus});

  factory RoomModel.fromJson(Map<String,dynamic> data){
    return RoomModel(
      roomId: data['roomId'],
      branchId: data['branchId'],
      size: data['size'],
      roomStatus: data['roomStatus']);
  }
  
}