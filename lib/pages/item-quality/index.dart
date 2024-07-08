import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schichtbuch_shift/components/button.dart';
import 'package:schichtbuch_shift/generated/l10n.dart';
import 'package:schichtbuch_shift/global/index.dart';

import 'package:http/http.dart' as http;
import 'package:schichtbuch_shift/pages/item-quality/machine-item.dart';

// ignore: must_be_immutable
class ItemQuality extends StatefulWidget {
  ItemQuality({Key? key}) : super(key: key);
  bool _allPartStatusOK = true;
  bool changeAll = true;
  bool _saveDate = false;

  @override
  State<ItemQuality> createState() => _ItemQualityState();
}

class _ItemQualityState extends State<ItemQuality> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  List machinesList = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      count = 0;
    });
    _checkConnectivity();
    getMachinesList();

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
  }

  List changes = [];
  List machinesNameList = [];

  getMachinesList() async {
    var response =
        await http.get(Uri.parse('http://$ipAdress/api/machines/$key'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      data.map(
        (e) {
          setState(() {
            machinesNameList = [...machinesNameList, e['machineQrCode']];
          });
        },
      ).toList();
      setState(() {
        changes = machinesNameList;
        machinesList = data;
      });
      print("machinesList: $machinesList");
    }
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult[0];
    });
  }

  void onChangeAll() {
    print(widget._allPartStatusOK);
    if (widget._allPartStatusOK) {
      setState(() {
        widget.changeAll = true;
        changes = [];
      });
      setState(() {
        widget.changeAll = false;
        changes = [];
      });
    }
    if (!widget._allPartStatusOK) {
      setState(() {
        widget.changeAll = false;
      });
      setState(() {
        widget.changeAll = true;
        changes = machinesNameList;
      });
    }
    setState(() {
      widget._allPartStatusOK = !widget._allPartStatusOK;
    });
    print(changes);
  }

  void _handleChildStateChange(bool newState, String machine) {
    print("$newState $machine");
    if (newState) {
      setState(() {
        changes = [...changes, machine];
      });
    } else {
      List newList = List.from(changes);
      String itemToDelete = machine;

      newList.remove(itemToDelete);
      setState(() {
        changes = newList;
      });
    }
    if (changes.length == machinesNameList.length ||
        changes.length > machinesNameList.length) {
      setState(() {
        widget._allPartStatusOK = true;
      });
    } else {
      setState(() {
        widget._allPartStatusOK = false;
      });
    }
    print(changes);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                // title: Text(S.of(context).modeSelection,
                title: Text("Artikelqualität eintragen",
                    style: TextStyle(
                        color: Color(0xff336699),
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                leading: Builder(builder: (BuildContext context) {
                  return IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: Color(0xff336699), size: 30),
                      onPressed: () {
                        Navigator.pop(context);
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
                            removeToken(context);
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
                : SingleChildScrollView(
                    child: Column(children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: BorderDirectional(
                            bottom: BorderSide(
                              color: Color(0xff336699).withOpacity(.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Alle OK",
                                  style: GoogleFonts.lexend(
                                      color: Color(0xff336699), fontSize: 24),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Expanded(
                              child: Center(
                                child: GestureDetector(
                                  onTap: onChangeAll,
                                  child: Container(
                                    width: 55,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: widget._allPartStatusOK
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(S.of(context).yes,
                                                    style: GoogleFonts.lexend(
                                                      textStyle: TextStyle(
                                                          color: widget
                                                                  ._allPartStatusOK
                                                              ? Colors.white
                                                              : Colors
                                                                  .transparent,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                Text(S.of(context).no,
                                                    style: GoogleFonts.lexend(
                                                        textStyle: TextStyle(
                                                            color: widget
                                                                    ._allPartStatusOK
                                                                ? Colors
                                                                    .transparent
                                                                : Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              widget._allPartStatusOK
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 21.5,
                                              height: 21.5,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Container(
                        // padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: BorderDirectional(
                            bottom: BorderSide(
                              color: Color(0xff336699).withOpacity(.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                  width: 1,
                                  color: Color(0xff336699).withOpacity(.3)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              width: 1,
                                              color: Color(0xff336699)
                                                  .withOpacity(.3)))),
                                  child: Center(
                                    child: Text(
                                      "Maschine",
                                      style: GoogleFonts.lexend(
                                          color: Color(0xff336699),
                                          fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              width: 1,
                                              color: Color(0xff336699)
                                                  .withOpacity(.3)))),
                                  child: Center(
                                    child: Text(
                                      "TeileNr",
                                      style: GoogleFonts.lexend(
                                          color: Color(0xff336699),
                                          fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              width: 1,
                                              color: Color(0xff336699)
                                                  .withOpacity(.3)))),
                                  child: Center(
                                    child: Text(
                                      "Teilename",
                                      style: GoogleFonts.lexend(
                                          color: Color(0xff336699),
                                          fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    left: BorderSide(
                                        width: 1,
                                        color:
                                            Color(0xff336699).withOpacity(.3)),
                                  )),
                                  child: Center(
                                    child: Text(
                                      "Teilstatus OK",
                                      style: GoogleFonts.lexend(
                                          color: Color(0xff336699),
                                          fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 1,
                                    color: Color(0xff336699).withOpacity(.3)))),
                        child: Column(
                            children: machinesList.map((e) {
                          return MachineQualityItem(
                              id: e["id"].toString(),
                              token: e["token"].toString(),
                              pieceNumber: e["pieceNumber"],
                              toolMounted: e["toolMounted"],
                              machineStopped: e["machineStopped"],
                              machineQrCode: e["machineQrCode"].toString(),
                              createdAt: e["createdAt"].toString(),
                              shift: e["shift"].toString(),
                              barcodeProductionNo: e["barcodeProductionNo"],
                              cavity: e["cavity"],
                              cycleTime: e["cycleTime"].toString(),
                              partStatus: e["partStatus"],
                              note: e["note"].toString(),
                              toolCleaning: e["toolCleaning"],
                              remainingProductionTime:
                                  e["remainingProductionTime"],
                              remainingProductionDays:
                                  e["remainingProductionDays"],
                              operatingHours: e["operatingHours"],
                              partName: e["partname"],
                              partNumber: e["partnumber"],
                              onSaveDate: widget._saveDate,
                              toolNo: e["toolNo"],
                              onStateChange: _handleChildStateChange,
                              allPartStatusOK: widget.changeAll);
                        }).toList()),
                      ),
                    ),
                    // Save button
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(children: [
                        Expanded(child: SizedBox()),
                        SizedBox(width: 20.0),
                        Expanded(
                            child: Button(
                          // loading: loadSaving,
                          text: S.of(context).save,
                          onPressed: () {
                            setState(() {
                              widget._saveDate = !widget._saveDate;
                            });
                          },
                        ))
                      ]),
                    )
                  ]))));
  }
}
