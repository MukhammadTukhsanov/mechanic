import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:schichtbuch_shift/generated/l10n.dart';

import '../../components/cupertino-picker.dart';
import '../../components/input.dart';
import '../../components/switch.dart';
import '../../global/index.dart';

class MachineItem extends StatefulWidget {
  final String id;
  final int pieceNumber;
  final String token;
  final bool toolMounted;
  final bool machineStopped;
  final String machineQrCode;
  final String createdAt;
  final String shift;
  final int barcodeProductionNo;
  final partName;
  final partNumber;
  final int cavity;
  final String cycleTime;
  final bool partStatus;
  final String note;
  final bool toolCleaning;
  final int remainingProductionTime;
  final int remainingProductionDays;
  final String operatingHours;

  MachineItem({
    required this.id,
    required this.pieceNumber,
    required this.token,
    required this.toolMounted,
    required this.machineStopped,
    required this.machineQrCode,
    required this.createdAt,
    required this.shift,
    required this.barcodeProductionNo,
    required this.partName,
    required this.partNumber,
    required this.cavity,
    required this.cycleTime,
    required this.partStatus,
    required this.note,
    required this.toolCleaning,
    required this.remainingProductionTime,
    required this.remainingProductionDays,
    required this.operatingHours,
  });

  @override
  _MachineItemState createState() => _MachineItemState();
}

class _MachineItemState extends State<MachineItem> {
  bool _isExpanded = false;
  bool _machineStopped = false;
  String _note = '';
  int _remainingProductionTime = 0;
  int _remainingProductionDays = 0;
  int _cavity = 0;
  String _cycleTime = '';
  bool _partStatus = false;
  int _pieceNumber = 0;

  bool isEdit = false;

  // init state
  @override
  void initState() {
    super.initState();
    _machineStopped = widget.machineStopped;
    _note = widget.note;
    _remainingProductionTime = widget.remainingProductionTime;
    _remainingProductionDays = widget.remainingProductionDays;
    _cavity = widget.cavity;
    _cycleTime = widget.cycleTime;
    _partStatus = widget.partStatus;
    _pieceNumber = widget.pieceNumber;
  }

