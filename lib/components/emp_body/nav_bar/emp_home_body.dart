
import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/contain_card.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/components/emp_body/change_password_form.dart';
import 'package:karaoke_reservation/components/searchWidget.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/booking_model.dart';
import 'package:karaoke_reservation/providers/emp_page_provider.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/services/booking_service.dart';
import 'package:karaoke_reservation/services/branch_room_services.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';

class EmpHomeBody extends StatefulWidget {
  @override
  State<EmpHomeBody> createState() => _EmpHomeBodyState();
}

class _EmpHomeBodyState extends State<EmpHomeBody> {
  var branchKey;
  var query;
  var branchId;
  var _activeUser;
  late List<BookingModel> bookings;
  late var empProvider;
  @override
  void didChangeDependencies() {
    empProvider = Provider.of<EmpProvider>(context);
    super.didChangeDependencies();
  }
  @override
  void initState() {
    _getKey();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _activeUser = context.watch<UserProvider>().activeUser;
    query = empProvider.textQuery;
    branchId = _activeUser.stationedBranchId;
    _getBooking(branchId!, query);
    branchKey = empProvider.branchKey;   
    bookings = empProvider.bookings;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 30,left: 10,right: 10),
        child: Center(
          child: Column(
            children: [
              Container(
                width: SizeConfig.screenWidth! * 0.85,
                height: 180,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                    spreadRadius: 1,
                    blurStyle: BlurStyle.normal,
                    blurRadius: 5)
                    ],
                  image: DecorationImage(image: AssetImage("assets/images/employee_Card.png"),fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
              child: Stack(
                children: [
                  Positioned(
                    child: Text("Hi, ${_activeUser.name}",
                      style: TextStyle(color: darkToneColor,fontFamily: 'MavenPro',fontWeight: FontWeight.w600,fontSize: 24),
                      overflow: TextOverflow.ellipsis,
                    ),
                    top: 55,
                    left: 40,
                  ),
                  Positioned(
                    top: 90,
                    left: 40,
                    child: Row(
                      children: [
                        Image.asset('assets/icons/branch.png',width: SizeConfig.screenWidth! * 0.15,),
                        SizedBox(width: 10),
                        Text("${findBranchName(_activeUser.stationedBranchId!)}",
                        style: TextStyle(color: secondaryColor,fontFamily: 'MavenPro',fontSize: 25),
                        overflow: TextOverflow.ellipsis,
                        )
                      ],
                    )
                  ),
                  Positioned(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        primary:secondaryColor,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: BorderSide(color: secondaryColor),
                        alignment: Alignment.center
                      ),
                      onPressed: ()=>_changePassword(),
                      icon: Icon(Icons.mode_edit_outline_rounded,color: darkToneColor,size: 20,),
                      label: Text("Change Password",style: TextStyle(color: darkToneColor,fontFamily: 'MavenPro',fontSize: 12),)
                    ),
                    right: 0,
                    bottom: 5,
                  )
                ],
              ),
              ),
              SizedBox(height: 20),
              manageButton(() => context.read<EmpProvider>().setIndex(1), "Walk-in", Icons.add),
              centerTitleWidget("BOOKING LIST"),
              SearchWidget(
                text: query, 
                onChanged: searchBooking, 
                hintText: "Booking ID , Username", 
                headIcon: Icons.search_rounded),
              Container(
                height: SizeConfig.screenHeight! * 0.7,
                child: (bookings.isEmpty)
                ? Center(child: CircularProgressIndicator(color: secondaryColor))
                :ListView.builder(
                  itemBuilder: (context, index) => _buildBooking(bookings[index]),
                  itemCount: bookings.length,
                ))
            ],
          ),
        ),
      ),
    );
  }

  void searchBooking(String query)async{
    var booking_service = BookingService();
    var queryBooking = await booking_service.getBookingForEmp(branchId, query);
    empProvider.setBookings(queryBooking);
    empProvider.setTextQuery(query);
  }

  Widget _buildBooking(BookingModel booking){
    return containCard(
      Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Positioned(
            left: 10,
            child:Image.asset("assets/icons/room.png",width: SizeConfig.screenWidth! * 0.13)
          ),
          Positioned(
            left: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Booking ID : ",style:bookingLabelStyle),
                    Text("${booking.bookingID}",style: bookingInfoStyle)
                  ],
                ),
                Row(
                  children: [
                    Text("Booking by : ",style: bookingLabelStyle,),
                    Text("${booking.customerName}",style: bookingInfoStyle)
                  ],
                ),
                Row(
                  children: [
                    Text("Room : ",style: bookingLabelStyle),
                    Text("${Tools().roomId(booking.roomId)}",style: bookingInfoStyle)
                  ],
                ),
                Row(
                  children: [
                    Text("Time : ",style: bookingLabelStyle,),
                    Text("${Tools().gapTime(booking.startDateTime, booking.endDateTime)}",style: bookingInfoStyle,)
                  ],
                )
              ],
            )
          ),
          Positioned(
            child: IconButton(
              onPressed: (){
                _buildConfirmDialog(booking);
              },
              icon: Image.asset("assets/icons/check_icon.png",height: 50,width: 50,),
              padding: EdgeInsets.all(0),
              ),
            right: 10,
          )
        ],
      ),
      0.9
    );
  }
  _buildConfirmDialog(BookingModel booking){
    showDialog(context: context, 
    builder: (context){
      return AlertDialog(
        contentPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: centerTitleWidget("ROOM ${Tools().roomId(booking.roomId)}"),
        content: Container(
          height: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Customer : ${booking.customerName}",style: detailsAlert),
              Text("Time : ${Tools().gapTime(booking.startDateTime, booking.endDateTime)}",style: detailsAlert),
              Text("Remaining price : ${booking.price}",style: detailsAlert),
              Text("Already full paid?",style: titleAlert)
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: ()async{
            var booking_service = BookingService();
            var response = await booking_service.confirmBookingPayment(booking.bookingID, _activeUser.name);
            bookings.removeWhere((book) => book.bookingID == booking.bookingID);
            empProvider.setBookings(bookings);
            Navigator.pop(context);
          }  , child: Text("Confirm",style: btnAlert)),
          TextButton(onPressed: () => Navigator.pop(context) , child: Text("Cancel",style: btnAlert))
        ],
      );
    }
  );
  }
  _changePassword(){
    showDialog(
      context: context, 
      builder: (context){
        return ChangePasswordForm();
      }
    );
  }

  _getBooking(String branchId,String query)async{
    var booking_service = BookingService();
    var bookings =  await booking_service.getBookingForEmp(branchId, query);
    empProvider.setBookings(bookings);
  }
  _getKey()async{
    var branch_service = BranchRoomService();
    var response = await branch_service.getBranchKeyName();
    empProvider.setBranchKey(response);
  }

  String findBranchName(String branchId){
    var result = branchKey.indexWhere((element) => element.branchId == branchId);
    if(result != -1) return branchKey[result].branchName;
    return "";
  }
}