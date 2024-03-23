import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketingapp/pages/payment.dart';
import 'package:ticketingapp/utils/color.dart';
import 'pages/EntryPage.dart';
import 'pages/FerryPage.dart';
import 'pages/Parking_page.dart';
import 'pages/dailyreport.dart';
import 'pages/globalProvider.dart';
import 'pages/loginpage.dart';
import 'pages/outticket.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => GlobalProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Indore Smart City',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        fontFamily: 'RobotoMono',
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
        appBarTheme: AppBarTheme(
          color: appBackgroundColor,
          iconTheme: const IconThemeData(color: Colors.white),
          actionsIconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 57.0, fontFamily: 'RobotoMono'),
            displayMedium: TextStyle(fontSize: 45.0, fontFamily: 'RobotoMono'),
            displaySmall: TextStyle(
                fontSize: 18.0, fontFamily: 'RobotoMono', color: Colors.black),
            labelSmall: TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoMono',
            ),
            titleLarge: TextStyle(
                fontSize: 22.0, fontFamily: 'RobotoMono', color: Colors.white),
            titleMedium: TextStyle(
                fontSize: 16,
                fontFamily: 'RobotoMono',
                color: Colors.black,
                fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(fontSize: 18.0, fontFamily: 'RobotoMono'),
            headlineSmall: TextStyle(fontSize: 18.0, fontFamily: 'RobotoMono'),
            titleSmall: TextStyle(
              fontSize: 12.0,
              fontFamily: 'RobotoMono',
              color: Colors.black87,
            ),
            labelLarge: TextStyle(fontSize: 18.0, fontFamily: 'RobotoMono'),
            labelMedium: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                fontFamily: 'RobotoMono',
                color: Colors.white),
            bodyLarge: TextStyle(fontSize: 18.0, fontFamily: 'RobotoMono'),
            bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'RobotoMono'),
            bodySmall: TextStyle(fontSize: 12.0, fontFamily: 'RobotoMono')),
        buttonTheme: ButtonThemeData(
          buttonColor: red,
          shape: const RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.accent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: appBackgroundColor,
              fixedSize: const Size(80, 30)),
        ),
      ),
      home: const Entrypoint(),
      routes: {
        '/choicetype': (context) => const Entrypoint(),
        '/loginpage': (context) => const Loginpage(),
        '/homepage': (context) => const Parkingpage(),
        '/ferry': (context) => const FerryPage(),
        '/report': (context) => const DailyReport(),
        '/paymentMode': (context) => const PaymentMode(),
        '/OutTicket': (content) => const OutTicket(),
      },
    );
  }
}