  void save() {
    var data = {
      "token": widget.token,
      "pieceNumber": _pieceNumber,
      "toolMounted": widget.toolMounted,
      "machineStopped": _machineStopped,
      "machineQrCode": widget.machineQrCode,
      "createdAt": widget.createdAt,
      "shift": widget.shift,
      "barcodeProductionNo": widget.barcodeProductionNo,
      "cavity": _cavity,
      "cycleTime": _cycleTime,
      "partStatus": widget.partStatus,
      "note": _note,
      "toolCleaning": widget.toolCleaning,
      "remainingProductionTime": _remainingProductionTime,
      "remainingProductionDays": _remainingProductionDays,
      "operatingHours": widget.operatingHours,
      "partName": widget.partName,
      "partNumber": widget.partNumber
    };

    // data[key] = value;

    var response = http.put(
      Uri.parse('http://$ipAdress/api/machines/${widget.id}'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    response.then((value) {
      SnackBar snackBar = SnackBar(
        content:
            Text('Saved', style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.green,
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 150,
            left: 10,
            right: 10),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((error) {
      print("error $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
                widget.partNumber.toString() == ""
                    ? "PartNo und Partname sind leer"
                    : widget.partNumber.toString() +
                        ' | ' +
                        widget.partName.toString(),
                style: GoogleFonts.lexend(color: Color(0xff336699))),
            subtitle: Text(
              widget.shift,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
            leading: IconButton(
              icon: !isEdit ? Icon(Icons.edit) : Icon(Icons.save),
              onPressed: () {
                setState(() {
                  isEdit = !isEdit;
                  if (isEdit && !_isExpanded) {
                    _isExpanded = true;
                  }
                });

                if (!isEdit) {
                  save();
                }
              },
            ),
          ),
          if (_isExpanded)
            isEdit
                ? Container(
                    padding: EdgeInsets.all(10),
                    // height: 200,
                    child: Column(
                      children: [
                        Column(
                          children: <Widget>[
                            SwitchWithText(
                                label: S.of(context).machineStopped,
                                value: _machineStopped,
                                onChange: () {
                                  setState(() {
                                    _machineStopped = !_machineStopped;
                                  });
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Input(
                            labelText: 'Stückzahl kumuliert',
                            validator: _machineStopped ? false : true,
                            numericOnly: true,
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(
                                text: _pieceNumber.toString()),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        Input(
                            labelText: S.of(context).cavity,
                            validator: _machineStopped ? false : true,
                            numericOnly: true,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                _cavity = int.parse(value);
                              });
                            },
                            controller:
                                TextEditingController(text: _cavity.toString()),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        Input(
                            labelText: S.of(context).cycleTime,
                            validator: _machineStopped ? false : true,
                            numericOnly: true,
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text: _cycleTime),
                            onChanged: (value) {
                              setState(() {
                                _cycleTime = value;
                              });
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[\d<>]*\,?\d{0,1}')),
                              // FilteringTextInputFormatter.allow(RegExp(r'[0-9-><,]'))
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        // Column(
                        //   children: <Widget>[
                        //     SwitchWithText(
                        //         label: S.of(context).partStatusOk,
                        //         value: _partStatus,
                        //         onChange: () {
                        //           setState(() {
                        //             _partStatus = !_partStatus;
                        //           });
                        //         }),
                        //   ],
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Input(
                            validator: false,
                            controller: TextEditingController(text: _note),
                            maxLines: 2,
                            onChanged: (value) {
                              setState(() {
                                _note = value;
                              });
                            },
                            labelText: S.of(context).note),
                        SizedBox(
                          height: 10,
                        ),
                        Column(children: <Widget>[
                          ModalCupertinoPicker(
                            label: S.of(context).remainingProductionTime,
                            labelFontSize:
                                Localizations.localeOf(context).languageCode ==
                                        'de'
                                    ? 15
                                    : 22,
                            hours: true,
                            // selectedDate: instRemainingProductionHours,
                            onSetHour: (value) {
                              setState(() {
                                _remainingProductionTime =
                                    value['hours'] * 60 + value['minutes'];
                              });
                            },
                          ),
                        ]),
                        SizedBox(
                          height: 10,
                        ),
                        ModalCupertinoPicker(
                          label: S.of(context).remainingProductionDays,
                          labelFontSize:
                              Localizations.localeOf(context).languageCode ==
                                      'de'
                                  ? 15
                                  : 22,
                          // selectedDate: days,
                          onSelect: (index) {
                            setState(() {
                              _remainingProductionDays = index;
                            });
                          },
                        )
                      ],
                    ))
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff336699),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            // space between
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // make 50% of the screen width
                              SizedBox(
                                child: Text(
                                  S.of(context).machineStopped + ': ',
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  _machineStopped
                                      ? S.of(context).yes
                                      : S.of(context).no,
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 4, top: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff336699),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            // space between
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // make 50% of the screen width
                              SizedBox(
                                child: Text(
                                  S.of(context).pieceNumber + ': ',
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  _pieceNumber.toString(),
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   padding: EdgeInsets.only(bottom: 4, top: 14),
                        //   decoration: BoxDecoration(
                        //     border: Border(
                        //       bottom: BorderSide(
                        //         color: Color(0xff336699),
                        //         width: 1,
                        //       ),
                        //     ),
                        //   ),
                        //   child: Row(
                        //     // space between
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: <Widget>[
                        //       // make 50% of the screen width
                        //       SizedBox(
                        //         child: Text(
                        //           S.of(context).shift + ': ',
                        //           style: GoogleFonts.roboto(
                        //               fontSize: 24,
                        //               fontWeight: FontWeight.normal,
                        //               color: Color(0xff336699)),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         child: Text(
                        //           widget.shift,
                        //           style: GoogleFonts.roboto(
                        //               fontSize: 24,
                        //               fontWeight: FontWeight.normal,
                        //               color: Color(0xff336699)),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Container(
                          padding: EdgeInsets.only(bottom: 4, top: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff336699),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            // space between
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // make 50% of the screen width
                              SizedBox(
                                child: Text(
                                  'Produktios nummer: ',
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  widget.barcodeProductionNo.toString(),
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 4, top: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff336699),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            // space between
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // make 50% of the screen width
                              SizedBox(
                                child: Text(
                                  S.of(context).cavity + ': ',
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  _cavity.toString(),
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 4, top: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff336699),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            // space between
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // make 50% of the screen width
                              SizedBox(
                                child: Text(
                                  S.of(context).cycleTime + ': ',
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  widget.cycleTime,
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   padding: EdgeInsets.only(bottom: 4, top: 14),
                        //   decoration: BoxDecoration(
                        //     border: Border(
                        //       bottom: BorderSide(
                        //         color: Color(0xff336699),
                        //         width: 1,
                        //       ),
                        //     ),
                        //   ),
                        //   child: Row(
                        //     // space between
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: <Widget>[
                        //       // make 50% of the screen width
                        //       SizedBox(
                        //         child: Text(
                        //           S.of(context).partStatusOk + ': ',
                        //           style: GoogleFonts.roboto(
                        //               fontSize: 24,
                        //               fontWeight: FontWeight.normal,
                        //               color: Color(0xff336699)),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         child: Text(
                        //           _partStatus
                        //               ? S.of(context).yes
                        //               : S.of(context).no,
                        //           style: GoogleFonts.roboto(
                        //               fontSize: 24,
                        //               fontWeight: FontWeight.normal,
                        //               color: Color(0xff336699)),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Container(
                          padding: EdgeInsets.only(bottom: 4, top: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff336699),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            // space between
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // make 50% of the screen width
                              SizedBox(
                                child: Text(
                                  S.of(context).note + ': ',
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  _note,
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 4, top: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff336699),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            // space between
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // make 50% of the screen width
                              SizedBox(
                                child: Text(
                                  S.of(context).toolCleaningShiftF1Done + ': ',
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  widget.toolCleaning
                                      ? S.of(context).yes
                                      : S.of(context).no,
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 4, top: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff336699),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            // space between
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // make 50% of the screen width
                              SizedBox(
                                child: Text(
                                  S.of(context).remainingProductionTime + ': ',
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  _remainingProductionTime.toString(),
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 4, top: 14),
                          decoration: BoxDecoration(
                            border: Border(),
                          ),
                          child: Row(
                            // space between
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // make 50% of the screen width
                              SizedBox(
                                child: Text(
                                  S.of(context).remainingProductionDays + ': ',
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  _remainingProductionDays.toString(),
                                  style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff336699)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
        ],
      ),
    );
  }
}
