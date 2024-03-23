import 'package:flutter/material.dart';
import 'loginmobile.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(231, 250, 249, 246),
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(231, 250, 249, 246),
          elevation: 0,
          /* iconTheme: const IconThemeData(
            color: Colors.blue,
          ), */
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return const LoginMobile();
            } else if (constraints.maxWidth > 600 &&
                constraints.maxWidth < 900) {
              return const LoginMobile();
            } else {
              return const LoginMobile();
            }
          },
        ));
  }
}
