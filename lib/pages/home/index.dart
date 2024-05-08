import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit_example/components/button.dart';
import 'package:flutter_nfc_kit_example/components/cupertino-picker.dart';
import 'package:flutter_nfc_kit_example/components/input.dart';
import 'package:flutter_nfc_kit_example/components/machineStatus.dart';
import 'package:flutter_nfc_kit_example/components/switch.dart';
import 'package:flutter_nfc_kit_example/generated/l10n.dart';
import 'package:flutter_nfc_kit_example/global/index.dart';
import 'package:flutter_nfc_kit_example/pages/home/machines-list.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _toolMounted = true;
  bool _machineStopped = false;
  bool _partStatusOK = true;
  bool err = false;
  bool added = false;
  bool isStatus = false;

  String radioValue = 'yes';
  String errText = '';

  int days = 0;
  int instHours = 0;
  int instMinute = 0;

  final _formKey = GlobalKey<FormState>();

  TextEditingController machineQRCodeController = TextEditingController();
  final productionNumberController = TextEditingController();
  final partNumberController = TextEditingController();
  final partNameController = TextEditingController();
  final cavityController = TextEditingController();
  final cycleTimeController = TextEditingController();
  final pieceNumberController = TextEditingController();
  final noteController = TextEditingController(); // remaining production time
  final timeController = TextEditingController(); // remaining production time
  final operatingHoursController = TextEditingController();

  final FocusNode _machineQRFocus = FocusNode();
  final FocusNode _productionNoFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    _machineQRFocus.addListener(_onFocusChange);
    _productionNoFocus.addListener(setProductionNo);
  }

  @override
  void dispose() {
    machineQRCodeController.dispose();
    partNumberController.dispose();
    partNameController.dispose();
    cavityController.dispose();
    cycleTimeController.dispose();
    pieceNumberController.dispose();
    noteController.dispose();
    operatingHoursController.dispose();
    _machineQRFocus.dispose();
    _productionNoFocus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_machineQRFocus.hasFocus) {
      machineQRCodeController.text = "";
    }
  }

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

  final hour = DateTime.now().hour < 10
      ? '0${DateTime.now().hour}'
      : DateTime.now().hour.toString();
  final minute = DateTime.now().minute < 10
      ? '0${DateTime.now().minute}'
      : DateTime.now().minute.toString();

  addEntry() async {
    showSnackBarFun(context, "text");
    if (machineQRCodeController.text == '' &&
        productionNumberController.text == '' &&
        _machineStopped == true) {
      setState(() {
        errText = S.of(context).fillAllFields;
        err = true;
      });
      Timer(Duration(seconds: 3), () {
        setState(() {
          err = false;
        });
      });
      return;
    } else if (machineQRCodeController.text == '' &&
        productionNumberController.text == '' &&
        _machineStopped == false &&
        productionNumberController.text == '' &&
        cavityController.text == '' &&
        cycleTimeController.text == '' &&
        pieceNumberController.text == '' &&
        noteController.text == '' &&
        operatingHoursController.text == '') {
      setState(() {
        errText = S.of(context).fillAllFields;
        err = true;
      });
      Timer(Duration(seconds: 3), () {
        setState(() {
          err = false;
        });
      });
      return;
    }
    var response = await http.post(
      Uri.parse('http://${ipAdress}/api/machines'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "createdAt":
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} - ${DateTime.now().hour}:${DateTime.now().minute}: ${DateTime.now().second}",
        "token": "$token",
        "shift": "S1",
        "machineQrCode": "${machineQRCodeController.text}",
        "toolMounted": _toolMounted, // true or false
        "machineMounted": _machineStopped, // true or fadouble.pa lse
        "barcodeProductionNo": "${productionNumberController.text}",
        "cavity": double.parse(cavityController.text),
        "cycleTime": "${cycleTimeController.text}",
        "partStatus": "${_partStatusOK ? 'OK' : 'Not OK'}",
        "pieceNumber": double.parse(pieceNumberController.text),
        "note": "${noteController.text}",
        "toolCleaning": "$radioValue",
        "remainingProductionTime": instHours * 60 + instMinute,
        "operatingHours": double.parse(operatingHoursController.text),
        "remainingProductionDays": days,
        "machineStatus": "completed",
      }),
    );
    if (response.statusCode == 422) {
      setState(() {
        errText = S.of(context).fillAllFields;
        err = true;
      });
      Timer(Duration(seconds: 3), () {
        setState(() {
          err = false;
        });
      });
    }
    if (response.statusCode == 200) {
      print(response.body);
      machineQRCodeController.text = '';
      productionNumberController.text = '';
      cavityController.text = '';
      cycleTimeController.text = '';
      pieceNumberController.text = '';
      noteController.text = '';
      operatingHoursController.text = '';
      Timer(Duration(seconds: 3), () {
        setState(() {
          isStatus = true;
          isStatus = true;
          added = true;
        });
      });
    }

    // response((value) {
    //   machineQRCodeController.text = '';
    //   productionNumberController.text = '';
    //   cavityController.text = '';
    //   cycleTimeController.text = '';
    //   pieceNumberController.text = '';
    //   noteController.text = '';
    //   operatingHoursController.text = '';
    //   Timer(Duration(seconds: 3), () {
    //     setState(() {
    //       isStatus = !isStatus;
    //       added = false;
    //     });
    //   });
  }

  bool keyboardOpened = false;

  showSnackBarFun(context, String text) {
    SnackBar snackBar = SnackBar(
      content: Text(text, style: TextStyle(fontSize: 20)),
      backgroundColor: Colors.indigo,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 10,
          right: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future rebuild() async {}
  @override
  Widget build(BuildContext context) {
    print("token: $token");
    return Material(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text(S.of(context).addEntry,
                    style: TextStyle(
                        color: Color(0xff336699),
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                leading: Builder(builder: (BuildContext context) {
                  return IconButton(
                      icon:
                          Icon(Icons.menu, color: Color(0xff336699), size: 30),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip);
                }),
                actions: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                        border:
                            Border.all(color: Color(0xff336699), width: 1.0)),
                    child: Row(
                      children: [
                        Icon(Icons.person_outline,
                            color: Color(0xff336699), size: 30.0),
                        SizedBox(width: 10.0),
                        Text(user,
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(width: 40.0),
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.logout,
                              color: Colors.red, size: 30.0)))
                ],
                centerTitle: true,
                flexibleSpace: Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(30, 5, 119, 190),
                      spreadRadius: 0,
                      blurRadius: 3,
                      offset: Offset(0, 3))
                ]))),
            body: Row(children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                      reverse: false,
                      child: Container(
                          color: Colors.white,
                          width: 145,
                          child: Column(children: [
                            SizedBox(
                              height: 20.0,
                            ),
                            MachineStatusList(
                              changeStatus: isStatus,
                            ),
                          ])))),
              Expanded(
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                          child: Container(
                              color: Colors.white,
                              width: 120,
                              child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(children: [
                                      Stack(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  DateTime.now()
                                                          .day
                                                          .toString() +
                                                      ' ' +
                                                      monthNames[
                                                          DateTime.now().month -
                                                              1] +
                                                      ' ' +
                                                      DateTime.now()
                                                          .year
                                                          .toString() +
                                                      ' | ' +
                                                      hour +
                                                      ':' +
                                                      minute +
                                                      ' | ' +
                                                      "${S.of(context).shift}  S2",
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.lexend(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xff848484),
                                                          fontSize: 22,
                                                          fontWeight: FontWeight
                                                              .w400)))),
                                          err
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.error,
                                                          color: Colors.white),
                                                      SizedBox(width: 20.0),
                                                      Text(errText,
                                                          style: GoogleFonts.lexend(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400))),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(height: 0.0),
                                        ],
                                      ),
                                      SizedBox(height: 16.0),
                                      Input(
                                          focusNode: _machineQRFocus,
                                          controller: machineQRCodeController,
                                          prefixIcon: Icons.qr_code,
                                          labelText:
                                              S.of(context).scanMachineQRCode),
                                      SizedBox(height: 16.0),
                                      Stack(children: [
                                        SwitchWithText(
                                            value: _toolMounted,
                                            label: S.of(context).toolMounted,
                                            onChange: () {
                                              setState(() {
                                                _toolMounted = !_toolMounted;
                                              });
                                            }),
                                        Positioned(
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30,
                                            child: SwitchWithText(
                                                value: _machineStopped,
                                                label: S
                                                    .of(context)
                                                    .machineStopped,
                                                onChange: () {
                                                  setState(() {
                                                    _machineStopped =
                                                        !_machineStopped;
                                                  });
                                                }))
                                      ]),

                                      SizedBox(height: 16.0),
                                      ///////////////////////////////////////////////////////////////////////
                                      _machineStopped
                                          ? SizedBox(height: 0.0)
                                          : IsStoped(),
                                      Row(children: [
                                        Expanded(
                                            child: Button(
                                                type: "outline",
                                                text: S.of(context).cancel,
                                                onPressed: () {
                                                  // navigate back
                                                  Navigator.pop(context);
                                                })),
                                        SizedBox(width: 20.0),
                                        Expanded(
                                            child: Button(
                                          text: S.of(context).save,
                                          onPressed: () {
                                            setState(() {
                                              isStatus = !isStatus;
                                            });
                                            if (_formKey.currentState!
                                                .validate()) {
                                              addEntry();
                                            }
                                          },
                                        ))
                                      ])
                                    ]),
                                  ))))))
            ])));
  }

  setProductionNo() {
    if (productionNumberController.text.length < 2) {
      return;
    }
    // http get request
    var response = http.get(
      Uri.parse(
          'http://${ipAdress}/api/productionnumber/${productionNumberController.text}'), // 80735001
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    response.then((value) {
      var data = jsonDecode(value.body);
      print(data);
      if (data["Partnumber"] != 0 && data['Partname'] != 0) {
        partNumberController.text = "${data['Partnumber']}";
        partNameController.text = "${data['Partname']}";
      } else {
        partNumberController.text = "Not Found";
        partNameController.text = "Not Found";
      }
    }).catchError((error) {
      errText = error.toString();

      setState(() {
        err = true;
      });
      Timer(Duration(seconds: 3), () {
        setState(() {
          err = false;
        });
      });
      print(error);
    });
  }

  Widget IsStoped() {
    return Column(
      children: [
        Input(
            focusNode: _productionNoFocus,
            keyboardType: TextInputType.number,
            controller: productionNumberController,
            prefixIcon: Icons.qr_code,
            labelText: S.of(context).scanBarcodeProductionNo),
        SizedBox(height: 16.0),
        Row(children: [
          Expanded(
              child: Input(
            validator: false,
            controller: partNumberController,
            labelText: S.of(context).partNumber,
            disabled: true,
          )),
          SizedBox(width: 20.0),
          Expanded(
              child: Input(
                  validator: false,
                  controller: partNameController,
                  labelText: S.of(context).partName,
                  disabled: true))
        ]),
        SizedBox(height: 16.0),
        Input(
            keyboardType: TextInputType.number,
            controller: cavityController,
            labelText: S.of(context).cavity,
            numericOnly: true),
        SizedBox(height: 16.0),
        Input(
            controller: cycleTimeController,
            keyboardType: TextInputType.number,
            numericOnly: true,
            labelText: S.of(context).cycleTime),
        SizedBox(height: 16.0),
        SwitchWithText(
            value: _partStatusOK,
            label: S.of(context).partStatusOk,
            onChange: () {
              setState(() {
                _partStatusOK = !_partStatusOK;
              });
            }),
        SizedBox(height: 16.0),
        Input(
            controller: pieceNumberController,
            labelText: S.of(context).pieceNumber,
            keyboardType: TextInputType.number,
            numericOnly: true),
        SizedBox(height: 16.0),
        Input(
            controller: noteController,
            maxLines: 4,
            labelText: S.of(context).note),
        SizedBox(height: 16.0),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(S.of(context).toolCleaningShiftF1Done,
                textAlign: TextAlign.left,
                style: GoogleFonts.lexend(
                    textStyle: const TextStyle(
                        color: Color(0xff336699),
                        fontSize: 22,
                        fontWeight: FontWeight.w600)))),
        SizedBox(width: 20.0),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Transform.scale(
                scale: 1.5,
                child: Radio(
                    value: "yes",
                    groupValue: radioValue,
                    fillColor:
                        MaterialStateProperty.all(const Color(0xff336699)),
                    onChanged: (value) {
                      setState(() {
                        radioValue = value as String;
                      });
                    })),
            Text(S.of(context).yes,
                style: GoogleFonts.lexend(
                    textStyle: const TextStyle(
                        color: Color(0xff336699),
                        fontSize: 22,
                        fontWeight: FontWeight.w600)))
          ]),
          Row(children: [
            Transform.scale(
                scale: 1.5,
                child: Radio(
                    value: "no",
                    groupValue: radioValue,
                    fillColor:
                        MaterialStateProperty.all(const Color(0xff336699)),
                    onChanged: (value) {
                      setState(() {
                        radioValue = value as String;
                      });
                    })),
            Text(S.of(context).no,
                style: GoogleFonts.lexend(
                    textStyle: const TextStyle(
                        color: Color(0xff336699),
                        fontSize: 22,
                        fontWeight: FontWeight.w600)))
          ]),
          Row(children: [
            Transform.scale(
                scale: 1.5,
                child: Radio(
                    value: "notNeeded",
                    groupValue: radioValue,
                    fillColor: MaterialStateProperty.all(Color(0xff336699)),
                    onChanged: (value) {
                      setState(() {
                        radioValue = value as String;
                      });
                    })),
            Text(S.of(context).notNeeded,
                style: GoogleFonts.lexend(
                    textStyle: TextStyle(
                        color: Color(0xff336699),
                        fontSize: 22,
                        fontWeight: FontWeight.w600))),
            SizedBox(width: MediaQuery.of(context).size.width / 6),
          ])
        ]),
        SizedBox(height: 16.0),
        Row(children: [
          Expanded(
              child: ModalCupertinoPicker(
            label: S.of(context).remainingProductionDays,
            labelFontSize: 22,
            selectedDate: days,
            onSelect: (index) {
              setState(() {
                days = index;
              });
            },
          )),
          SizedBox(width: 20.0),
          Expanded(
            child: ModalCupertinoPicker(
              label: S.of(context).remainingProductionTime,
              labelFontSize: 22,
              hours: true,
              selectedDate: instHours,
              onSetHour: (value) {
                setState(() {
                  instHours = value.hour;
                  instMinute = value.minute;
                });
              },
            ),
          )
        ]),
        SizedBox(height: 16.0),
        Input(
            controller: operatingHoursController,
            labelText: S.of(context).operatingHours,
            keyboardType: TextInputType.number,
            numericOnly: true),
        SizedBox(height: 16.0),
      ],
    );
  }
  // }
}
