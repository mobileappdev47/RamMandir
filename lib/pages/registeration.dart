import 'dart:convert';
import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticketingapp/constants/constant.dart';
import 'package:ticketingapp/pages/globalProvider.dart';
import 'package:ticketingapp/utils/color.dart';

List<String> monthList = <String>[
  'Select Your Plan',
  'Monthly',
  'Quaterly',
  'Half Yearly',
  'Yearly'
];

class MonthyRegister extends StatefulWidget {
  const MonthyRegister({super.key});

  @override
  State<MonthyRegister> createState() => _MonthyRegisterState();
}

enum Animals { car, bike, bus }

enum Payment { online, cash }

var channel = const MethodChannel('com.imin.printerlib');

class _MonthyRegisterState extends State<MonthyRegister> {
  ValueNotifier<String> stateNotifier = ValueNotifier("");
  String dropdownvalue = monthList.first;
  DateTime selectedDate = DateTime.now();
  TextEditingController firstselectDate = TextEditingController();
  TextEditingController secondselectDate = TextEditingController();
  TextEditingController epcController = TextEditingController();
  TextEditingController carNumber = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  int amount = 0;
  int total = 0;
  int? planDay;
  String? planMonths;
  bool checkedValue = false;
  bool changeKeyboard = false;
  bool endCarnumber = false;
  FocusNode inputNode = FocusNode();
  Animals? animal = Animals.car;
  Payment? payment = Payment.online;
  String? controllerNumber;
  bool loader = false;
  List passDeta = [];

