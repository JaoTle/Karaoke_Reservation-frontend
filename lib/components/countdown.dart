import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karaoke_reservation/themes/styles.dart';
class CountDownTimer extends StatefulWidget {
  CountDownTimer(this.full);
  int full;
  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  @override
  void initState() {
    startTime();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("00:${NumberFormat("00").format(widget.full)}",style: infoText),
    );
  }

  void startTime(){
    Timer.periodic(Duration(seconds: 1), (_){
      if(widget.full == 1) _.cancel();
      setState(() {
        widget.full--;
      });
    });
  }
}