import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:karaoke_reservation/components/appBar.dart';
import 'package:karaoke_reservation/components/ceo_body/nav_bar/add_emp_ceo_body.dart';
import 'package:karaoke_reservation/components/ceo_body/nav_bar/add_promo_body.dart';
import 'package:karaoke_reservation/components/ceo_body/nav_bar/home_ceo_body.dart';
import 'package:karaoke_reservation/providers/ceo_page_provider.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';
class CEOHomeScreen extends StatelessWidget {
  List<Widget> _bottomNav = [
    HomeCEOBody(),
    AddEmpBody(),
    AddPromotionBody()
  ];
  @override
  Widget build(BuildContext context) {
    int _selectIndex = context.watch<CEOProviders>().selectIndex;
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
                    icon: Icons.group_rounded,
                    text: 'Employees',
                  ),
                  GButton(
                    icon: Icons.discount_outlined,
                    text: 'Promotions',
                  ),
                  GButton(
                    active: false,
                    icon: Icons.logout,
                    text: 'Logout',
                  )
                ],
                selectedIndex: _selectIndex,
                onTabChange: (index){
                  if(index !=3) context.read<CEOProviders>().setSelectIndex(index);
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