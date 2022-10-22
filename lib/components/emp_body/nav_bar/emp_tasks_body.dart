import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/booking_card.dart';
import 'package:karaoke_reservation/components/searchWidget.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/booking_model.dart';
import 'package:karaoke_reservation/providers/emp_page_provider.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/services/booking_service.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:provider/provider.dart';

class EmpTasksBody extends StatefulWidget {
  @override
  State<EmpTasksBody> createState() => _EmpTasksBodyState();
}

class _EmpTasksBodyState extends State<EmpTasksBody> with TickerProviderStateMixin {
  late TabController _tabController;
  late EmpProvider empProvider;
  late UserProvider userProvider;
  late List<BookingModel> _bookingTasks,_walkinTasks;
  var query;
  var booking_service = BookingService();
  var branchId;

  @override
  void didChangeDependencies() {
    empProvider = Provider.of<EmpProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    getTaskforEmp();
    super.didChangeDependencies();
  }
  @override
  void initState() {
    _tabController = new TabController(length:tabs.length, vsync: this);
    super.initState();
  }
  
  List<Tab> tabs = [Tab(text: "Walk-in"),
                  Tab(text: "Booked")];
  getTaskforEmp()async{
    branchId = userProvider.activeUser.stationedBranchId;
    var walkInTasks = await booking_service.getBooking_walkinTaskForEmp(branchId!, "", false);
    empProvider.setWalkinTask(walkInTasks);
    var bookingTasks = await booking_service.getBooking_walkinTaskForEmp(branchId, "", true);
    empProvider.setBookingTask(bookingTasks);
  }
  @override
  Widget build(BuildContext context) {
    _bookingTasks = empProvider.bookingTasks;
    _walkinTasks = empProvider.walkinTasks;
    query = empProvider.tasksQuery;
    return SingleChildScrollView(
      child: Column(
        children: [
          titleWidget("TASKS"),
          SizedBox(height: 10),
          Container(
                height: 35,
                width: SizeConfig.screenWidth! * 0.6,
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
              SearchWidget(
                text: query, 
                onChanged:search , 
                hintText: "Booking Id,Username,Emp.name", 
                headIcon: Icons.search
              ),
              Container(
                height: SizeConfig.screenHeight! * 0.8,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemBuilder: (context,index) => TasksEmpCard(type: "walkin",booking: _walkinTasks[index]),
                        itemCount: _walkinTasks.length,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemBuilder: (context,index) => TasksEmpCard(type: "booked",booking: _bookingTasks[index]),
                        itemCount: _bookingTasks.length,
                      ),
                    )
                  ]
                  ),
              )
        ],
      ),
    );
  }
  void search(String query)async{
    if(_tabController.index == 0){
      var result = await booking_service.getBooking_walkinTaskForEmp(branchId!, query, true);
      empProvider.setBookingTask(result);
    }
    else {
      var result = await booking_service.getBooking_walkinTaskForEmp(branchId, query, false);
      empProvider.setBookingTask(result);
    }
    empProvider.setTasksQuery(query);
  }
}