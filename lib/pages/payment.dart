// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';
import '../utils/color.dart';
import 'globalProvider.dart';

class PaymentMode extends StatefulWidget {
  const PaymentMode({super.key});

  @override
  State<PaymentMode> createState() => _PaymentModeState();
}

const MethodChannel channel = MethodChannel('com.imin.printerlib');

class _PaymentModeState extends State<PaymentMode> {
  ValueNotifier<String> stateNotifier = ValueNotifier("");
  TextEditingController paymentMobilenumber = TextEditingController();
  TextEditingController paymentcash = TextEditingController();
  String datenow = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String timenow = DateFormat('HH:mm:ss').format(DateTime.now());
  int charLength = 0;

  onChanged(String value) {
    setState(() {
      charLength = value.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
      appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back)),
          title: const Text("Receipt Information",
              style: TextStyle(fontSize: 20))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              /*  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: appBackgroundColor,
                      borderRadius: BorderRadius.circular(08)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Ticket Number",
                            style: Theme.of(context).textTheme.labelMedium),
                        Text(
                          get.getglobaldata['ticketNo'],
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ), */
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: appBackgroundColor,
                      borderRadius: BorderRadius.circular(08)),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Vehicle Number",
                          style: Theme.of(context).textTheme.labelMedium),
                      Text(
                        get.getglobaldata['selectState'].isEmpty
                            ? 'UP' + get.getglobaldata['numberplaterNumber']
                            : get.getglobaldata['selectState'] +
                            get.getglobaldata['numberplaterNumber'],
                        style:
                        const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: appBackgroundColor,
                      borderRadius: BorderRadius.circular(08)),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Vehicle Type",
                          style: Theme.of(context).textTheme.labelMedium),
                      Text(
                        get.getglobaldata['selectVehicle'],
                        style:
                        const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: appBackgroundColor,
                      borderRadius: BorderRadius.circular(08)),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("In-Date ",
                          style: Theme.of(context).textTheme.labelMedium),
                      Text(
                        '$datenow $timenow',
                        style:
                        const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              1 == 2
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: appBackgroundColor,
                      borderRadius: BorderRadius.circular(08)),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Amount",
                          style: Theme.of(context).textTheme.labelMedium),
                      Text(
                        '${get.getglobaldata['amount']} \u{20B9}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
                  : const SizedBox()
            ],
          ),
          arguments['exampleArgument'] == 'dynamicLink'
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: paymentMobilenumber,
                  onChanged: onChanged,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2,
                            color: appBackgroundColor), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2,
                            color: appBackgroundColor), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      hintText: "Enter Mobile Number",
                      hintStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      counterText: "",
                      prefixIcon:
                      const Icon(Icons.phone, color: Colors.black)),
                ),
                get.getglobaldata['inputerror']
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Enter a valid mobile number",
                    style: TextStyle(color: red),
                  ),
                )
                    : const SizedBox()
              ],
            ),
          )
              : const SizedBox(),
          /*  arguments['exampleArgument'] == 'cashButtom'
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                        child: TextField(
                          readOnly: true,
                          controller: paymentcash,
                          onChanged: onChanged,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: appBackgroundColor), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: appBackgroundColor), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            counterText: "",
                            hintText: /* arguments['exampleArgument'] == 'cashButtom'
                                ? get.getglobaldata['ferryamount'].toString()
                                : */
                                get.getglobaldata['amount'].toString(),
                            hintStyle: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                            prefixIcon: const Icon(Icons.money),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(), */
          /*  arguments['exampleArgument'] == 'barcode'
              ? Image.network(
                  'https://www.investopedia.com/thmb/hJrIBjjMBGfx0oa_bHAgZ9AWyn0=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/qr-code-bc94057f452f4806af70fd34540f72ad.png',
                  width: 150)
              : const SizedBox(),
          arguments['exampleArgument'] == 'dynamicLink'
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              paymentMobilenumber.text.length >= 10
                                  ? createPaymentlink()
                                  : setState(() {
                                      set.setglobaldata('inputerror', true);
                                    });

                              if (charLength == 10) {
                                setState(() {
                                  set.setglobaldata('inputerror', false);
                                });
                              }
                              FocusScope.of(context).unfocus();
                              if (context.mounted) Navigator.pop(context);
                              if (context.mounted) Navigator.of(context).pop();
                            },
                            child: const Text("Send")),
                      )),
                    ],
                  ),
                )
              : */
          Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        onPressed: () {
                          Navigator.pushNamed(context, '/homepage');
                        },
                        child: const Text("Cancel")),
                  )),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          getprintTicket();
                          Navigator.pushNamed(context, '/homepage');
                          set.setglobaldata('selectVehicle', '');
                        },
                        child: const Text("Done")),
                  )),
            ],
          )
        ],
      ),
    );
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

  Future<void> getprintTicket() async {
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    var companyNumber = get.getglobaldata['companyNumber'];
    var deviceId = get.getglobaldata['uniqueId'];
    var response = await http.get(
      Uri.parse('$baseUrl1/GetParkingDetailsNew?Company_Id=$companyNumber&DeviceId=$deviceId'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      set.setglobaldata('inprintdata', data['body'][0]);
      Future.delayed(const Duration(milliseconds: 300));
      getOpen();
      await channel.invokeMethod("printText",    {

        "data":  get.getglobaldata['inprintdata'],
        "company_Id": companyNumber,
        "device_Id": deviceId,

      });
    }
  }
}
