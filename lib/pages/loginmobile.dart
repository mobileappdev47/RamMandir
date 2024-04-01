// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../Models/ParkingModel.dart';
import '../constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../utils/color.dart';
import 'globalProvider.dart';

class LoginMobile extends StatefulWidget {
  const LoginMobile({super.key});

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

const MethodChannel channel = MethodChannel('com.imin.printerlib');

class _LoginMobileState extends State<LoginMobile> {
  ValueNotifier<String> stateNotifier = ValueNotifier("");
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loader = false;
  bool passwordHide = true;
  List<ParkingModel> parkingModel = [];

/*   Future<void> loginCheck(
      {required String username, required String password}) async {
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    var role = get.getglobaldata['appbarTitle'];
    var imei = get.getglobaldata['uniqueId'];
    setState(() {
      loader = true;
    });
    String apiUrl =
        "/ssbauth?User_Name=$username&Password=$password&Role=$role&Imei_No=$imei";
   var data  = GlobalApicall(context).globalApicall(baseUrl: baseUrl, apiUrl: apiUrl);
   if(data['Role'] == "Parking System")
   
  } */

  Future<void> loginCheck(
      {required String username, required String password}) async {
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    setState(() {
      loader = true;
    });
    final url = Uri.parse("$baseUrl/auth.php");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: <String, String>{
        "User_Name": username,
        "Password": password,
        "Role": get.getglobaldata['appbarTitle'],
        "Imei_No": get.getglobaldata['uniqueId']
      },
    );

    debugPrint(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['Role'] == "Parking System" ||
          data['Role'] == "Mall In System") {
        set.setglobaldata('companyNumber', data['companyid']);
        set.setglobaldata('userId', data['customerid']);
        set.setglobaldata('controllerId', data['controllerNumber']);
        set.setglobaldata('locationid', data['Location_Id']);
        set.setglobaldata('outControllerId', data['outcontrollerNumber']);
        Navigator.pushNamed(context, "/homepage");
        showSnackbar(context,
            color: Colors.green,
            letftbarColor: Colors.black,
            message: "Welcome ${data['username']}",
            icon: const Icon(Icons.check, color: Colors.greenAccent));
      } else if (data['Role'] == "Mall Out System") {
        set.setglobaldata('companyNumber', data['companyid']);
        set.setglobaldata('userId', data['customerid']);
        set.setglobaldata('controllerId', data['controllerNumber']);
        set.setglobaldata('locationid', data['Location_Id']);
        set.setglobaldata('outControllerId', data['outcontrollerNumber']);
        Navigator.pushNamed(context, "/OutTicket");
      } else if (data['Role'] == 'Ferry System') {
        showSnackbar(context,
            color: Colors.red,
            letftbarColor: Colors.black,
            message: "Welcome ${data['username']}",
            icon: const Icon(Icons.check, color: Colors.greenAccent));
        Navigator.pushNamed(context, "/ferry");
      } else {
        var snackBar = SnackBar(
          backgroundColor: red,
          content: const Text('Please Provide correct Username and Password'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      var snackBar = SnackBar(
        backgroundColor: red,
        content: const Text('Server error from Server'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      loader = false;
      set.setglobaldata('btnopt', false);
    });
  }

  /* Future<List<ParkingModel>> parkingDetails() async {
    // final requestParams = jsonEncode({'Company_Id': '2'});
    final response = await http.get(
      Uri.parse('$baseUrl1/GetimageValueRate?Company_Id=2'),
      // body: requestParams,
      /*  headers: {
          "Accept": "application/json",
        } */
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        parkingModel.add(ParkingModel.fromJson(i));
      }
      stateNotifier.value = await channel.invokeMethod("sdkInit");
      return parkingModel;
    } else {
      return parkingModel;
    }
  } */

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Parking Management system',style: TextStyle(
                color: appBackgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: appBackgroundColor, //
                            blurRadius: 12.0,
                            spreadRadius: 2)
                      ]),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/car.png',
                              width: 100,
                            ),

                            /* get.getglobaldata['appbarTitle'] !=
                                        'Mall In System' &&
                                    get.getglobaldata['appbarTitle'] !=
                                        'Mall Out System'
                                ? get.getglobaldata['appbarTitle'] ==
                                        'Parking System'
                                    ? Image.asset(
                                        'assets/parking-car.png',
                                        width: 100,
                                      )
                                    : Image.asset(
                                        'assets/ship.png',
                                        width: 100,
                                      )
                                : Image.asset(
                                    'assets/mall.png',
                                    width: 100,
                                  ), */
                          ),
                          TextField(
                            controller: username,
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
                                prefixIcon: const Icon(
                                  Icons.person,
                                ),
                                hintText: "Enter your username"),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextField(
                            controller: password,
                            obscureText: passwordHide,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        passwordHide = !passwordHide;
                                      });
                                    },
                                    child: passwordHide
                                        ? const Icon(Icons.remove_red_eye)
                                        : const Icon(
                                            Icons.remove_red_eye_outlined)),
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
                                prefixIcon: const Icon(Icons.password),
                                hintText: "Enter your password"),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                              width: screenWidth,
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      backgroundColor: get.getglobaldata['btnopt']
                                          ? appBackgroundColor
                                          : appBackgroundColor),
                                  onPressed: () async {
                                    set.setglobaldata('btnopt', true);
                                    bool result = await InternetConnectionChecker()
                                        .hasConnection;
                                    if (username.text.isNotEmpty &&
                                        password.text.isNotEmpty) {
                                      result
                                          ? loginCheck(
                                              username: username.text,
                                              password: password.text,
                                            )
                                          : showSnackbar(context,
                                              message: "No Internet",
                                              color: Colors.black,
                                              icon: const Icon(
                                                  Icons.signal_cellular_off,
                                                  color: Colors.red),
                                              letftbarColor: Colors.red);
                                    } else {
                                      showSnackbar(context,
                                          message:
                                              "Please Provide Username and Password",
                                          color: Colors.black,
                                          icon: const Icon(Icons.error,
                                              color: Colors.red),
                                          letftbarColor: Colors.red);
                                    }
                                  },
                                  child: loader
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        )
                                      : const Text("SIGN IN"))),
                          const SizedBox(
                            height: 16,
                          ),
                          const SizedBox(
                            height: 08,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Device Id",
                                  style: TextStyle(color: red),
                                ),
                                const SizedBox(height: 08),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(get.getglobaldata['uniqueId']),
                                    const SizedBox(width: 08),
                                    GestureDetector(
                                      onTap: () async {
                                        await Clipboard.setData(ClipboardData(
                                            text: get.getglobaldata['uniqueId']));
                                      },
                                      child: const Icon(
                                        Icons.copy,
                                        size: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackbar(context,
      {required String? message,
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
