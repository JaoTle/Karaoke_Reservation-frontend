import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/appBar.dart';
import 'package:karaoke_reservation/components/booking_card.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/providers/customer_page_provider.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/services/booking_service.dart';
import 'package:karaoke_reservation/services/branch_room_services.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:provider/provider.dart';
class CustomerCheckBookedScreen extends StatefulWidget {
  const CustomerCheckBookedScreen({Key? key}) : super(key: key);

  @override
  State<CustomerCheckBookedScreen> createState() => _CustomerCheckBookedScreenState();
}

class _CustomerCheckBookedScreenState extends State<CustomerCheckBookedScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  var username;

  @override
  void initState() {
    _tabController = new TabController(length:tabs.length, vsync: this);
    super.initState();
  }
  List<Tab> tabs = [Tab(text: "In booking"),
                  Tab(text: "In active")];
  getBooking()async{
    var booking_service = BookingService();
    var booked = await booking_service.getBookingForUser(username, true);
    var active = await booking_service.getBookingForUser(username, false);
    if(mounted){
      context.read<CustomerProvider>().setActiveList(active);
      context.read<CustomerProvider>().setBookedList(booked);
      if(Provider.of<CustomerProvider>(context,listen: false).branchKey.isEmpty){
        var branch_service = BranchRoomService();
        var key = await branch_service.getBranchKeyName();
        context.read<CustomerProvider>().setBranchKey(key);
      }
    }
    
  }
  @override
  Widget build(BuildContext context) {
    username = ModalRoute.of(context)!.settings.arguments as String;
    getBooking();
    var bookedList = context.watch<CustomerProvider>().bookedList;
    var activeList = context.watch<CustomerProvider>().activeList;
    var keyName = context.watch<CustomerProvider>().branchKey;
    return SafeArea(
      child: Scaffold(
        appBar: appBarCustom(true, context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              titleWidget("BOOKED"),
              SizedBox(height: 10),
              Container(
                height: 50,
                width: SizeConfig.screenWidth! * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: secondaryColor),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: TabBar(
                  tabs:tabs ,
                  labelStyle: TextStyle(fontFamily: 'MavenPro',fontSize: 20),
                  labelColor: darkToneColor,
                  unselectedLabelStyle: TextStyle(fontFamily: 'MavenPro',fontSize: 20),
                  indicator: BoxDecoration(
                    color: brightToneColor,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  controller: _tabController,
                ),
              ),
              Container(
                height: SizeConfig.screenHeight! * 0.8,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: (bookedList == [])
                      ?Center(child: CircularProgressIndicator(color: secondaryColor))
                      :ListView.builder(
                        itemBuilder: (context, index) => BookingCustomerCard(type: "Booked",booking: bookedList[index],),
                        itemCount: bookedList.length,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: (activeList == [])
                      ?Center(child: CircularProgressIndicator(color: secondaryColor))
                      :ListView.builder(
                        itemBuilder: (context, index) => BookingCustomerCard(type: "Completed",booking: activeList[index],),
                        itemCount: activeList.length,
                      ),
                    )
                  ]
                  ),
              ) 
            ],
          ),
        ),
      )
    );
  }
}