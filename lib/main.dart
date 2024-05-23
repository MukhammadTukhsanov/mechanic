import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:schichtbuch_shift/pages/comment/index.dart';
import 'package:schichtbuch_shift/pages/dashboard/index.dart';
import 'package:schichtbuch_shift/pages/edit-info/index.dart';
import 'package:schichtbuch_shift/pages/edit/index.dart';
import 'package:schichtbuch_shift/pages/home/index.dart';
import 'package:schichtbuch_shift/pages/login/index.dart';
import 'package:schichtbuch_shift/pages/mode/index.dart';
import 'package:schichtbuch_shift/pages/splash-screen/index.dart';

import 'package:http/http.dart' as http;

import 'generated/l10n.dart';

void main() {
  runApp(Router());
}

class Router extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      locale: Locale('de'),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        // '/login': (context) => EditInfo(),
        // '/splash': (context) => SplashScreen(),
        // '/login': (context) => CommentPage(),
        // '/login': (context) => Dashboard(),
        // '/login': (context) => HomePage(),
        '/login': (context) => Login(),
        // '/chooseMode': (context) => ChooseMode(),
        // '/login': (context) => EditPage(),
      },
    );
  }
}
