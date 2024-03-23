import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/color.dart';
import 'globalProvider.dart';

class FerryPage extends StatefulWidget {
  const FerryPage({super.key});

  @override
  State<FerryPage> createState() => _FerryPageState();
}

class Choice {
  const Choice(
      {required this.title,
      required this.rate,
      required this.person,
      required this.image});
  final String title;
  final int rate;
  final String person;
  final String image;
}

const List<Choice> choices = <Choice>[
  Choice(image: 'assets/car.png', title: 'Car', rate: 40, person: ""),
  Choice(image: 'assets/bycicle.png', title: 'Bike', rate: 80, person: ""),
  Choice(image: 'assets/tempo.png', title: 'Tempo', rate: 90, person: ""),
  Choice(image: 'assets/person.png', title: 'Person', rate: 10, person: ""),
];

const MethodChannel channel = MethodChannel('com.imin.printerlib');

class _FerryPageState extends State<FerryPage> {
  ValueNotifier<String> stateNotifier = ValueNotifier("");

  TextEditingController vehicalNumberController = TextEditingController();
  String type = '';
  int amount = 0;
  int noPerson = 0;
  int checkIndex = -1;
  String datenow = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String timenow = DateFormat('HH:mm:ss').format(DateTime.now());
  bool selected = false;
  bool hidebox = false;
  String dropdownvalue = 'MH';

  var items = [
    'MH',
    'GJ',
    'MP',
    'RJ',
    'PB',
    'UK',
    'AN',
  ];

