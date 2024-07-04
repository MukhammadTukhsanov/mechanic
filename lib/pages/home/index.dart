// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schichtbuch_shift/components/button.dart';
import 'package:schichtbuch_shift/components/cupertino-picker.dart';
import 'package:schichtbuch_shift/components/input.dart';
import 'package:schichtbuch_shift/components/switch.dart';
import 'package:schichtbuch_shift/generated/l10n.dart';
import 'package:schichtbuch_shift/global/index.dart';
import 'package:schichtbuch_shift/pages/comment/index.dart';
import 'package:schichtbuch_shift/pages/home/machines-list.dart';
import 'package:schichtbuch_shift/pages/mode/index.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _toolMounted = false;
  bool _machineStopped = false;
  bool _partStatusOK = true;
  bool err = false;
  bool added = false;
  bool isStatus = false;
  bool stopTimer = false;
  bool operatingHoursImportant = false;
  bool loadSaving = false;
  bool operatingHoursErr = false;
  bool toolIdIsDisabled = false;
  bool barcodeIsDisabled = false;

  String radioValue = "yes";
  String errText = '';
  String shift = 'S1';
  String mradioValue = "standard";
  String instOperatingHours = "-";
  String instOperatingMinute = "-";
  String _state = '';

  int days = 0;
  int instRemainingProductionHours = 0;
  int instRemainingProductionMinute = 0;

  final _formKey = GlobalKey<FormState>();
  final machineQRCodeController = TextEditingController();
  final productionNumberController = TextEditingController();
  final partNumberController = TextEditingController();
  final partNameController = TextEditingController();
  final cavityController = TextEditingController();
  final cycleTimeController = TextEditingController();
  final pieceNumberController = TextEditingController();
  final noteController = TextEditingController();
  final timeController = TextEditingController();
  final operatingHoursController = TextEditingController();
  final toolNumberController = TextEditingController();
  final _machineQRFocus = FocusNode();
  final _productionNoFocus = FocusNode();

  late DateTime lastWeekdayOfMonth;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    getMachinesList();
    _timer();
    getTimePeriod();
    lastDay();
    _machineQRFocus.addListener(_onFocusChange);
    _productionNoFocus.addListener(setProductionNo);
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((results) {
      setState(() {
        _connectivityResult =
            results.isNotEmpty ? results.last : ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    machineQRCodeController.dispose();
    productionNumberController.dispose();
    partNumberController.dispose();
    partNameController.dispose();
    cavityController.dispose();
    cycleTimeController.dispose();
    pieceNumberController.dispose();
    noteController.dispose();
    _machineQRFocus.dispose();
    _productionNoFocus.dispose();
    super.dispose();
  }

  Future<void> getMachinesList() async {
    var shiftStatusResponse =
        await http.get(Uri.parse('http://$ipAdress/api/machines/$key'));
    if (shiftStatusResponse.statusCode == 200) {
      var data = jsonDecode(shiftStatusResponse.body);
      setState(() {
        shiftText = "${data[0]['toolCleaning']}";
        lastShift = "${data[0]['shift']}";
      });
    }

    var machinesResponse =
        await http.get(Uri.parse('http://$ipAdress/api/machines'));
    if (machinesResponse.statusCode == 200) {
      var data = jsonDecode(machinesResponse.body);
      setState(() {
        globalDevices = data.map((e) => e['machineQrCode']).toList();
      });
    }
  }

  DateTime getLastDayOfMonth(int year, int month) {
    DateTime lastDay = DateTime(year, month + 1, 0);
    while (lastDay.weekday == DateTime.saturday ||
        lastDay.weekday == DateTime.sunday) {
      lastDay = lastDay.subtract(Duration(days: 1));
    }
    return lastDay;
  }

  void lastDay() {
    DateTime lastDay =
        getLastDayOfMonth(DateTime.now().year, DateTime.now().month);
    setState(() {
      operatingHoursImportant = lastDay.day == DateTime.now().day;
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult[0];
    });
  }

  void _onFocusChange() {
    if (_machineQRFocus.hasFocus) {
      machineQRCodeController.text = "";
    }
  }

  void _timer() {
    http.get(Uri.parse('http://$ipAdress/api/machines/$key/start'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
  }

  getTimePeriod() {
    final now = DateTime.now();
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    final time1Start = TimeOfDay(hour: 5, minute: 55);
    final time1End = TimeOfDay(hour: 13, minute: 50);
    final time2Start = TimeOfDay(hour: 13, minute: 55);
    final time2End = TimeOfDay(hour: 21, minute: 50);
    final time3Start = TimeOfDay(hour: 21, minute: 55);
    final time3End = TimeOfDay(hour: 5, minute: 50);

    setState(() {
      if (_isTimeInRange(currentTime, time1Start, time1End)) {
        _state = 'F1';
      } else if (_isTimeInRange(currentTime, time2Start, time2End)) {
        _state = 'S2';
      } else if (_isTimeInRange(
              currentTime, time3Start, TimeOfDay(hour: 23, minute: 59)) ||
          _isTimeInRange(
              currentTime, TimeOfDay(hour: 0, minute: 0), time3End)) {
        _state = 'N3';
      } else {
        _state = 'Undefined State';
      }
    });
  }

  bool _isTimeInRange(
      TimeOfDay currentTime, TimeOfDay startTime, TimeOfDay endTime) {
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    return startMinutes <= endMinutes
        ? currentMinutes >= startMinutes && currentMinutes <= endMinutes
        : currentMinutes >= startMinutes || currentMinutes <= endMinutes;
  }

  final hour = DateTime.now().hour.toString().padLeft(2, '0');
  final minute = DateTime.now().minute.toString().padLeft(2, '0');

  Future<void> addEntry() async {
    if (machineQRCodeController.text.isEmpty && _machineStopped)
    // ||
    // machineQRCodeController.text.isEmpty &&
    //     productionNumberController.text.length < 9 &&
    //     !_machineStopped ||
    // productionNumberController.text.isEmpty &&
    //     cavityController.text.isEmpty &&
    //     cycleTimeController.text.isEmpty &&
    //     pieceNumberController.text.isEmpty)
    {
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

    setState(() {
      loadSaving = true;
    });

    var response = await http.post(
      Uri.parse('http://$ipAdress/api/machines'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        "createdAt": DateTime.now().toString(),
        "token": key,
        "shift": shift,
        "machineQrCode": machineQRCodeController.text,
        "toolMounted": _toolMounted,
        "machineStopped": _machineStopped,
        "barcodeProductionNo": productionNumberController.text.isEmpty
            ? "0"
            : double.parse(productionNumberController.text),
        "toolNo":
            toolNumberController.text.isEmpty ? "0" : toolNumberController.text,
        "cavity": cavityController.text.isEmpty
            ? "0"
            : double.parse(cavityController.text),
        "cycleTime": cycleTimeController.text,
        "partStatus": _partStatusOK,
        "pieceNumber": pieceNumberController.text.isEmpty
            ? "0"
            : double.parse(pieceNumberController.text),
        "note": noteController.text,
        "toolCleaning": radioValue == 'yes',
        "remainingProductionDays": days,
        "remainingProductionTime":
            instRemainingProductionHours * 60 + instRemainingProductionMinute,
        "operatingHours": operatingHoursController.text.isEmpty
            ? "0"
            : operatingHoursController.text,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      showSnackBarFun(context, S.of(context).entryAdded, "success");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => data['total'] == globalDevices.length
                  ? CommentPage()
                  : HomePage()));
    } else {
      showSnackBarFun(context, S.of(context).errorSaving, "error");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }

    setState(() {
      loadSaving = false;
    });
  }

  void onChangedQrCode(String value) {
    if (globalDevices.contains(value)) {
      _machineQRFocus.unfocus();
    }
  }

  void onChangeToolMounted() {
    onMachineStopped();
    setState(() {
      _machineStopped = !_toolMounted;
      _toolMounted = !_toolMounted;
    });
  }

  void showSnackBarFun(BuildContext context, String text, String status) {
    final snackBar = SnackBar(
      content: Text(text, style: TextStyle(fontSize: 20, color: Colors.white)),
      backgroundColor: status == "success" ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 150,
        left: 10,
        right: 10,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void onMachineStopped() {
    setState(() {
      if (_machineStopped) {
        cavityController.text = '0';
        pieceNumberController.text = '0';
        productionNumberController.text = '0';
      } else {
        cavityController.clear();
        pieceNumberController.clear();
        productionNumberController.clear();
        partNumberController.clear();
        partNameController.clear();
        cycleTimeController.clear();
        noteController.clear();
      }
      _machineStopped = !_machineStopped;
    });
  }

  FocusNode _noteFocus = FocusNode();
  bool _showDialog = true;

  Future<void> _showNoteDialog() async {
    if (_showDialog) {
      _showDialog =
          false; // Prevent subsequent taps from showing the dialog again
      await _showNoteTextCombinations(context);
      _noteFocus
          .requestFocus(); // Focus the TextField after the dialog is dismissed
      _showDialog =
          true; // Allow the dialog to be shown again on the next touch
    } else {
      _noteFocus
          .requestFocus(); // Focus the TextField directly if the dialog has already been shown
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChooseMode()));
          return false;
        },
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
                            setState(() {
                              stopTimer = true;
                            });
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ChooseMode();
                            }));
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
            body: _connectivityResult == ConnectivityResult.none
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 100, color: Colors.red[200]),
                      SizedBox(height: 20),
                      Text(S.of(context).noInternetConnection,
                          style: GoogleFonts.lexend(
                              textStyle: const TextStyle(
                                  color: Color(0xff848484),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)))
                    ],
                  ))
                : Row(children: [
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
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        DateTime.now()
                                                                .day
                                                                .toString() +
                                                            ' ' +
                                                            monthNames[
                                                                DateTime.now()
                                                                        .month -
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
                                                            _state,
                                                        // "${S.of(context).shift}  ${shift}",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts.lexend(
                                                            textStyle: TextStyle(
                                                                color: Color(
                                                                    0xff848484),
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)))),
                                                err
                                                    ? Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(Icons.error,
                                                                color: Colors
                                                                    .white),
                                                            SizedBox(
                                                                width: 20.0),
                                                            Text(errText,
                                                                style: GoogleFonts.lexend(
                                                                    textStyle: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.w400))),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox(height: 0.0),
                                              ],
                                            ),
                                            SizedBox(height: 16.0),
                                            Input(
                                                onChanged: onChangedQrCode,
                                                focusNode: _machineQRFocus,
                                                controller:
                                                    machineQRCodeController,
                                                prefixIcon: Icons.qr_code,
                                                labelText: S
                                                    .of(context)
                                                    .scanMachineQRCode),
                                            SizedBox(height: 16.0),

                                            // Radio boxes
                                            // Align(
                                            //     alignment: Alignment.centerLeft,
                                            //     child: Text(
                                            //         S
                                            //             .of(context)
                                            //             .toolCleaningShiftF1Done,
                                            //         textAlign: TextAlign.left,
                                            //         style: GoogleFonts.lexend(
                                            //             textStyle:
                                            //                 const TextStyle(
                                            //                     color: Color(
                                            //                         0xff336699),
                                            //                     fontSize: 22,
                                            //                     fontWeight:
                                            //                         FontWeight
                                            //                             .w600)))),
                                            // SizedBox(width: 20.0),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(children: [
                                                    Transform.scale(
                                                        scale: 1.5,
                                                        child: Radio(
                                                            value: "standard",
                                                            groupValue:
                                                                mradioValue,
                                                            fillColor: MaterialStateProperty
                                                                .all(const Color(
                                                                    0xff336699)),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                barcodeIsDisabled =
                                                                    false;
                                                                _machineStopped =
                                                                    false;
                                                                _toolMounted =
                                                                    false;
                                                                mradioValue =
                                                                    value
                                                                        as String;
                                                              });
                                                              // }
                                                              // setState(() {
                                                              //   _toolMounted = !_toolMounted;
                                                              // });
                                                            })),
                                                    Text('Maschine läuft',
                                                        style: GoogleFonts.lexend(
                                                            textStyle: const TextStyle(
                                                                color: Color(
                                                                    0xff336699),
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)))
                                                  ]),
                                                  Row(children: [
                                                    Transform.scale(
                                                        scale: 1.5,
                                                        child: Radio(
                                                            value: "no",
                                                            groupValue:
                                                                mradioValue,
                                                            fillColor: MaterialStateProperty
                                                                .all(const Color(
                                                                    0xff336699)),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                productionNumberController
                                                                    .text = "";
                                                                toolNumberController
                                                                    .text = "";
                                                                partNameController
                                                                    .text = "";
                                                                partNumberController
                                                                    .text = "";
                                                                cavityController
                                                                    .text = "";
                                                                cycleTimeController
                                                                    .text = "";
                                                                pieceNumberController
                                                                    .text = "";
                                                                noteController
                                                                    .text = "";
                                                                barcodeIsDisabled =
                                                                    false;
                                                                instRemainingProductionHours =
                                                                    0;
                                                                instRemainingProductionMinute =
                                                                    0;
                                                                days = 0;
                                                                _machineStopped =
                                                                    true;
                                                                _toolMounted =
                                                                    true;
                                                                mradioValue =
                                                                    value
                                                                        as String;
                                                              });
                                                            })),
                                                    Text(
                                                        'Maschine läuft nicht und kein Werkzeug gerüstet',
                                                        style: GoogleFonts.lexend(
                                                            textStyle: const TextStyle(
                                                                color: Color(
                                                                    0xff336699),
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)))
                                                  ]),
                                                  Row(children: [
                                                    Transform.scale(
                                                        scale: 1.5,
                                                        child: Radio(
                                                            value: "notNeeded",
                                                            groupValue:
                                                                mradioValue,
                                                            fillColor:
                                                                MaterialStateProperty
                                                                    .all(Color(
                                                                        0xff336699)),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                barcodeIsDisabled =
                                                                    false;
                                                                toolIdIsDisabled =
                                                                    false;
                                                                cavityController
                                                                    .text = "";
                                                                cycleTimeController
                                                                    .text = "";
                                                                pieceNumberController
                                                                    .text = "";
                                                                instRemainingProductionHours =
                                                                    0;
                                                                instRemainingProductionMinute =
                                                                    0;
                                                                days = 0;
                                                                _machineStopped =
                                                                    false;
                                                                _toolMounted =
                                                                    true;
                                                                mradioValue =
                                                                    value
                                                                        as String;
                                                              });
                                                            })),
                                                    Text(
                                                        'Maschine läuft nicht aber Werkzeug ist gerüstet',
                                                        style: GoogleFonts.lexend(
                                                            textStyle: TextStyle(
                                                                color: Color(
                                                                    0xff336699),
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600))),
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            6),
                                                  ])
                                                ]),
                                            SizedBox(height: 16.0),
                                            _machineStopped
                                                ? SizedBox(height: 0.0)
                                                : IsStoped(),

                                            Column(
                                              children: [
                                                if (operatingHoursImportant)
                                                  Input(
                                                    controller:
                                                        operatingHoursController,
                                                    labelText: S
                                                        .of(context)
                                                        .operatingHours,
                                                    validator: !_machineStopped,
                                                    numericOnly: true,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp(r'[0-9]'))
                                                    ],
                                                  )
                                              ],
                                            ),
                                            SizedBox(height: 16.0),
                                            Row(children: [
                                              Expanded(
                                                  child: Button(
                                                      type: "outline",
                                                      text:
                                                          S.of(context).cancel,
                                                      onPressed: () {
                                                        setState(() {
                                                          stopTimer = true;
                                                        });
                                                        Navigator.pop(context);
                                                      })),
                                              SizedBox(width: 20.0),
                                              Expanded(
                                                  child: Button(
                                                loading: loadSaving,
                                                text: S.of(context).save,
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                          .validate() &&
                                                      !loadSaving) {
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
    if (productionNumberController.text.length < 9) {
      setState(() {
        productionNumberError = true;
      });
      return;
    }
    setState(() {
      productionNumberError = false;
    });
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
      if (data["Partnumber"] != "0" && data['Partname'] != "0") {
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

  bool productionNumberError = false;
  Widget IsStoped() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Input(
                  onChanged: (value) {
                    if (value.length > 0) {
                      setState(() {
                        toolIdIsDisabled = true;
                      });
                    } else {
                      setState(() {
                        barcodeIsDisabled = true;
                        toolIdIsDisabled = false;
                      });
                    }
                  },
                  // disabled: barcodeIsDisabled,
                  hassError: false,
                  validator:
                      _machineStopped || barcodeIsDisabled ? false : true,
                  maxLength: 9,
                  focusNode: _productionNoFocus,
                  keyboardType: TextInputType.number,
                  numericOnly: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: productionNumberController,
                  prefixIcon: Icons.qr_code,
                  labelText: S.of(context).scanBarcodeProductionNo),
            ),
            _toolMounted ? SizedBox(width: 20.0) : SizedBox(height: 0.0),
            _toolMounted
                ? Expanded(
                    child: Input(
                      onChanged: (value) {
                        if (value.length > 0) {
                          setState(() {
                            barcodeIsDisabled = true;
                          });
                        } else {
                          setState(() {
                            barcodeIsDisabled = false;
                          });
                        }
                      },
                      validator: toolIdIsDisabled ? false : true,
                      controller: toolNumberController,
                      labelText: S.of(context).toolId,
                      // disabled: toolIdIsDisabled,
                    ),
                  )
                : SizedBox(height: 0.0),
          ],
        ),
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
        _toolMounted ? SizedBox(height: 0.0) : SizedBox(height: 16.0),
        _toolMounted
            ? SizedBox(height: 0.0)
            : Input(
                labelText: S.of(context).cavity,
                validator: _machineStopped ? false : true,
                maxLength: 2,
                numericOnly: true,
                keyboardType: TextInputType.number,
                controller: cavityController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
        _toolMounted ? SizedBox(height: 0.0) : SizedBox(height: 16.0),
        _toolMounted
            ? SizedBox(height: 0.0)
            : Input(
                labelText: S.of(context).cycleTime,
                validator: _machineStopped ? false : true,
                numericOnly: true,
                keyboardType: TextInputType.number,
                controller: cycleTimeController,
                inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^[\d<>]*\,?\d{0,1}')),
                    // FilteringTextInputFormatter.allow(RegExp(r'[0-9-><,]'))
                  ]),
        _toolMounted ? SizedBox(height: 0.0) : SizedBox(height: 16.0),
        // _toolMounted
        //     ? SizedBox(height: 0.0)
        //     : SwitchWithText(
        //         value: _partStatusOK,
        //         label: S.of(context).partStatusOk,
        //         onChange: () {
        //           setState(() {
        //             _partStatusOK = !_partStatusOK;
        //           });
        //         }),
        // _toolMounted ? SizedBox(height: 0.0) : SizedBox(height: 16.0),
        _toolMounted
            ? SizedBox(height: 0.0)
            : Input(
                labelText: S.of(context).pieceNumber,
                validator: _machineStopped ? false : true,
                numericOnly: true,
                keyboardType: TextInputType.number,
                controller: pieceNumberController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
        SizedBox(height: 16.0),
        GestureDetector(
          onTap: _showNoteDialog,
          child: AbsorbPointer(
            child: Input(
                focusNode: _noteFocus,
                validator: false,
                controller: noteController,
                maxLines: 2,
                labelText: S.of(context).note),
          ),
        ),
        _toolMounted ? SizedBox(height: 0.0) : SizedBox(height: 16.0),
        _toolMounted
            ? SizedBox(height: 0.0)
            : Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    // shiftText + lastShift
                    (shiftText == "false" && lastShift == "F1") ||
                            (shiftText == "false" && lastShift == "S2")
                        ? "Achtung - Werkzeugreinigung in notwending!"
                        : (shiftText == "true" && lastShift == "F1")
                            ? "Ist erledigt"
                            : "Werkzeugreinigung in Schicht F1 erledigt?",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.lexend(
                        textStyle: TextStyle(
                            color: (shiftText == "false" &&
                                        lastShift == "F1") ||
                                    (shiftText == "false" && lastShift == "S2")
                                ? Colors.red
                                : Color(0xff336699),
                            fontSize: 22,
                            fontWeight: FontWeight.w600)))),
        _toolMounted ? SizedBox(height: 0.0) : SizedBox(width: 20.0),
        _toolMounted
            ? SizedBox(height: 0.0)
            : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Transform.scale(
                      scale: 1.5,
                      child: Radio(
                          value: "yes",
                          groupValue: radioValue,
                          fillColor: MaterialStateProperty.all(
                              const Color(0xff336699)),
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
                          fillColor: MaterialStateProperty.all(
                              const Color(0xff336699)),
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
                          fillColor:
                              MaterialStateProperty.all(Color(0xff336699)),
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
        _toolMounted ? SizedBox(height: 0.0) : SizedBox(height: 16.0),
        _toolMounted
            ? SizedBox(height: 0.0)
            : Row(children: [
                Expanded(
                    child: ModalCupertinoPicker(
                  label: S.of(context).remainingProductionDays,
                  labelFontSize:
                      Localizations.localeOf(context).languageCode == 'de'
                          ? 15
                          : 22,
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
                    labelFontSize:
                        Localizations.localeOf(context).languageCode == 'de'
                            ? 15
                            : 22,
                    hours: true,
                    selectedDate: instRemainingProductionHours,
                    onSetHour: (value) {
                      setState(() {
                        instRemainingProductionHours = value['hours'];
                        instRemainingProductionMinute = value['minutes'];
                      });
                    },
                  ),
                )
              ]),
        SizedBox(height: 16.0)
      ],
    );
  }

  Future<void> _showNoteTextCombinations(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(S.of(context).noteTextCombinations,
              style: GoogleFonts.lexend(
                  textStyle: const TextStyle(
                      color: Color(0xff336699),
                      fontSize: 22,
                      fontWeight: FontWeight.w600))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Template",
                  style: GoogleFonts.lexend(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff336699),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    noteController.text = S.of(context).waitingForMaterial;
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      S.of(context).waitingForMaterial,
                      style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                        color: Color(0xff848484),
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    noteController.text = S.of(context).noMaterial;
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      S.of(context).noMaterial,
                      style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                        color: Color(0xff848484),
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    noteController.text = S.of(context).noStaff;
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      S.of(context).noStaff,
                      style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                        color: Color(0xff848484),
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    noteController.text = S.of(context).materialNotDry;
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      S.of(context).materialNotDry,
                      style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                        color: Color(0xff848484),
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    noteController.text = S.of(context).startInTheNextShift;
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      S.of(context).startInTheNextShift,
                      style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                        color: Color(0xff848484),
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    noteController.text = S.of(context).wzDefective;
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      S.of(context).wzDefective,
                      style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                        color: Color(0xff848484),
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    noteController.text = S.of(context).machineDefective;
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      S.of(context).machineDefective,
                      style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                        color: Color(0xff848484),
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    noteController.text = S.of(context).peripheralDefective;
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      S.of(context).peripheralDefective,
                      style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                        color: Color(0xff848484),
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // not needed button
            TextButton(
              child: Text(S.of(context).notNeeded,
                  style: GoogleFonts.lexend(
                      textStyle: const TextStyle(
                          color: Color(0xff336699),
                          fontSize: 22,
                          fontWeight: FontWeight.w600))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
