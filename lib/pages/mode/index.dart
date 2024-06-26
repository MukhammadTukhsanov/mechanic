import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:schichtbuch_shift/generated/l10n.dart';
import 'package:schichtbuch_shift/global/index.dart';
import 'package:schichtbuch_shift/pages/dashboard/index.dart';
import 'package:schichtbuch_shift/pages/edit-info/index.dart';
import 'package:schichtbuch_shift/pages/home/index.dart';
import 'package:schichtbuch_shift/pages/login/index.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class ChooseMode extends StatefulWidget {
  @override
  State<ChooseMode> createState() => _ChooseModeState();
}

class _ChooseModeState extends State<ChooseMode> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
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

  getMachinesList() async {
    var response = await http.get(Uri.parse('http://$ipAdress/api/machines'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        globalDevices = [];
      });

      data.map(
        (e) {
          setState(() {
            globalDevices = [...globalDevices, e['machineQrCode']];
          });
        },
      ).toList();
      print(data);
    }
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult[
          0]; // Extract the first ConnectivityResult from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(S.of(context).modeSelection,
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Login();
                      }));
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
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return HomePage();
                              }));
                            },
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff336699), width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(S.of(context).newEntry,
                                      style: GoogleFonts.lexend(
                                        fontSize: 30,
                                        color: Color(0xff336699),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 40),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EditInfo();
                              }));
                            },
                            child: Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width / 2,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xff336699), width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(S.of(context).changeEntry,
                                        style: GoogleFonts.lexend(
                                          fontSize: 30,
                                          color: Color(0xff336699),
                                        )),
                                  ],
                                )),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Dashboard();
                        }));
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xff336699), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(S.of(context).dashboard,
                                style: GoogleFonts.lexend(
                                  fontSize: 30,
                                  color: Color(0xff336699),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    ));
  }
}
