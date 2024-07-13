import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schichtbuch_shift/generated/l10n.dart';
import 'package:schichtbuch_shift/global/index.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class MachineQualityItem extends StatefulWidget {
  final String id;
  final pieceNumber;
  final token;
  final toolMounted;
  final toolNo;
  final machineStopped;
  final machineQrCode;
  final createdAt;
  final shift;
  final barcodeProductionNo;
  final partName;
  final partNumber;
  final cavity;
  final cycleTime;
  final partStatus;
  final note;
  final toolCleaning;
  final remainingProductionTime;
  final remainingProductionDays;
  final operatingHours;
  bool allPartStatusOK = false;
  bool onSaveDate;
  Function(bool, String) onStateChange;

  MachineQualityItem(
      {required this.id,
      required this.machineQrCode,
      // required this.partnumber,
      // required this.partname,
      required this.onStateChange,
      required this.onSaveDate,
      required this.allPartStatusOK,
      required this.token,
      required this.pieceNumber,
      required this.toolMounted,
      required this.toolNo,
      required this.machineStopped,
      required this.createdAt,
      required this.shift,
      required this.barcodeProductionNo,
      required this.cavity,
      required this.cycleTime,
      required this.partStatus,
      required this.note,
      required this.toolCleaning,
      required this.remainingProductionTime,
      required this.remainingProductionDays,
      required this.operatingHours,
      required this.partName,
      required this.partNumber});

  @override
  State<MachineQualityItem> createState() => _machineQualityItemState();
}

class _machineQualityItemState extends State<MachineQualityItem> {
  bool _partStatusOK = false;

  @override
  void didUpdateWidget(covariant MachineQualityItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.allPartStatusOK != oldWidget.allPartStatusOK) {
      changeFunction();
    }
    if (widget.onSaveDate != oldWidget.onSaveDate) {
      saveAdds();
    }
  }

  void changeFunction() {
    print("status: ${widget.allPartStatusOK}");
    setState(() {
      _partStatusOK = widget.allPartStatusOK;
    });
  }

  void toggleState() {
    setState(() {
      _partStatusOK = !_partStatusOK;
      widget.onStateChange(_partStatusOK, widget.machineQrCode);
    });
  }

  // oninit
  @override
  void initState() {
    super.initState();
    _partStatusOK = widget.partStatus;
  }

  void saveAdds() {
    var data = {
      // "id": widget.id,
      // "pieceNumber": widget.pieceNumber,
      // "token": widget.token,
      // "toolMounted": widget.toolMounted,
      // "toolNo": widget.toolNo,
      // "machineStopped": widget.machineStopped,
      // "machineQrCode": widget.machineQrCode,
      // "createdAt": widget.createdAt,
      // "shift": widget.shift,
      // "barcodeProductionNo": widget.barcodeProductionNo,
      // "cavity": widget.cavity,
      // "cycleTime": widget.cycleTime,
      "partStatus": _partStatusOK,
      // "note": widget.note,
      // "toolCleaning": widget.toolCleaning,
      // "remainingProductionTime": widget.remainingProductionTime,
      // "remainingProductionDays": widget.remainingProductionDays,
      // "operatingHours": widget.operatingHours,
      // "partName": widget.partName,
      // "partNumber": widget.partNumber
    };
    // print(jsonEncode(data));
    // data[key] = value;

    var response = http.put(
      Uri.parse('http://$ipAdress/api/machines/${widget.id}'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    response.then((value) {
      // SnackBar snackBar = SnackBar(
      //   content:
      //       Text('Saved', style: TextStyle(fontSize: 20, color: Colors.white)),
      //   backgroundColor: Colors.green,
      //   dismissDirection: DismissDirection.up,
      //   behavior: SnackBarBehavior.floating,
      //   margin: EdgeInsets.only(
      //       bottom: MediaQuery.of(context).size.height - 150,
      //       left: 10,
      //       right: 10),
      // );

      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((error) {
      print("error $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        0: FixedColumnWidth(165),
        1: FixedColumnWidth(200),
        3: FixedColumnWidth(144)
      },
      border:
          TableBorder.all(color: Color(0xff336699).withOpacity(0.3), width: 1),
      children: [
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.machineQrCode,
                  style: GoogleFonts.lexend(
                      color: Color(0xff336699), fontSize: 24),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.partNumber,
                  style: GoogleFonts.lexend(
                      color: Color(0xff336699), fontSize: 24),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.partName,
                  style: GoogleFonts.lexend(
                      color: Color(0xff336699), fontSize: 24),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: GestureDetector(
                    onTap: toggleState,
                    child: Container(
                      width: 55,
                      height: 25,
                      decoration: BoxDecoration(
                        color: _partStatusOK
                            ? Color(0xff336699)
                            : Color(0xff848484),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Color(0xff848484),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Stack(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).yes,
                                      style: GoogleFonts.lexend(
                                        textStyle: TextStyle(
                                            color: _partStatusOK
                                                ? Colors.white
                                                : Colors.transparent,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Text(S.of(context).no,
                                      style: GoogleFonts.lexend(
                                          textStyle: TextStyle(
                                              color: _partStatusOK
                                                  ? Colors.transparent
                                                  : Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: _partStatusOK
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 21.5,
                                height: 21.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
