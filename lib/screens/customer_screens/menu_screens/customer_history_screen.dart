
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karaoke_reservation/components/appBar.dart';
import 'package:karaoke_reservation/components/contain_card.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/booking_model.dart';
import 'package:karaoke_reservation/models/branch_model.dart';
import 'package:karaoke_reservation/providers/customer_page_provider.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/services/booking_service.dart';
import 'package:karaoke_reservation/services/branch_room_services.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:provider/provider.dart';
class CustomerHistoryScreen extends StatefulWidget {
  @override
  State<CustomerHistoryScreen> createState() => _CustomerHistoryScreenState();
}

class _CustomerHistoryScreenState extends State<CustomerHistoryScreen> {
  late List<BookingModel> history;

  List<BranchModel>? branches;

  var keyBranch;

  @override
  Widget build(BuildContext context) {
    keyBranch = context.watch<CustomerProvider>().branchKey;
    var _activeUser = context.watch<UserProvider>().activeUser;
    branches = context.watch<CustomerProvider>().branches;
    history = context.watch<CustomerProvider>().historyBookingList;
    _getHistoryList(_activeUser.username);
    return SafeArea(
      child: Scaffold(
        appBar: appBarCustom(true, context),
        body: Column(
          children: [
            titleWidget("HISTORY"),
            Expanded(
              child: (history == [])
              ?Center(child: CircularProgressIndicator(color: secondaryColor))
              :Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemBuilder: (context, index) => _buildHistoryDetails(history[index]),
                  itemCount: history.length,
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _buildHistoryDetails(BookingModel history,){
    var room = Tools().roomId(history.roomId);
    return containCard(
      Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Booking ID : ${history.bookingID}",style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: darkToneColor,fontWeight: FontWeight.w500),),
                Text("${findBranchName(history.branchId)} : $room",style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: darkToneColor)),
                Text("${_getHours(history)}",style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: darkToneColor),)
              ],
            ),
            Positioned(
              right: 10,
              bottom: 7,
              child: Text("${Tools().dateText(history.startDateTime)}",style: TextStyle(fontFamily: 'MavenPro',fontSize: 14,color: darkToneColor))
            )
          ],
        ),
      ), 
      0.8);
  }

  void _getHistoryList(String username)async{
    var booking_service = BookingService();
    var branch_service =  BranchRoomService();
    var result = await booking_service.getBookingHistory(username);
    var key = await branch_service.getBranchKeyName();
    if(mounted){
      context.read<CustomerProvider>().setBranchKey(key);
      context.read<CustomerProvider>().setHistoryList(result);
    }
  }

  String findBranchName(String branchId){
  var result = keyBranch.indexWhere((element) => element.branchId == branchId);
  if(result != -1) return keyBranch[result].branchName;
  return "";
  }

  String _getHours(BookingModel his){
    var end = his.endDateTime;
    var start = his.startDateTime;
    Duration diff = end.difference(start);
    int hours = diff.inHours;
    if(hours > 1) return "$hours Hours.";
    return "$hours Hour.";
  }
}