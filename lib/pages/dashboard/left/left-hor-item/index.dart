import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeftHorItem extends StatelessWidget {
  bool? header = false;
  String? status;
  String? machine;
  String? productNo;

  LeftHorItem(
      {Key? key, this.header, this.status, this.machine, this.productNo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              // border bottom
              border: Border(
                  bottom: BorderSide(
                      color: Color(0xff848484),
                      width: .5,
                      style: BorderStyle.solid)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Center(
                child: Text(machine == null ? "Machine" : "$machine",
                    style: GoogleFonts.lexend(
                        fontSize: machine == null ? 18 : 16,
                        fontWeight:
                            machine == null ? FontWeight.w600 : FontWeight.w300,
                        color: Color(0xff336699))),
              ),
            ),
          )),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              color: status == "yellow"
                  ? Color(0xffE6CC00)
                  : status == "succes"
                      ? Color(0xff5CB85C)
                      : Colors.white,
              // border bottom
              border: Border(
                  right: BorderSide(
                      color: Color(0xff848484),
                      width: .5,
                      style: BorderStyle.solid),
                  left: BorderSide(
                      color: Color(0xff848484),
                      width: .5,
                      style: BorderStyle.solid),
                  bottom: BorderSide(
                      color: Color(0xff848484),
                      width: .5,
                      style: BorderStyle.solid)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(
                child: header == true
                    ? Text("Status",
                        style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff336699)))
                    : SizedBox(
                        height: 23,
                      ),
              ),
            ),
          )),
          Expanded(
              child: Container(
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
              child: Center(
                child: Text(productNo == null ? "Product NO" : "$productNo",
                    style: GoogleFonts.lexend(
                        fontSize: productNo == null ? 18 : 16,
                        fontWeight: productNo == null
                            ? FontWeight.w600
                            : FontWeight.w300,
                        color: Color(0xff336699))),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