  Future<void> _startselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        firstselectDate.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  Future<void> vidanicontrol() async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('http://ac.vidaniautomations.com/cmd'));
    request.body = json.encode({
      "serialNo": "1234",
      "cmd": {"type": "control", "id": 1, "key": 1, "value": 0}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      debugPrint(await response.stream.bytesToString());
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  void changePlan({required String changeplan}) {
    secondselectDate.clear();
    if (changeplan == 'Monthly') {
      DateTime after30Days = selectedDate.add(const Duration(days: 30));
      secondselectDate.text = DateFormat('dd-MM-yyyy ').format(after30Days);

      setState(() {
        total = amount + 300;
        planDay = 30;
        planMonths = 'Monthly';
      });
    } else if (changeplan == 'Quaterly') {
      DateTime after30Days = selectedDate.add(const Duration(days: 90));
      secondselectDate.text = DateFormat('dd-MM-yyyy').format(after30Days);
      setState(() {
        total = amount + 900;
        planDay = 90;
        planMonths = 'Quaterly';
      });
    } else if (changeplan == 'Half Yearly') {
      DateTime after30Days = selectedDate.add(const Duration(days: 180));
      secondselectDate.text = DateFormat('dd-MM-yyyy').format(after30Days);
      setState(() {
        total = amount + 1800;
        planDay = 180;
        planMonths = 'Half Yearly';
      });
    } else if (changeplan == 'Yearly') {
      DateTime after30Days = selectedDate.add(const Duration(days: 365));
      secondselectDate.text = DateFormat('dd-MM-yyyy').format(after30Days);
      setState(() {
        total = amount + 3600;
        planDay = 365;
        planMonths = 'Yearly';
      });
    }
  }

  Future<void> getControllerNoDetails() async {
    setState(() {
      loader = true;
    });
    var response =
        await http.get(Uri.parse("$baseUrl1/getControllerNoDetails"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == '1') {
        setState(() {
          controllerName.text = data['body'][0]['serialNo'];
          loader = false;
        });
      } else {
        var snackBar = const SnackBar(
          content: Text(''''System did't get Controller Number '''),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        );
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      var snackBar = const SnackBar(
        content: Text('Something Error From Server'),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      );
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> getDataBasedOnControllerNo() async {
    setState(() {
      loader = true;
    });
    String controller = controllerName.text;
    var response = await http.get(Uri.parse(
        "$baseUrl1/getDataBasedOnControllerNo?controllerNo=$controller"));
    if (response.statusCode == 200) {
      if (controllerName.text.isNotEmpty) {
        var data = jsonDecode(response.body);
        if (data['status'] == '1') {
          setState(() {
            epcController.text = data['body'][0]['EPCNumber'];
            loader = false;
          });
        } else {
          var snackBar = const SnackBar(
            content: Text('No Controller Number Found'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          );
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        var snackBar = const SnackBar(
          content: Text('Something Error From Server'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        );
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> sessionPassParkingTicket() async {
    var get = Provider.of<GlobalProvider>(context, listen: false);
    var companyNumber = get.getglobaldata['companyNumber'];
    var deviceId = get.getglobaldata['uniqueId'];
    var response = await http.get(Uri.parse(
        "$baseUrl1/Get_SessionPassParkingTicket?Company_Id=$companyNumber&Device_Id=$deviceId"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == '1') {
        setState(() {
          passDeta = data['body'][0];
        });
      } else {
        var snackBar = const SnackBar(
          content: Text('Something Error From Server'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        );
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void cleanTextField() {
    epcController.clear();
    carNumber.clear();
    firstselectDate.clear();
    secondselectDate.clear();
    controllerName.clear();
    carNumber.clear();
    total = 0;
    endCarnumber = false;
    monthList.first;
  }

  Future<void> insertVehicleRegistrationDetatil() async {
    var get = Provider.of<GlobalProvider>(context, listen: false);
    var companyNumber = get.getglobaldata['companyNumber'];
    var epcControllerNo = epcController.text;
    var carNumberNo = carNumber.text;
    var firstselectDateNO =
        DateFormat('dd-MM-yyyy').parse(firstselectDate.text);
    var secondselectDateNO =
        DateFormat('dd-MM-yyyy').parse(secondselectDate.text);
    var controllerNameNO = controllerName.text;
    var vehicletype = animal.toString().replaceAll("Animals.", "");
    var deviceId = get.getglobaldata['uniqueId'];
    var response = await http.get(Uri.parse(
        "$baseUrl1/InsertVehicleRegistrationDetatil?vehicleType=$vehicletype&vehicleNo=$carNumberNo&EPCNo=$epcControllerNo&controllerNo=$controllerNameNO&startDate=$firstselectDateNO&durationPlan=$planMonths&durationDays=$planDay&endDate=$secondselectDateNO&paymentMode=$payment&amount=$total&Device_Id=$deviceId&Company_Id=$companyNumber"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "1") {
        sessionPassParkingTicket();
        Future.delayed(const Duration(milliseconds: 300));
        var snackBar = const SnackBar(
          content: Text('Successfully registeration'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        );
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
        getControllerNoDetails();
        cleanTextField();
        setState(() {
          loader = false;
        });
        getOpen();
        await channel.invokeMethod("method");
      } else {
        var snackBar = const SnackBar(
          content: Text('Not Register'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        );
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> getOpen() async {
    var get = Provider.of<GlobalProvider>(context, listen: false);
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('http://ac.vidaniautomations.com/cmd'));
    request.body = json.encode({
      "serialNo": get.getglobaldata['controllerId'],
      "cmd": {"type": "control", "id": 1, "key": 1, "value": 1}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      debugPrint(await response.stream.bytesToString());
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();
    getControllerNoDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Season Pass Registration",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Controller No",
                                style: Theme.of(context).textTheme.titleMedium),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextField(
                                controller: controllerName,
                                readOnly: true,
                                cursorColor: Colors.black,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    fillColor: Color(0xffE0E0E0),
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xffE0E0E0))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xffE0E0E0))),
                                    hintStyle: TextStyle(fontSize: 14),
                                    counterText: ""),
                              ),
                            ),
                            Text("EPC Number",
                                style: Theme.of(context).textTheme.titleMedium),
                            InputField(
                              controller: epcController,
                              hintText: "EPC Number",
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    getDataBasedOnControllerNo();
                                  },
                                  child: const Icon(Icons.download)),
                            ),
                            Text("Vehicle Number",
                                style: Theme.of(context).textTheme.titleMedium),
                            TextField(
                              controller: carNumber,
                              maxLength: 13,
                              focusNode: inputNode,
                              readOnly: endCarnumber ? true : false,
                              autofocus: changeKeyboard ? true : false,
                              keyboardType: changeKeyboard
                                  ? TextInputType.number
                                  : TextInputType.name,
                              onChanged: (String value) {
                                if (value.length == 2) {
                                  carNumber.text =
                                      "${carNumber.text}-".toUpperCase();
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    changeKeyboard = true;
                                  });
                                } else if (value.length == 5) {
                                  carNumber.text =
                                      "${carNumber.text}-".toUpperCase();
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    changeKeyboard = false;
                                  });
                                } else if (value.length == 8) {
                                  carNumber.text =
                                      "${carNumber.text}-".toUpperCase();
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    changeKeyboard = true;
                                  });
                                } else if (value.length == 13) {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    endCarnumber = true;
                                    changeKeyboard = false;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 0),
                                  fillColor: const Color(0xffE0E0E0),
                                  suffixIcon: endCarnumber
                                      ? GestureDetector(
                                          onTap: () {
                                            carNumber.clear();
                                            setState(() {
                                              endCarnumber = false;
                                            });
                                          },
                                          child: const Icon(Icons.cancel))
                                      : const SizedBox(),
                                  filled: true,
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Color(0xffE0E0E0))),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Color(0xffE0E0E0))),
                                  hintText: "Enter Your Vehicle Number",
                                  hintStyle: const TextStyle(fontSize: 14),
                                  counterText: ""),
                            ),
                            Text("Select Vehicle Type",
                                style: Theme.of(context).textTheme.titleMedium),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: const Text('Car'),
                                  leading: Radio<Animals>(
                                    activeColor: Colors.blue,
                                    value: Animals.car,
                                    groupValue: animal,
                                    onChanged: (Animals? value) {
                                      setState(() {
                                        animal = value;
                                      });
                                    },
                                  ),
                                )),
                                Expanded(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: const Text('Bike'),
                                    leading: Radio<Animals>(
                                      activeColor: Colors.blue,
                                      value: Animals.bike,
                                      groupValue: animal,
                                      onChanged: (Animals? value) {
                                        setState(() {
                                          animal = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: const Text('Bus'),
                                    leading: Radio<Animals>(
                                      activeColor: Colors.blue,
                                      value: Animals.bus,
                                      groupValue: animal,
                                      onChanged: (Animals? value) {
                                        setState(() {
                                          animal = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text("Start Date",
                                style: Theme.of(context).textTheme.titleMedium),
                            InputField(
                                controller: firstselectDate,
                                hintText: "Select Date",
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      _startselectDate(context);
                                    },
                                    child: const Icon(Icons.calendar_month))),
                            Text("Select Your Plan",
                                style: Theme.of(context).textTheme.titleMedium),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffE0E0E0),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(8),
                              height: 44,
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                value: dropdownvalue,
                                icon: const Icon(Icons.arrow_downward),
                                dropdownColor: Colors.grey,
                                elevation: 16,
                                style: const TextStyle(color: Colors.grey),
                                underline: Container(
                                  height: 2,
                                  color: Colors.white,
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    dropdownvalue = value!;
                                    changePlan(changeplan: dropdownvalue);
                                  });
                                },
                                items: monthList.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: const TextStyle(
                                            color: Colors.black)),
                                  );
                                }).toList(),
                              )),
                            ),
                            Text("End Date",
                                style: Theme.of(context).textTheme.titleMedium),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextField(
                                controller: secondselectDate,
                                readOnly: true,
                                cursorColor: Colors.black,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    fillColor: Color(0xffE0E0E0),
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xffE0E0E0))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xffE0E0E0))),
                                    hintText: "End Date",
                                    hintStyle: TextStyle(fontSize: 14),
                                    counterText: ""),
                              ),
                            ),
                            Text("Payment Mode",
                                style: Theme.of(context).textTheme.titleMedium),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: const Text('Online'),
                                  leading: Radio<Payment>(
                                    activeColor: Colors.blue,
                                    value: Payment.online,
                                    groupValue: payment,
                                    onChanged: (Payment? value) {
                                      setState(() {
                                        payment = value;
                                      });
                                      debugPrint(animal!.name);
                                    },
                                  ),
                                )),
                                Expanded(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: const Text('Cash'),
                                    leading: Radio<Payment>(
                                      activeColor: Colors.blue,
                                      value: Payment.cash,
                                      groupValue: payment,
                                      onChanged: (Payment? value) {
                                        setState(() {
                                          payment = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text("Amount:- $total",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ),
                            ),
                            /* SizedBox(
                              width: double.maxFinite,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(0)),
                                      backgroundColor: Colors.blue),
                                  onPressed: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Confirm",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 18)),
                                        Icon(Icons.arrow_forward,
                                            color: Colors.white)
                                      ],
                                    ),
                                  ))), */
                          ],
                        ),
                      ]),
                ),
              ),
              /* showTicket
                  ? passDeta.isNotEmpty
                      ? Container(
                          color: Colors.black.withOpacity(0.8),
                          child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 150, horizontal: 30),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: Image.network(
                                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhIBq1E6gySfBjXjcl691QvEm_aeFVCQOmUEv9aF1HfA&s"),
                                          ),
                                          const SizedBox(
                                            width: 18,
                                          ),
                                          Text("Indore Smart City",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge)
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Ticket No:",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                            passDeta[0]['Ticket_No'].toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Vehicle No:",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                            passDeta[0]['VehicleNo'].toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Vehicle Type:",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                            passDeta[0]['vehicleType']
                                                .replaceAll("Animals.", ""),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Start Date",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                            passDeta[0]['Enterdate'].toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "End Date",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                            passDeta[0]['validateDate']
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Amount",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(passDeta[0]['amount'].toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "CarName",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text("MH-23-HB-3030",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                showTicket = false;
                                              });
                                            },
                                            child: const Text("Done"))
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        )
                      : showTicket
                          ? const Center(
                              child:
                                  CircularProgressIndicator(color: Colors.blue))
                          : const SizedBox()
                  : const SizedBox() */
              loader
                  ? Container(
                      color: Colors.black.withOpacity(0.6),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                                color: appBackgroundColor),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text("I am trying to capture !",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.small(
                backgroundColor: appBackgroundColor,
                onPressed: () async {
                  if (epcController.text.isNotEmpty &&
                      carNumber.text.isNotEmpty &&
                      firstselectDate.text.isNotEmpty &&
                      secondselectDate.text.isNotEmpty &&
                      controllerName.text.isNotEmpty &&
                      carNumber.text.isNotEmpty) {
                    insertVehicleRegistrationDetatil();
                  } else {
                    var snackBar = const SnackBar(
                      content: Text('Please Provide All Details'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text("Pay Now $total ₹",
                    style: const TextStyle(color: Colors.white, fontSize: 18))),
          ),
        ));
  }
}

class CarNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text =
        newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

    if (text.length <= 2) {
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    } else if (text.length <= 4) {
      return TextEditingValue(
        text: '${text.substring(0, 2)}${text.substring(2)}',
        selection: TextSelection.collapsed(offset: text.length),
      );
    } else if (text.length <= 7) {
      return TextEditingValue(
        text:
            '${text.substring(0, 2)} ${text.substring(2, 4)} ${text.substring(4)}',
        selection: TextSelection.collapsed(offset: text.length + 2),
      );
    } else {
      return TextEditingValue(
        text:
            '${text.substring(0, 2)} ${text.substring(2, 4)} ${text.substring(4, 7)} ${text.substring(7, min(text.length, 10))}',
        selection: TextSelection.collapsed(offset: text.length + 3),
      );
    }
  }

  void showSnackbar(context,
      {String? message,
      Color? color,
      Color? letftbarColor,
      Widget? icon}) async {
    await Flushbar(
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      message: message,
      backgroundColor: color ?? Colors.transparent,
      leftBarIndicatorColor: letftbarColor ?? Colors.transparent,
      barBlur: 20,
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: icon,
      isDismissible: false,
    ).show(context);
  }
}

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    this.hintText,
    this.keyboardType,
    this.maxLines,
    this.controller,
    this.maxLength,
    this.onTap,
    this.onChanged,
    this.enabled,
    this.prefixIcon,
    this.suffixIcon,
  });
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final TextEditingController? controller;
  final int? maxLength;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final bool? enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            enabled: enabled,
            controller: controller,
            cursorColor: Colors.black,
            maxLines: maxLines,
            maxLength: maxLength,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                fillColor: const Color(0xffE0E0E0),
                filled: true,
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xffE0E0E0))),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xffE0E0E0))),
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 14),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                counterText: ""),
            keyboardType: keyboardType,
            onTap: onTap,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