  @override
  void initState() {
    generateTikcetNo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var set = context.read<GlobalProvider>();
    var get = context.watch<GlobalProvider>();
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xffFAF9F6),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Ferry Ticket"),
          actions: [
            GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Expanded(
                      child: AlertDialog(
                        title: const Text('Exit!',
                            style: TextStyle(color: Colors.black)),
                        content: const Text('Are you Sure'),
                        actions: [
                          GestureDetector(
                              onTap: () {
                                Feedback.forTap(context);
                                Navigator.pushNamed(context, '/choicetype');
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: appBackgroundColor,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
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
                                      color: red,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                    child: Text(
                                      "No",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )))
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.logout),
              ),
            )
          ],
        ),
        drawer: const Drawer(
          child: Column(
            children: [Text("Menu")],
          ),
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Vehical Type:$type',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'No Of Person:$noPerson' 'x' '10\u{20B9}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 08),
                  child: Text(
                    '\u{20B9}$amount ',
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                        color: appBackgroundColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          value: dropdownvalue,
                          dropdownColor: appBackgroundColor,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(items),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                if (get.getglobaldata['hideField'] ?? true)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        height: 40,
                        width: 100,
                        child: TextField(
                          controller: vehicalNumberController,
                          enableInteractiveSelection: false,
                          focusNode: FocusNode(),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter 4 Digit",
                              hintStyle: TextStyle(fontSize: 12),
                              counterText: ""),
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (vehicalNumberController.text.isEmpty) {
                            var snackBar = SnackBar(
                              backgroundColor: red,
                              content: const Text('Enter Vehicle Number'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (type.isEmpty) {
                            var snackBar = SnackBar(
                              backgroundColor: red,
                              content: const Text('Select Vehicle'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(08)),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/paymentMode',
                                                arguments: {
                                                  'exampleArgument':
                                                      'dynamicLink'
                                                },
                                              );
                                              sendTicket();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.green[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              08)),
                                                  child: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 100,
                                                        right: 100,
                                                        top: 20,
                                                        bottom: 20),
                                                    child: Text("Dynamic Link"),
                                                  )),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/paymentMode',
                                                arguments: {
                                                  'exampleArgument':
                                                      'cashButtom'
                                                },
                                              );
                                              sendTicket();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.yellow[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              08)),
                                                  child: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 100,
                                                        right: 100,
                                                        top: 20,
                                                        bottom: 20),
                                                    child:
                                                        Text("  Cash Mode  "),
                                                  )),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/paymentMode',
                                                arguments: {
                                                  'exampleArgument': 'barcode'
                                                },
                                              );
                                              sendTicket();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              08)),
                                                  child: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 100,
                                                        right: 100,
                                                        top: 20,
                                                        bottom: 20),
                                                    child: Text("Qrcode Mode"),
                                                  )),
                                            ),
                                          ),
                                        ]),
                                  );

                                  /* Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: 
                                                        Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator
                                                                      .pushNamed(
                                                                    context,
                                                                    '/paymentMode',
                                                                    arguments: {
                                                                      'exampleArgument':
                                                                          'dynamicLink'
                                                                    },
                                                                  );
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.green[300],
                                                                              borderRadius: BorderRadius.circular(08)),
                                                                          child: const Padding(
                                                                            padding: EdgeInsets.only(
                                                                                left: 50,
                                                                                right: 50,
                                                                                top: 20,
                                                                                bottom: 20),
                                                                            child:
                                                                                Text("Dynamic Link"),
                                                                          )),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator
                                                                      .pushNamed(
                                                                    context,
                                                                    '/paymentMode',
                                                                    arguments: {
                                                                      'exampleArgument':
                                                                          'cashButtom'
                                                                    },
                                                                  );
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.yellow[300],
                                                                              borderRadius: BorderRadius.circular(08)),
                                                                          child: const Padding(
                                                                            padding: EdgeInsets.only(
                                                                                left: 50,
                                                                                right: 50,
                                                                                top: 20,
                                                                                bottom: 20),
                                                                            child:
                                                                                Text("  Cash Mode  "),
                                                                          )),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator
                                                                      .pushNamed(
                                                                    context,
                                                                    '/paymentMode',
                                                                    arguments: {
                                                                      'exampleArgument':
                                                                          'barcode'
                                                                    },
                                                                  );
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                          decoration: BoxDecoration(
                                                                              color: red,
                                                                              borderRadius: BorderRadius.circular(08)),
                                                                          child: const Padding(
                                                                            padding: EdgeInsets.only(
                                                                                left: 50,
                                                                                right: 50,
                                                                                top: 20,
                                                                                bottom: 20),
                                                                            child:
                                                                                Text("Qrcode Mode"),
                                                                          )),
                                                                ),
                                                              ),
                                                            ]),
                                                      ); */
                                });
                          }
                        },
                        child: const Text("Next")))
              ],
            ),
            Flexible(
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: false,
                  scrollDirection: Axis.vertical,
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          checkIndex = index;
                          type = choices[index].title.toString();
                          amount = choices[index].rate;
                          noPerson = 0;
                          if (checkIndex == 3) noPerson++;
                          selected = true;
                          set.setglobaldata('hideField', true);
                          if (checkIndex == 3) {
                            set.setglobaldata('hideField', false);
                          }
                          set.setglobaldata('ferryamount', amount);
                          vehicalNumberController.clear();
                        });
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(08),
                          side: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: checkIndex == index
                                  ? appBackgroundColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(08)),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 08,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    choices[index].image,
                                    width: 60,
                                  ),
                                  const SizedBox(
                                    width: 08,
                                  ),
                                  Text(
                                    choices[index].title.toString(),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                '\u{20B9}${choices[index].rate}',
                                style: const TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (checkIndex == index) {
                                            setState(() {
                                              if (noPerson > 0) {
                                                amount =
                                                    amount - choices[3].rate;
                                                noPerson--;
                                              }
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                        color: Colors.black,
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      )),
                                  if (checkIndex == index)
                                    Text(
                                      noPerson.toString(),
                                      style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (checkIndex == index) {
                                            amount = amount + choices[3].rate;
                                            noPerson++;
                                          }
                                        });
                                      },
                                      child: Container(
                                        color: Colors.black,
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      )),
                                ],
                              ),
                              const Text(
                                "Person",
                                style: TextStyle(fontSize: 8),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendTicket() async {
    var get = Provider.of<GlobalProvider>(context, listen: false);
    final jsonResquest = jsonEncode({
      'Ticket_No': get.getglobaldata['ticketNo'],
      'Section_Name': get.getglobaldata['appbarTitle'],
      'Category_Name': type,
      'Vehicle_No': dropdownvalue + vehicalNumberController.text.toString(),
      'Vehicle_Rate': amount,
      'Payment_Mode': get.getglobaldata['paymentMode'],
      'User_Id': 'null',
      'QR_Code': 'null',
      'Computer_Name': 'Android',
      'Company_Id': 1,
      'Adult_Number': noPerson,
      'Print_Flag': get.getglobaldata['printFlag']
    });
    await http.post(
        Uri.parse('$baseUrl/Parking_WebService1.asmx/InsertCartDetatils'),
        body: jsonResquest,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        });
    generateTikcetNo();
  }

  Future<void> generateTikcetNo() async {
    var set = context.read<GlobalProvider>();
    var response = await http.post(
        Uri.parse('$baseUrl/Parking_WebService1.asmx/getBillNumber'),
        body: jsonEncode({}),
        headers: {
          "Accept": "application/json",
        });
    if (response.statusCode == 200) {
      var ticketNo = jsonDecode(response.body);
      set.setglobaldata('ticketNo', ticketNo['Message'][0]['PurchaseNo']);
    }
    stateNotifier.value = await channel.invokeMethod("sdkInit");
  }
}
