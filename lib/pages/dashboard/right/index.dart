import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/generated/l10n.dart';
import 'package:flutter_nfc_kit_example/pages/dashboard/right/right-ver-item/index.dart';

class DashRight extends StatefulWidget {
  String? date = "03 May 2024 - Friday";

  DashRight({this.date});

  @override
  _DashRightState createState() => _DashRightState();
}

class _DashRightState extends State<DashRight> {
  final monthNames = [
    S.current.january,
    S.current.february,
    S.current.march,
    S.current.april,
    S.current.may,
    S.current.june,
    S.current.july,
    S.current.august,
    S.current.september,
    S.current.october,
    S.current.november,
    S.current.december
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [RightVerItem(), RightVerItem(), RightVerItem()],
        ),
      ),
    );
  }
}
