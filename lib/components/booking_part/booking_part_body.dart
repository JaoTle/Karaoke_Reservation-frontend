import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/booking_part/box_status.dart';
import 'package:karaoke_reservation/components/booking_part/queue_view.dart';
import 'package:karaoke_reservation/components/booking_part/toggle_room.dart';
import 'package:karaoke_reservation/components/contain_card.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/models/booking_model.dart';
import 'package:karaoke_reservation/models/price_details_model.dart';
import 'package:karaoke_reservation/models/room_model.dart';
import 'package:karaoke_reservation/providers/booking_provider.dart';
import 'package:karaoke_reservation/providers/emp_page_provider.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/services/booking_service.dart';
import 'package:karaoke_reservation/services/branch_room_services.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class BookingPartBody extends StatefulWidget {
  BookingPartBody(this.branchId,this.isCustomer);
  String branchId;
  bool isCustomer;

  @override
  State<BookingPartBody> createState() => _BookingPartBodyState();
}

class _BookingPartBodyState extends State<BookingPartBody> {
  List<RoomModel>? _rooms_s,_rooms_m,_rooms_l;
  bool? _isLoading;
  RoomModel? _selectingRoom;
  int? toHours;
  DateTime? startTime;
  String? customerName;
  var _fromKey = GlobalKey<FormState>();
  var emp;
  @override
  void initState() {
    getRooms();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    emp = context.watch<UserProvider>().activeUser.name;
    _isLoading = context.watch<BookingProvider>().isLoading;
    _selectingRoom = context.watch<BookingProvider>().selectingRoom;
    (widget.isCustomer)?customerName = context.watch<UserProvider>().activeUser.username:null;
    ToastContext().init(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Center(
        child: _isLoading!
        ?CircularProgressIndicator(color: secondaryColor)
        :Column(
          children: [
            SizedBox(height: 20),
            _buildSelectedRoom("s"),
            _buildSelectedRoom("m"),
            _buildSelectedRoom("l"),
            SizedBox(height: 20),
            (_selectingRoom == null)
            ?_buildTextBox()
            :QueueView(!widget.isCustomer),
            (_selectingRoom == null)
            ?SizedBox()
            :manageBookingView()
          ],
        ),
      ),
    );
  }

