import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:schichtbuch_shift/pages/login/index.dart';
import 'package:schichtbuch_shift/pages/mode/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    final String? userName = prefs.getString('user_name');
    runApp(Router(token: token, userName: userName));
  } catch (e) {
    // Handle errors appropriately
    runApp(Router(token: null, userName: null));
  }
}

class Router extends StatelessWidget {
  final String? token;
  final String? userName;
  Router({required this.token, required this.userName});
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
      initialRoute: token == null ? '/login' : '/choose-mode',
      routes: {
        '/login': (context) => Login(),
        '/choose-mode': (context) => ChooseMode(
              keyToken: token,
              user: userName,
            )
      },
    );
  }
}
