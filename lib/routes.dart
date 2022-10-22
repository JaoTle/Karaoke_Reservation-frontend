import 'package:flutter/material.dart';
import 'package:karaoke_reservation/screens/ceo_screens/ceo_add_branch_screen.dart';
import 'package:karaoke_reservation/screens/ceo_screens/ceo_add_emp_screen.dart';
import 'package:karaoke_reservation/screens/ceo_screens/ceo_branch_details_screen.dart';
import 'package:karaoke_reservation/screens/ceo_screens/ceo_home_screen.dart';
import 'package:karaoke_reservation/screens/customer_screens/customer_booking_detail_screen.dart';
import 'package:karaoke_reservation/screens/customer_screens/customer_success_payment.dart';
import 'package:karaoke_reservation/screens/customer_screens/menu_screens/customer_booked_screen.dart';
import 'package:karaoke_reservation/screens/customer_screens/customer_booking_screen.dart';
import 'package:karaoke_reservation/screens/customer_screens/menu_screens/customer_coupon_screen.dart';
import 'package:karaoke_reservation/screens/customer_screens/menu_screens/customer_history_screen.dart';
import 'package:karaoke_reservation/screens/customer_screens/customer_home_screen.dart';
import 'package:karaoke_reservation/screens/customer_screens/signup_screen.dart';
import 'package:karaoke_reservation/screens/emp_screens/emp_home_screen.dart';
import 'package:karaoke_reservation/screens/main_screens/home_screen.dart';
import 'package:karaoke_reservation/screens/main_screens/login_screen.dart';
import 'package:karaoke_reservation/screens/main_screens/pre-login_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (context) => HomeScreen(),
  "/pre-login" :(context) => PreLoginScreen(),
  "/login":(context) => LoginScreen(),
  "/signup":(context) => SignupScreen(),

  //CEO
  "/ceo":(context) => CEOHomeScreen(),
  "/branch_detail":(context) => BranchDetailScreen(),
  "/add_branch" :(context) => AddBranchScreen(),
  "/add_emp" :(context) => AddEmpScreen(),

  //Emp
  "/emp":(context) => EmpHomeScreen(),

  //Customer
  "/customer":(context) => CustomerHomeScreen(),
  "/cus_booking" :(context) => CustomerBookingScreen(),
  "/cus_booking_detail":(context) => BookingDetailScreen(),
  "/cus_success_pay":(context) => SuccessPaymentScreen(),
  "/cus_history":(context) => CustomerHistoryScreen(),
  "/cus_check_booked":(context) => CustomerCheckBookedScreen(),
  "/cus_mycoupons":(context) =>  CustomerCouponsScreen()
};