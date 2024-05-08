import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RightHorItem extends StatelessWidget {
  bool? header = false;
  String? status;
  String? machine;
  String? productNo;
  RightHorItem({this.header, this.status, this.machine, this.productNo});
  // column width
  double columnWidth = 390;

  @override
  Widget build(BuildContext context) {
    return Column(children: [Header(context), Hours(context)]);
  }

  Widget Hours(BuildContext context) {
    final hours = [0, 4, 8, 12, 16, 20];
    return Container(
      height: 46.5,
      width: columnWidth,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xff848484),
            width: .5,
          ),
        ),
      ),
      child: Row(
        children: [
          // map hours
          for (var hour in hours)
            Expanded(
              child: Container(
                // border right
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Color(0xff848484),
                      width: .5,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    hour.toString().padLeft(2, '0'),
                    style: GoogleFonts.lexend(
                      color: Color(0xff336699),
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget Header(BuildContext context) {
    return Container(
      width: columnWidth,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Color(0xff848484),
            width: .5,
          ),
          bottom: BorderSide(
            color: Color(0xff848484),
            width: .5,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          "03 Fabruary 2024 - MONDAY",
          style: GoogleFonts.lexend(
            color: Color(0xff336699),
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
