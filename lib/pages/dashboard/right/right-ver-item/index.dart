import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/pages/dashboard/right/right-hor-item/index.dart';

class RightVerItem extends StatelessWidget {
  bool? header = false;
  String? status;
  String? machine;
  String? productNo;
  RightVerItem({this.header, this.status, this.machine, this.productNo});

  @override
  Widget build(BuildContext context) {
    return Column(children: [RightHorItem()]);
  }
}
