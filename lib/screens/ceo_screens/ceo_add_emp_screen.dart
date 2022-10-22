import 'package:flutter/material.dart';
import 'package:karaoke_reservation/components/appBar.dart';
import 'package:karaoke_reservation/components/ceo_body/add_emp_body.dart';

class AddEmpScreen extends StatelessWidget {
  const AddEmpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarCustom(true, context),
        body: FormAddEmpBody(),
      )
    );
  }
}