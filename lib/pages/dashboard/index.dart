import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/generated/l10n.dart';
import 'package:flutter_nfc_kit_example/global/index.dart';
import 'package:flutter_nfc_kit_example/pages/dashboard/header.dart';
import 'package:flutter_nfc_kit_example/pages/mode/index.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(S.of(context).addEntry,
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
                          return ChooseMode();
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
        body: SafeArea(
          child: Column(
            children: [DashboardHeader()],
          ),
        ));
  }
}
