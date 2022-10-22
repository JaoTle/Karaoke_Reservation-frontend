import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:karaoke_reservation/components/appBar.dart';
import 'package:karaoke_reservation/components/customer_body/nav_bar/customer_booking_body.dart';
import 'package:karaoke_reservation/components/customer_body/nav_bar/customer_collect_coupons_body.dart';
import 'package:karaoke_reservation/components/customer_body/nav_bar/customer_home_body.dart';
import 'package:karaoke_reservation/components/customer_body/nav_bar/customer_menu_body.dart';
import 'package:karaoke_reservation/providers/booking_provider.dart';
import 'package:karaoke_reservation/providers/customer_page_provider.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';

class CustomerHomeScreen extends StatelessWidget {
  
  List<Widget> _bottomNav = [
    CustomerHomeBody(),
    CustomerBookingBody(),
    CustomerCollectBody(),
    CustomerMenuBody()
  ];

  @override
  Widget build(BuildContext context) {
    int _selectIndex = context.watch<CustomerProvider>().selectedIndex;
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
                    icon: Icons.bookmark_add,
                    text: 'Bookings',
                  ),
                  GButton(
                    icon: Icons.discount_outlined,
                    text: 'Coupons',
                  ),
                  GButton(
                    icon: Icons.account_circle_rounded,
                    text: 'Profile',
                  )
                ],
                selectedIndex: _selectIndex,
                onTabChange: (index){
                  if(_selectIndex != 1 && index ==1){
                      if(Provider.of<BookingProvider>(context,listen: false).isLoading == false){
                        context.read<BookingProvider>().setIsLoading();
                        context.read<BookingProvider>().setSelectingRoom(null);
                        context.read<BookingProvider>().setQueueRoom(null);
                      }
                    }
                  if(_selectIndex != 2 && index == 2){
                    if(Provider.of<CustomerProvider>(context,listen: false).couponLoading == false){
                      context.read<CustomerProvider>().setCouponLoading();
                    }
                  }
                  context.read<CustomerProvider>().setIndex(index);
                },
              ),
            )
          ),
        ),
      )
    );
  }
}