import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unique_identifier/unique_identifier.dart';
import '../constants/constant.dart';
import '../utils/color.dart';
import 'globalProvider.dart';

class Entrypoint extends StatefulWidget {
  const Entrypoint({super.key});

  @override
  State<Entrypoint> createState() => _EntrypointState();
}

class _EntrypointState extends State<Entrypoint> {
  @override
  void initState() {
    super.initState();
    initUniqueIdentifierState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    var set = context.read<GlobalProvider>();
    Future.delayed(const Duration(seconds: 3), () {
      Feedback.forTap(context);
      set.setglobaldata('appbarTitle', 'Mall In System');

      Navigator.popAndPushNamed(
        context,
        '/loginpage',
      );

      // setState(() {
      //   // Here you can write your code for open new view
      // });

    });
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> initUniqueIdentifierState() async {
    var set = context.read<GlobalProvider>();
    String? identifier;
    try {
      identifier = await UniqueIdentifier.serial;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }
    if (!mounted) return;
    setState(() {
      set.setglobaldata('uniqueId', identifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    var set = context.read<GlobalProvider>();

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*  Container(
              width: 300.0, // Width of the circular container
              height: 300.0, // Height of the circular container
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.teal, // Color of the circular container
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/parking-car.png',
                      width: 120,
                    ),
                    const Text(
                      'Indore Smart City', // Text to be displayed at the center
                      style: TextStyle(
                        color: Colors.white, // Color of the text
                        fontSize: 30.0, // Font size of the text
                      ),
                    ),
                  ],
                ),
              ),
            ), */
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Image.asset(
                'assets/rammandirlogo-removebg-preview.png',
              ),
            ),
            // Column(
            //   children: [
            //     /* Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         GestureDetector(
            //           onTap: () {
            //             Feedback.forTap(context);
            //             Navigator.pushNamed(
            //               context,
            //               '/loginpage',
            //             );
            //             set.setglobaldata('appbarTitle', 'Parking System');
            //           },
            //           child: SizedBox(
            //             width: 120,
            //             height: 180,
            //             child: Container(
            //                 decoration: BoxDecoration(
            //                     color: appBackgroundColor,
            //                     border:
            //                         Border.all(color: Colors.black, width: 02),
            //                     borderRadius: BorderRadius.circular(08)),
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Image.asset(
            //                       "assets/car.png",
            //                       width: 80,
            //                     ),
            //                     Text("Parking",
            //                         style:
            //                             Theme.of(context).textTheme.titleLarge),
            //                   ],
            //                 )),
            //           ),
            //         ),
            //         const SizedBox(
            //           width: 24,
            //         ),
            //         GestureDetector(
            //           onTap: () {
            //             Feedback.forTap(context);
            //             Navigator.pushNamed(context, '/loginpage');
            //             set.setglobaldata('appbarTitle', 'Ferry System');
            //           },
            //           child: SizedBox(
            //             width: 120,
            //             height: 180,
            //             child: Container(
            //                 decoration: BoxDecoration(
            //                     color: appBackgroundColor,
            //                     border:
            //                         Border.all(color: Colors.black, width: 02),
            //                     borderRadius: BorderRadius.circular(08)),
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Image.asset(
            //                       'assets/ship.png',
            //                       width: 80,
            //                     ),
            //                     Text(
            //                       "Ferry",
            //                       style: Theme.of(context).textTheme.titleLarge,
            //                     ),
            //                   ],
            //                 )),
            //           ),
            //         ),
            //       ],
            //     ),
            //     const CommonHeight(), */
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         GestureDetector(
            //           onTap: () {
            //             Feedback.forTap(context);
            //             Navigator.pushNamed(
            //               context,
            //               '/loginpage',
            //             );
            //             set.setglobaldata('appbarTitle', 'Mall In System');
            //           },
            //           child: SizedBox(
            //             width: 130,
            //             height: 160,
            //             child: Container(
            //                 decoration: BoxDecoration(
            //                     color: appBackgroundColor,
            //                     border:
            //                         Border.all(color: Colors.black, width: 02),
            //                     borderRadius: BorderRadius.circular(08)),
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Image.asset(
            //                       'assets/car.png',
            //                       width: 80,
            //                     ),
            //                     const SizedBox(height: 08),
            //                     Text(
            //                       "Parking In",
            //                       style: Theme.of(context).textTheme.titleLarge,
            //                     ),
            //                   ],
            //                 )),
            //           ),
            //         ),
            //         const SizedBox(
            //           width: 24,
            //         ),
            //         GestureDetector(
            //           onTap: () {
            //             Feedback.forTap(context);
            //             Navigator.pushNamed(
            //               context,
            //               '/loginpage',
            //             );
            //             set.setglobaldata('appbarTitle', 'Mall Out System');
            //           },
            //           child: SizedBox(
            //             width: 130,
            //             height: 160,
            //             child: Container(
            //                 decoration: BoxDecoration(
            //                     color: appBackgroundColor,
            //                     border:
            //                         Border.all(color: Colors.black, width: 02),
            //                     borderRadius: BorderRadius.circular(08)),
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Image.asset('assets/car.png', width: 80),
            //                     const SizedBox(height: 08),
            //                     Text(
            //                       "Parking Out",
            //                       style: Theme.of(context).textTheme.titleLarge,
            //                     ),
            //                   ],
            //                 )),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            Text(
              "Version: $version",
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class DialogBox extends StatelessWidget {
  const DialogBox({
    super.key,
    required this.header,
    required this.label,
  });

  final String header;
  final String label;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(header),
      content: Text(label),
      actions: [
        GestureDetector(
            onTap: () {
              Feedback.forTap(context);
              exit(0);
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.white),
                  ),
                ))),
        GestureDetector(
            onTap: () {
              Feedback.forTap(context);
              Navigator.pop(context);
            },
            child: Container(
                decoration: BoxDecoration(
                    color: red, borderRadius: BorderRadius.circular(4)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Text(
                    "No",
                    style: TextStyle(color: Colors.white),
                  ),
                )))
      ],
    );
  }
}
