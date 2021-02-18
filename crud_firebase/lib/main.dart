import 'package:crud_firebase/routes/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'A ordem',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          secondaryHeaderColor: Colors.blueGrey,
          accentColor: Colors.cyan[600],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'roboto',
        ),
        initialRoute: HomePage.tag,
        routes: {
          HomePage.tag: (context) => HomePage(),
        });
  }
}
