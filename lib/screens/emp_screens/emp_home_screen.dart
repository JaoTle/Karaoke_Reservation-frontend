import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:karaoke_reservation/components/appBar.dart';
import 'package:karaoke_reservation/components/emp_body/nav_bar/emp_home_body.dart';
import 'package:karaoke_reservation/components/emp_body/nav_bar/emp_manage_room_body.dart';
import 'package:karaoke_reservation/components/emp_body/nav_bar/emp_tasks_body.dart';
import 'package:karaoke_reservation/providers/booking_provider.dart';
import 'package:karaoke_reservation/providers/emp_page_provider.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';

class EmpHomeScreen extends StatelessWidget {
  List<Widget> _bottomNav = [
    EmpHomeBody(),
    EmpManageRoomBody(),
    EmpTasksBody()
  ];

  @override
  Widget build(BuildContext context) {
    int _selectIndex = context.watch<EmpProvider>().selectedIndex;
    return SafeArea(
      child: Scaffold(
        appBar: appBarCustom(false,context),
        body: _bottomNav[_selectIndex],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              navBarShadow
            ],
            color: greyBg
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
              child: GNav(
                rippleColor: secondaryColor,
                hoverColor: lightToneColor,
                gap: 8,
                activeColor: Colors.white,
                iconSize: 25,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: secondaryColor,
                color: secondaryColor,
                textStyle: navBarTextStyle,
                tabs: [
                  GButton(
                    icon: Icons.home_rounded,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.room_preferences_rounded,
                    text: 'Mg. Rooms',
                  ),
                  GButton(
                    icon: Icons.checklist_rounded,
                    text: 'Tasks',
                  ),
                  GButton(
                    active: false,
                    icon: Icons.logout,
                    text: 'Logout',
                  )
                ],
                selectedIndex: _selectIndex,
                onTabChange: (index){
                  if(index !=3){
                    if(_selectIndex != 1 && index ==1){
                      if(Provider.of<BookingProvider>(context,listen: false).isLoading == false){
                        context.read<BookingProvider>().setIsLoading();
                        context.read<BookingProvider>().setSelectingRoom(null);
                        context.read<BookingProvider>().setQueueRoom(null);
                      }
                    }
                    context.read<EmpProvider>().setIndex(index);
                  }
                  else Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            )
          ),
        ),
      )
    );
  }
}