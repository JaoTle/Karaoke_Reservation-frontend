import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/models/room_model.dart';
import 'package:karaoke_reservation/providers/booking_provider.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:provider/provider.dart';
class ToggleRoomBtn extends StatelessWidget {
  ToggleRoomBtn(this.room);
  RoomModel room;
  late String status;
  @override
  Widget build(BuildContext context) {
    var selecting = context.watch<BookingProvider>().selectingRoom;
    if(selecting == room) status = "Selecting";
    else status = room.roomStatus;
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: SizedBox(
        height: SizeConfig.screenWidth! * 0.08,
        width: SizeConfig.screenWidth! * 0.08,
        child: GestureDetector(
          onTap: (){
            context.read<BookingProvider>().setSelectingRoom(room);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: secondaryColor),
              borderRadius: BorderRadius.circular(5),
              color: (status == "Available") ? Colors.white :(status == "Unavailable")?darkToneColor:lightToneColor
            ),
            child: Center(
              child: Text("${Tools().roomId(room.roomId)}",
                style: TextStyle(
                  fontFamily: 'MavenPro',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: (status == 'Available') ? darkToneColor :(status == "Unavailable") ? Colors.white : darkToneColor
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}