  getRooms()async{
    var branch_service = BranchRoomService();
    List<RoomModel> response = await branch_service.getRooms(widget.branchId);
    _rooms_s = response.where((element) => element.size == "S").toList();
    _rooms_m = response.where((element) => element.size == "M").toList();
    _rooms_l = response.where((element) => element.size == "L").toList();
    context.read<BookingProvider>().setIsLoading();
  }
  Widget _buildTextBox(){
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
        height: 30,
        child: Center(
          child: Text("Please select room to show queue or booking",
          style: TextStyle(color: darkToneColor,fontFamily: 'MavenPro',fontWeight: FontWeight.w500,fontSize: 16)
          )
        ),
      ),
    );
  }
  Widget manageBookingView(){
    return Form(
      key: _fromKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _timeDropdown(),
                _hourDropdown()
              ],
            ),
            SizedBox(height: 20),
            (!widget.isCustomer) 
            ? SizedBox(
              height: 40,
              width:200 ,
              child: TextFormField(
                onSaved: (newValue) => customerName = newValue,
                decoration: inputDecor("Customer Name"),
              ),
            )
            :SizedBox(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: manageButton(()async{
                if(_fromKey.currentState!.validate()){
                  _fromKey.currentState!.save();
                  if(toHours == null || startTime == null || customerName == ''){
                    Toast.show("กรุณาระบุเวลาและข้อมูลให้ครบถ้วน",duration: Toast.lengthShort,gravity: Toast.center);
                  }
                  else {
                    var branch_room_services = BranchRoomService();
                    PriceDetailsModel response = await branch_room_services.getPrice(widget.branchId,_selectingRoom!.size);
                    var price = 0.0;
                    if(toHours == 1) price = response.oneHour;
                    else if(toHours == 2) price = response.twoHours;
                    else if(toHours == 3) price = response.threeHours;
                    var book = BookingModel(
                      bookingID: GenId().genId(8), customerName: customerName!, 
                      branchId: widget.branchId, roomId: _selectingRoom!.roomId, 
                      price: price, startDateTime: startTime!, 
                      endDateTime: startTime!.add(Duration(hours: toHours!)),
                      responseEmp: (!widget.isCustomer)?emp:null);
                    var booking_service = BookingService();
                    String result = await booking_service.checkTimeBooking(book);
                    if(result == "Go to payment") {
                      if(widget.isCustomer){
                        Toast.show("$result",duration: Toast.lengthLong,gravity: Toast.center);
                        Navigator.pushNamed(context, '/cus_booking_detail',arguments:book);
                      }
                      else{
                        var response = await booking_service.addBooking(book, 'walkin');
                        if(mounted){
                          Toast.show("$response",duration: Toast.lengthLong,gravity: Toast.center);
                          context.read<BookingProvider>().setIsLoading();
                          context.read<BookingProvider>().setSelectingRoom(null);
                          context.read<BookingProvider>().setQueueRoom(null);
                          context.read<EmpProvider>().setIndex(2);
                        }
                      }
                    }
                    else Toast.show("$result",duration: Toast.lengthLong,gravity: Toast.center);
                  }
                }
                
              },(widget.isCustomer) ?"จอง" : "Walk-in",
              (widget.isCustomer)? Icons.bookmark_border_rounded:Icons.add),
            )
          ],
        ),
      ),
    );
  }
  SizedBox _hourDropdown(){
    List<int> hours = [1,2,3];
    return SizedBox(
      height: 35,
      width: 110,
      child: DropdownButtonFormField<int>(
        onSaved: (newValue) => toHours = newValue,
        borderRadius: BorderRadius.circular(20),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 20),
            enabledBorder: inputBorderStyle,
            border: inputBorderStyle,
            focusedBorder: inputBorderStyle
          ),
        hint: Text("ชั่วโมง",style: dropDownBookingField),
        items: hours.map<DropdownMenuItem<int>>((value){
          return DropdownMenuItem<int>(
            value: value,
            child: Text("$value",style: dropDownBookingField,),
          );
        }).toList(), 
        onChanged: (value){

        }),
    );
  }
  SizedBox _timeDropdown() {
    return SizedBox(
      height: 35,
      width: 110,
      child: DropdownButtonFormField<DateTime>(
        onSaved: (newValue) => startTime = newValue,
        borderRadius: BorderRadius.circular(20),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 20),
            enabledBorder: inputBorderStyle,
            border: inputBorderStyle,
            focusedBorder: inputBorderStyle
          ),
        hint: Text("เวลาเริ่ม",style: dropDownBookingField),
        items: (Tools().listOfTime()).map<DropdownMenuItem<DateTime>>((value) {
          return DropdownMenuItem<DateTime>(
            value: value,
            child: Text("${Tools().timeFormat(value)}",style: dropDownBookingField),
          );
        }).toList(), 
        onChanged: (value){

        }),
    );
  }
  Widget _buildSelectedRoom(String size){
    return containCard(
      Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Row(
          children: [
            Image.asset("assets/icons/chroom_$size.png",width: SizeConfig.screenWidth! *0.15,),
            listRoomBtn(
              (size =='s') ? _rooms_s
              : (size == 'm') ? _rooms_m
              : _rooms_l
            )
          ],
        ),
      ),
      0.85
    );
  }

  Widget listRoomBtn(List<RoomModel>? rooms) {
    if(rooms != null){
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: (rooms.length > 7)
          ?Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: rooms.sublist(0,6).map((e) => 
                ToggleRoomBtn(e)).toList(),
              ),
              Row(
                children: rooms.sublist(6,rooms.length).map((e) => ToggleRoomBtn(e)).toList(),
              )
            ],
          )
          :Row(
            children: rooms.map((e) => ToggleRoomBtn(e)).toList(),
          ),
        ),
      );
    }
    return SizedBox();
  }
}

