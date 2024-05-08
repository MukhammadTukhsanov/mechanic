import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/generated/l10n.dart';
import 'package:flutter_nfc_kit_example/pages/dashboard/left/left-hor-item/index.dart';
import 'package:google_fonts/google_fonts.dart';

class DashLeft extends StatefulWidget {
  const DashLeft({Key? key}) : super(key: key);

  @override
  _DashLeftState createState() => _DashLeftState();
}

class _DashLeftState extends State<DashLeft> {
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              // border bottom
              border: Border(
                  bottom: BorderSide(
                      color: Color(0xff848484),
                      width: .5,
                      style: BorderStyle.solid)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text("Today:",
                          style: GoogleFonts.lexend(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff336699))),
                      SizedBox(width: 10),
                      Text(
                          "${DateTime.now().day} ${monthNames[DateTime.now().month - 1]} ${DateTime.now().year}",
                          style: GoogleFonts.lexend(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Color(0xff336699))),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      // current time
                      Text(
                          "${DateTime.now().hour.toString().padLeft(2, '0')} : ${DateTime.now().minute.toString().padLeft(2, '0')}",
                          style: GoogleFonts.lexend(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff336699))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          LeftHorItem(
            header: true,
          ),
          LeftHorItem(
            machine: "F45OiA-1",
            status: "yellow",
            productNo: "80735001",
          ),
        ],
      ),
    );
  }
}
