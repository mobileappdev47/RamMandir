import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/EntryPage.dart';
import '../pages/Parking_page.dart';
import '../pages/dailyreport.dart';
import '../pages/globalProvider.dart';
import '../pages/outticket.dart';
import '../pages/registeration.dart';

import '../pages/userresponse.dart';
import '../utils/color.dart';

class DrawWidget extends StatefulWidget {
  const DrawWidget({super.key});

  @override
  State<DrawWidget> createState() => _DrawWidgetState();
}

class _DrawWidgetState extends State<DrawWidget> {
  List<String> texts = [
    'Home',
    'Out Ticket',
    'Season Ticket',
    'About Us',
    'FeedBack',
    'Daily Report',
    'LogOut'
  ];
  List<bool> isHighlighted = [true, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    return Drawer(
      width: 230,
      backgroundColor: Colors.white,
      child: Center(
        child: Column(children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              'assets/rammandirlogo-removebg-preview.png',
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: texts.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      for (int i = 0; i < isHighlighted.length; i++) {
                        setState(() {
                          set.setglobaldata('menuIndex', index);
                        });
                      }
                      if (get.getglobaldata['menuIndex'] == 0) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Parkingpage()),
                        );
                      }
                      if (get.getglobaldata['menuIndex'] == 1) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OutTicket()),
                        );
                      }
                      if (get.getglobaldata['menuIndex'] == 2) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MonthyRegister()),
                        );
                      }
                      if (get.getglobaldata['menuIndex'] == 3) {
                        try {
                          launchUrl(Uri.parse(
                              'http://accountsandtaxminers.com/Seuic_Handheld_Terminal.aspx'));
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      }
                      if (get.getglobaldata['menuIndex'] == 4) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserResponse()),
                        );
                      }
                      if (get.getglobaldata['menuIndex'] == 5) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DailyReport()),
                        );
                      }

                      if (get.getglobaldata['menuIndex'] == 6) {
                        Navigator.pop(context);
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Exit',
                                  style: TextStyle(color: Colors.black)),
                              content: const Text(
                                'Are you want Exit ?',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: appBackgroundColor,
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('No',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: red,
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Yes',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Entrypoint()),
                                    );
                                    set.setglobaldata('menuIndex', 0);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      color: get.getglobaldata['menuIndex'] == index
                          ? appBackgroundColor
                          : Colors.transparent,
                      child: ListTile(
                        title: Text(texts[index],
                            style: TextStyle(
                                color: get.getglobaldata['menuIndex'] == index
                                    ? Colors.white
                                    : Colors.black)),
                      ),
                    ),
                  );
                }),
          ),
          Container(
              color: Colors.transparent,
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("App Version:- ",
                        style: TextStyle(color: Colors.grey)),
                    Text("12.0.0", style: TextStyle(color: Colors.grey)),
                  ]))
        ]),
      ),
    );
  }
}
