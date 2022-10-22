import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/booking_model.dart';
import 'package:karaoke_reservation/models/room_model.dart';
import 'package:karaoke_reservation/providers/booking_provider.dart';
import 'package:karaoke_reservation/services/booking_service.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:provider/provider.dart';
class QueueView extends StatefulWidget {
  QueueView(this.isEmp);
  bool isEmp;

  @override
  State<QueueView> createState() => _QueueViewState();
}

class _QueueViewState extends State<QueueView> {
  RoomModel? _selectRoom;
  List<BookingModel>? queue;
  late BookingProvider bookingProvider;
  @override
  void didChangeDependencies() {
    bookingProvider = Provider.of<BookingProvider>(context);
    getQueueRoom();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    queue = bookingProvider.queueRoom;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: secondaryColor,
          width: 1
        ),
      ),
      elevation: 5,
      child: Container(
        width: SizeConfig.screenWidth! * 0.9,
        height: 200,
        child: SingleChildScrollView(
          child: Column(
            children: [
              centerTitleWidget("ROOM ${Tools().roomId(_selectRoom!.roomId)} QUEUE"),
              //listview
              Container(
                height: 180,
                child: (queue == null)
                ? Center(child: Text("No queue"))
                :Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    itemBuilder: (context, index) => _buildQueueBox(queue![index],index+1),
                    itemCount: queue!.length,
                  ),
                )
              )
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQueueBox(BookingModel q,int number){
    TextStyle qStyle = TextStyle(fontFamily: 'MavenPro',fontWeight: FontWeight.w500,fontSize: 24,color: darkToneColor);
    TextStyle timeStyle = TextStyle(fontFamily: 'MavenPro',fontSize: 18,color: darkToneColor);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: SizeConfig.screenWidth! * 0.8,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: secondaryColor,width: 1.5)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (widget.isEmp)
              ? Row(
                children: [
                  Text("Q$number",style: qStyle),
                  SizedBox(width: 10),
                  Text("${q.customerName}",style: timeStyle)
                ],
              )
              :Text("Q$number",style: qStyle),
              Text("${Tools().gapTime(q.startDateTime, q.endDateTime)}",style: timeStyle)
            ],
          ),
        ),
      ),
    );
  }

  void getQueueRoom()async{
    var booking_service = BookingService();
    _selectRoom = bookingProvider.selectingRoom;
    var result = await booking_service.getQueueOfRoom(_selectRoom!.roomId);
    bookingProvider.setQueueRoom(result);
  }
}