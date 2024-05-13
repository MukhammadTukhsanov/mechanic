import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/generated/l10n.dart';
import 'package:flutter_nfc_kit_example/global/index.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class EditInfo extends StatefulWidget {
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  List editedDevices = [];
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      setState(() {
        if (results.isNotEmpty) {
          _connectivityResult = results.last;
        } else {
          _connectivityResult = ConnectivityResult.none;
        }
      });
    });
    getDevice();
  }

  List<bool> expanded = [false, false];
  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult[
          0]; // Extract the first ConnectivityResult from the list
    });
  }

  void getDevice() {
    var response = http.get(
      Uri.parse('http://$ipAdress/api/machines/$key'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    response.then((value) {
      var data = jsonDecode(value.body);
      setState(() {
        editedDevices = data;
      });
    }).catchError((error) {
      print("error $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(S.of(context).editInfo,
                style: TextStyle(
                    color: Color(0xff336699),
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                  icon: Icon(Icons.menu, color: Color(0xff336699), size: 30),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip);
            }),
            actions: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: Color(0xff336699), width: 1.0)),
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
                      icon: Icon(Icons.logout, color: Colors.red, size: 30.0)))
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
            : SingleChildScrollView(
                child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(children: [
                  ...editedDevices.map((e) {
                    return machineItem(
                        e['machineQrCode'].toString(),
                        e['createdAt'].toString(),
                        e['shift'].toString(),
                        e['barcodeProductionNo'].toString(),
                        e['cavity'].toString(),
                        e['cycleTime'].toString(),
                        e['partStatus'].toString(),
                        e['note'].toString(),
                        e['toolCleaning'].toString(),
                        e['remainingProductionTime'].toString(),
                        e['remainingProductionDays'].toString(),
                        e['operatingHours'].toString(),
                        e['partName'].toString(),
                        e['partNumber'].toString());
                  }).toList(),
                ]),
              )));
  }

  Widget machineItem(
      String machineQrCode,
      String createdAt,
      String shift,
      String barcodeProductionNo,
      String partName,
      String partNumber,
      String cavity,
      String cycleTime,
      String partStatus,
      String note,
      String toolCleaning,
      String remainingProductionTime,
      String remainingProductionDays,
      String operatingHours) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: Color(0xff848484), width: 0.5),
            ),
            child: ExpansionTile(
                title: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          border:
                              Border.all(color: Color(0xff336699), width: 2.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22.0, vertical: 8.0),
                        child: Text(machineQrCode,
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff336699),
                            )),
                      ),
                    ),
                  ],
                ),
                children: [
                  ListTile(
                    title: Text(
                      "${S.of(context).date}/${S.of(context).time}",
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff336699),
                      ),
                    ),
                    subtitle: Text(createdAt,
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          color: Color(0xff336699),
                        )),
                    // trailing: GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(context,
                    //         MaterialPageRoute(builder: (context) {
                    //       return EditPage(
                    //           machineQrCode: machineQrCode,
                    //           createdAt: createdAt,
                    //           shift: shift,
                    //           barcodeProductionNo: barcodeProductionNo,
                    //           cavity: cavity,
                    //           cycleTime: cycleTime,
                    //           partStatus: partStatus,
                    //           note: note,
                    //           toolCleaning: toolCleaning,
                    //           remainingProductionTime: remainingProductionTime,
                    //           remainingProductionDays: remainingProductionDays,
                    //           operatingHours: operatingHours);
                    //     }));
                    //   },
                    //   child: Container(
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(6.0),
                    //           border: Border.all(
                    //               color: Color(0xff336699), width: 1.0)),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(10.0),
                    //         child: Icon(Icons.edit, color: Color(0xff336699)),
                    //       )),
                    // ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      S.of(context).shift,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff336699),
                      ),
                    ),
                    subtitle: Text(shift,
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          color: Color(0xff336699),
                        )),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      S.of(context).productionNumber,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff336699),
                      ),
                    ),
                    subtitle: Text(
                        barcodeProductionNo == 'null'
                            ? "-"
                            : barcodeProductionNo,
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          color: Color(0xff336699),
                        )),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      S.of(context).partName,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff336699),
                      ),
                    ),
                    subtitle: Text(partName == 'null' ? '-' : partName,
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          color: Color(0xff336699),
                        )),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      S.of(context).partNumber,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff336699),
                      ),
                    ),
                    subtitle: Text(partNumber == 'null' ? '-' : partNumber,
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          color: Color(0xff336699),
                        )),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      S.of(context).cavity,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff336699),
                      ),
                    ),
                    subtitle: Text(cavity == 'null' ? '-' : cavity,
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          color: Color(0xff336699),
                        )),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      S.of(context).cycleTime,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff336699),
                      ),
                    ),
                    subtitle: Text(cycleTime == 'null' ? '-' : cycleTime,
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          color: Color(0xff336699),
                        )),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      S.of(context).partStatusOk,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff336699),
                      ),
                    ),
                    subtitle: Text(partStatus == 'null' ? '-' : 'Active',
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          color: Color(0xff336699),
                        )),
                  ),
                  Divider(),
                  // ListTile(
                  //   title: Text(
                  //     'Number of Pieces Acumulated',
                  //     style: GoogleFonts.lexend(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold,
                  //       color: Color(0xff336699),
                  //     ),
                  //   ),
                  //   subtitle: Text('2',
                  //       style: GoogleFonts.lexend(
                  //         fontSize: 20,
                  //         color: Color(0xff336699),
                  //       )),
                  // ),
                  // Divider(),
                  ListTile(
                    title: Text(
                      S.of(context).note,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff336699),
                      ),
                    ),
                    subtitle: Text(note == 'null' ? '-' : note,
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          color: Color(0xff336699),
                        )),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      S.of(context).toolCleaningShiftF1Done,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff336699),
                      ),
                    ),
                    subtitle: Text(toolCleaning == 'null' ? '-' : toolCleaning,
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          color: Color(0xff336699),
                        )),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      S.of(context).remainingProductionTime,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff336699),
                      ),
                    ),
                    subtitle: Text(
                        remainingProductionTime == 'null'
                            ? '-'
                            : remainingProductionTime,
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          color: Color(0xff336699),
                        )),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      S.of(context).remainingProductionDays,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff336699),
                      ),
                    ),
                    subtitle: Text(
                        remainingProductionDays == 'null'
                            ? '-'
                            : remainingProductionDays,
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          color: Color(0xff336699),
                        )),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      S.of(context).operatingHours,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff336699),
                      ),
                    ),
                    subtitle: Text(
                        operatingHours.length == 0 || operatingHours == 'null'
                            ? '-'
                            : operatingHours,
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          color: Color(0xff336699),
                        )),
                  ),
                ]),
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
