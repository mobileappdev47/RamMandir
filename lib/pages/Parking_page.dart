// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticketingapp/globalapicall.dart';
import 'package:ticketingapp/widget/drawer_widget.dart';
import '../Models/ParkingModel.dart';
import '../constants/constant.dart';
//import 'globalapicall.dart';
import '../utils/color.dart';
//import '../../test/widget/drawer_widget.dart';
import 'globalProvider.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
/* import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart'; */

class Parkingpage extends StatefulWidget {
  const Parkingpage({super.key});

  @override
  State<Parkingpage> createState() => _ParkingpageState();
}

const MethodChannel channel = MethodChannel('com.imin.printerlib');

class _ParkingpageState extends State<Parkingpage> {
  ValueNotifier<String> stateNotifier = ValueNotifier("");
  int selectedCard = -1;
  var initamount = '00';
  var countticket = 0;
  int charLength = 0;
  Timer? timer;
  TextEditingController vehicalNumbercontroller = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController cashMode = TextEditingController();
  TextEditingController searchSlot = TextEditingController();
  String datenow = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String timenow = DateFormat('HH:mm:ss').format(DateTime.now());
  String currentDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
  String vehicalType = '';
  String dropdownvalue = 'UP';
  String selectamount = '';
  String? slotAviable;
  String? currentcountSlot;
  List<ParkingModel> parkingModel = [];
  bool checkOnlineentry = false;
  bool checkbox = false;
  bool getloader = false;

  @override
  void initState() {
    var set = context.read<GlobalProvider>();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      set.setglobaldata("checkparking", false);
    });
    generateTikcetNo();
    createDynamic();
    parkingDetails();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  var items = [
    "UP",
    "DL",
    "MP",
    "RJ",
    "UK",
    "AN",
    "PB",
    "GJ",
    "MH",
    "HR",
    "AP",
    "WB",
    "AR",
    "AS",
    "BR",
    "CG",
    "CH",
    "DH",
    'DD',
    "GA",
    "HP",
    "JK",
    "JH",
    "KA",
    "KL",
    "LD",
    "MN",
    "ML",
    "MZ",
    "NL",
    "OR",
    "PY",
    "SK",
    "TN",
    "TS",
    "TR",
  ];

/*   Future<List<ParkingModel>> parkingDetails() async {
    // var get = Provider.of<GlobalProvider>(context, listen: false);
    // var companyNumber = get.getglobaldata['companyNumber'];
    final response = await http.get(
      Uri.parse('$baseUrl1/GetimageValueRate?Company_Id=3'),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data['body']) {
        parkingModel.add(ParkingModel.fromJson(i));
      }
      stateNotifier.value = await channel.invokeMethod("sdkInit");
      return parkingModel;
    } else {
      return parkingModel;
    }
  } */

  Future<void> reset() async {
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    dynamic t;
    if (get.getglobaldata['testNumber'] >= 0) {
      t = get.getglobaldata['testNumber'] - 1;
    }
    if (t <= 0) {
      sleep(const Duration(milliseconds: 800));
      set.setglobaldata("checkparking", true);
      set.setglobaldata('disable', true);
    }
    set.setglobaldata('testNumber', t);
  }

  Future<void> generateTikcetNo() async {
    var set = context.read<GlobalProvider>();
    var response = await http.post(Uri.parse('$baseUrl1/getBillNumber'),
        body: jsonEncode({}),
        headers: {
          "Accept": "application/json",
        });
    if (response.statusCode == 200) {
      var ticketNo = jsonDecode(response.body);
      set.setglobaldata('ticketNo', ticketNo['Message'][0]['PurchaseNo']);
    }
  }

  Future<void> sendTicket() async {
    var get = Provider.of<GlobalProvider>(context, listen: false);
    var companyNumber = get.getglobaldata['companyNumber'] ?? '';
    var sectionName = get.getglobaldata['appbarTitle'] ?? '';
    var deviceId = get.getglobaldata['uniqueId'] ?? '';
    var vehicleNo = "$dropdownvalue${vehicalNumbercontroller.text}";
    var locationId = get.getglobaldata['locationid'] ?? '';

    var response = await http.get(
      Uri.parse(
          '$baseUrl1/InsertCartDetatils?Section_Name=$sectionName&Print_Flag=Yes&Category_Name=$vehicalType&Vehicle_No=$vehicleNo&Vehicle_Rate=$selectamount&Payment_Mode=cash&User_Id=null&QR_Code=null&Computer_Name=android&Company_Id=$companyNumber&Adult_Number=1&Device_Id=$deviceId&Location_Id=$locationId'),
    );
    debugPrint(response.body.toString());
  }

  Future<void> createDynamic() async {
    var bytes = utf8.encode("$key|UTA3252afaff33|1.0|1.0||||||$salt");
    var dynamicQrCode = sha512.convert(bytes);
    final jsonResquest = jsonEncode({
      "key": key,
      "unique_request_number": "UTA3252afaff33",
      "amount": 1.0,
      "per_transaction_amount": 1.0,
      "customer_name": "Biresh Multani",
      "customer_phone": "9284753738",
      "allowed_collection_modes": ["bank_account", "upi"],
    });
    await http.post(Uri.parse('$qrCodeUrl/api/v1/insta-collect/order/create/'),
        body: jsonResquest,
        headers: {
          "Authorization": dynamicQrCode.toString(),
          "Accept": "application/json",
          "Content-Type": "application/json"
        });
  }

  Future<void> getslotDate() async {
    String apiUrl = "getslotDate";
    var data = await GlobalApicall(context)
        .globalApicall(baseUrl: baseUrl1, apiUrl: apiUrl);
    if (data != []) {
      insertDetails();
    }
  }

  Future<void> getSlotavaible() async {
    String apiUrl = "getSlotavaible";
    var data = await GlobalApicall(context).globalApicall(
      baseUrl: baseUrl1,
      apiUrl: apiUrl,
    );
    setState(() {
      slotAviable = data;
    });
  }

  Future<void> parkingDetails() async {
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    String companyNumber = get.getglobaldata['companyNumber'];
    var res = await http.get(Uri.parse(
        "$baseUrl/Parking_WebService.asmx/GetimageValueRate?Company_Id=$companyNumber"));
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      set.setglobaldata('vehiclerate', data);
      stateNotifier.value = await channel.invokeMethod("sdkInit");
    }
  }

  Future<void> currentDayCount() async {
    String apiUrl = "currentDayCount";
    var data = await GlobalApicall(context)
        .globalApicall(baseUrl: baseUrl1, apiUrl: apiUrl);
    setState(() {
      currentcountSlot = data;
    });
  }

  Future<void> getCompanyLocation({required String companyNumber}) async {
    var set = context.read<GlobalProvider>();
    String apiUrl = "currentDayCount?companyName=$companyNumber";
    var data = await GlobalApicall(context)
        .globalApicall(baseUrl: baseUrl1, apiUrl: apiUrl);
    if (data != []) {
      set.setglobaldata('companyLocationName', data['CompanyName']);
      set.setglobaldata('companyLocationaddress', data['Location']);
    }
  }

  Future<void> insertDetails() async {
    var get = Provider.of<GlobalProvider>(context, listen: false);
    String baseUrl = "http://103.14.99.95:8080";
    String vehicle = "$dropdownvalue-${vehicalNumbercontroller.text}";
    String customerCode = get.getglobaldata['companyNumber'];
    String customerName = get.getglobaldata['companyLocationName'];
    String location = get.getglobaldata['companyLocationaddress'];
    String vehicleType = vehicalType;
    String amount = selectamount;
    String uniqueID = get.getglobaldata['uniqueId'];
    String userId = get.getglobaldata['userId'];
    String dateTime = currentDate;

    String apiUrl =
        "ATMDemoWebApi/PostPark?VehicleNumber=$vehicle&CustomerCode=$customerCode&CustomerName=$customerName&Location=$location&VehicleType=$vehicleType&Amount=$amount&UniqueID=$uniqueID&UserId=$userId&DateTime=$dateTime";
    await GlobalApicall(context)
        .globalApicall(baseUrl: baseUrl, apiUrl: apiUrl);
  }

  Future<void> updateEntrydetails() async {
    var get = Provider.of<GlobalProvider>(context, listen: false);
    String customerName = get.getglobaldata['companyLocationName'];
    String customerCode = get.getglobaldata['companyNumber'];
    String baseUrl = "http://103.14.99.95:8080";
    String apiUrl =
        "ATMDemoWebApi/GetParking?CustomerName=$customerName&CustomerCode=$customerCode";
    await GlobalApicall(context)
        .globalApicall(baseUrl: baseUrl, apiUrl: apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    var set = context.read<GlobalProvider>();
    var get = context.watch<GlobalProvider>();
    Object? type = ModalRoute.of(context)!.settings.arguments;
    const double itemHeight = (500 - kToolbarHeight - 24) / 0.1;
    const double itemWidth = 500 / 0.1;
    return /*PopScope(
      canPop: false,
      onPopInvoked: (bool canPop) {
        if (canPop) {
          return;
        }
      },
      child: */SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xffFAF9F6),
            appBar: AppBar(actions: [
              GestureDetector(
                onTap: () async {
                  String serialNo = get.getglobaldata['controllerId']??'';


                  setState(() {
                    getloader = true;
                  });
                  var headers = {'Content-Type': 'application/json'};
                  var request = http.Request(
                      'POST', Uri.parse('http://ac.vidaniautomations.com/cmd'));
                  request.body = json.encode({
                    // "serialNo": 'vio0c8b954324a8',
                    "serialNo": serialNo,

                    "cmd": {"type": "control", "id": 1, "key": 1, "value": 1}
                  });
                  request.headers.addAll(headers);

                  http.StreamedResponse response = await request.send();
                  if (response.statusCode == 200) {
                    debugPrint(await response.stream.bytesToString());
                  } else {
                    debugPrint(response.reasonPhrase);
                  }

                  setState(() {
                    getloader = false;
                  });
                },
                child: const Row(
                  children: [
                    Text(
                      "Gate Open",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.open_in_browser),
                    )
                  ],
                ),
              )
            ]
                //title: Text(get.getglobaldata['appbarTitle']),
                /* actions: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    checkOnlineentry = !checkOnlineentry;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.notifications, color: Colors.white),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 0),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100)),
                          child: const Text("1",
                              style: TextStyle(color: Colors.white)))
                    ],
                  ),
                ),
              )
            ], */
                ),
            drawer: const DrawWidget(),
            body: !getloader
                ? Builder(
                    builder: (context) => Stack(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Vehicle Type: $vehicalType',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: appBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(items),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownvalue = newValue!;
                                                });
                                                set.setglobaldata(
                                                    'selectState', newValue);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (get.getglobaldata['hidefield'] ?? true)
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: SizedBox(
                                            height: 40,
                                            width: 100,
                                            child: TextField(
                                                readOnly: get.getglobaldata[
                                                            'disable'] ==
                                                        false
                                                    ? false
                                                    : true,
                                                controller:
                                                    vehicalNumbercontroller,
                                                onChanged: (value) {
                                                  set.setglobaldata(
                                                      'numberplaterNumber',
                                                      value);
                                                },
                                                decoration: const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.orange)),
                                                    hintText: "Enter 4 Digit",
                                                    hintStyle:
                                                        TextStyle(fontSize: 12),
                                                    counterText: ""),
                                                keyboardType:
                                                    TextInputType.number,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                cursorColor: appBackgroundColor,
                                                maxLength: 4,
                                                autocorrect: false,
                                                autofocus: false,
                                                enableSuggestions: false),
                                          ),
                                        ),
                                      ),
                                    type != 'mallin' && type != 'mallout'
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                                height: 37,
                                                child: ElevatedButton(
                                                    onPressed:
                                                        get.getglobaldata[
                                                                'disable']
                                                            ? null
                                                            : () async {
                                                                if (vehicalNumbercontroller
                                                                        .text
                                                                        .isNotEmpty &&
                                                                    vehicalNumbercontroller
                                                                            .text
                                                                            .length >=
                                                                        4 &&
                                                                    get.getglobaldata[
                                                                            'selectVehicle'] !=
                                                                        '') {
                                                                  {
                                                                    Navigator
                                                                        .pushNamed(
                                                                      context,
                                                                      '/paymentMode',
                                                                      arguments: {
                                                                        'exampleArgument':
                                                                            'cashButtom'
                                                                      },
                                                                    );
                                                                    sendTicket();
                                                                  
                                                                  }
                                                                } else {
                                                                  showSnackbar(
                                                                      context,
                                                                      color: Colors
                                                                          .red,
                                                                      letftbarColor:
                                                                          Colors
                                                                              .black,
                                                                      message:
                                                                          "Please Provide Details !",
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .error));
                                                                }

                                                                /*  if (vehicalType
                                                                    .isEmpty) {
                                                                  showSnackbar(
                                                                      context,
                                                                      color: Colors
                                                                          .red,
                                                                      letftbarColor:
                                                                          Colors
                                                                              .black,
                                                                      message:
                                                                          "Please Select Vehicle Type",
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .error));
                                                                } else if (vehicalNumbercontroller
                                                                        .text
                                                                        .isEmpty &&
                                                                    vehicalNumbercontroller
                                                                            .text
                                                                            .length ==
                                                                        4) {
                                                                  showSnackbar(
                                                                      context,
                                                                      color: Colors
                                                                          .red,
                                                                      letftbarColor:
                                                                          Colors
                                                                              .black,
                                                                      message:
                                                                          "Please Provide 4 Digitst Car Number",
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .error));
                                                                } else {
                                                                  Navigator
                                                                      .pushNamed(
                                                                    context,
                                                                    '/paymentMode',
                                                                    arguments: {
                                                                      'exampleArgument':
                                                                          'cashButtom'
                                                                    },
                                                                  );
                                                                  sendTicket();
                                                                } */
                                                              },
                                                    child: const Text("Next",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15)))),
                                          )
                                        : SizedBox(
                                            width: 100,
                                            height: 40,
                                            child: ElevatedButton(
                                                onPressed:
                                                    get.getglobaldata['disable']
                                                        ? null
                                                        : () async {
                                                            debugPrint(
                                                                "button Tapped");
                                                          },
                                                child: const Text("Print"))),
                                  ],
                                ),
                                get.getglobaldata['vehiclerate'] != []
                                    ? Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio:
                                                    (itemWidth / itemHeight),
                                              ),
                                              itemCount: get
                                                  .getglobaldata['vehiclerate']
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                String imageName = get
                                                    .getglobaldata[
                                                        'vehiclerate'][index]
                                                        ['Url']
                                                    .replaceAll(
                                                        RegExp(r'~'), '');
                                                return GestureDetector(
                                                  onTap: () {
                                                    var selectedData = get
                                                            .getglobaldata[
                                                        'vehiclerate'][index];
                                                    selectamount =
                                                        selectedData['Amount']
                                                            .toString();
                                                    set.setglobaldata(
                                                        'amount',
                                                        selectedData['Amount']
                                                            .toString());
                                                    set.setglobaldata(
                                                        'selectVehicle',
                                                        selectedData[
                                                                'Vehicle_Type']
                                                            .toString());
                                                    vehicalType = selectedData[
                                                            'Vehicle_Type']
                                                        .toString();

                                                    //  vehicalNumbercontroller.clear();
                                                    set.setglobaldata(
                                                        'hidefield', true);
                                                    if (index == 6) {
                                                      /*  set.setglobaldata('hidefield', false);
                                          vehicalNumbercontroller.text = 'cycle'; */
                                                      /*  setState(() {
                                    set.setglobaldata('displayContract', true);
                                    contractshowDialog = false;
                                  }); */
                                                    }

                                                    setState(() {
                                                      selectedCard = index;
                                                      initamount = selectamount;
                                                    });
                                                  },
                                                  child: Card(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: selectedCard ==
                                                                  index
                                                              ? appBackgroundColor
                                                              : Colors
                                                                  .grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      08)),
                                                      child: Column(
                                                        children: [

                                                          Expanded(
                                                            child: Image.network(
                                                              baseUrl +
                                                                  imageName
                                                                      .toString(),
                                                              fit: BoxFit.fitWidth,
                                                              errorBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      Object
                                                                          exception,
                                                                      StackTrace?
                                                                          stackTrace) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(16.0),
                                                                  child: Icon(
                                                                    Icons.error,
                                                                    color: red,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          Text(get
                                                              .getglobaldata[
                                                          'vehiclerate'][index][
                                                          'Vehicle_Type']
                                                              .toString()),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      )
                                    : const Expanded(
                                        child: Center(
                                            child: Text("No Data Found")),
                                      )
                                /*  FutureBuilder<List<ParkingModel>>(
                            future: parkingDetails(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<ParkingModel>> snapshot) {
                              if (snapshot.hasData) {
                                return Flexible(
                                  child: GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: false,
                                      scrollDirection: Axis.vertical,
                                      itemCount: 8,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width /
                                                (MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3),
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        ParkingModel parkingDetaisl =
                                            snapshot.data![index];
                                        String imageName = parkingDetaisl.url!
                                            .replaceAll(RegExp(r'~'), '');
                                        return GestureDetector(
                                          onTap: () {
                                            selectamount = parkingDetaisl.amount
                                                .toString();
                                            set.setglobaldata('amount',
                                                parkingDetaisl.amount);
                                            set.setglobaldata('selectVehicle',
                                                parkingDetaisl.vehicleType);
                                            vehicalType = parkingDetaisl
                                                .vehicleType
                                                .toString();
                                            vehicalNumbercontroller.clear();
                                            set.setglobaldata(
                                                'hidefield', true);
                                            if (index == 6) {
                                              set.setglobaldata(
                                                  'hidefield', false);
                                              vehicalNumbercontroller.text =
                                                  'cycle';
                                            }

                                            setState(() {
                                              // if (index == 0 || index == 1) {
                                              selectedCard = index;
                                              // }
                                              initamount = selectamount;
                                            });
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(08),
                                              side: BorderSide(
                                                color: appBackgroundColor,
                                              ),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: selectedCard == index
                                                      ? appBackgroundColor
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          08)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.network(
                                                    baseUrl +
                                                        imageName.toString(),
                                                    width: 80,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Icon(
                                                          Icons.error,
                                                          color: red,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        parkingDetaisl
                                                            .vehicleType
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium,
                                                      ),
                                                      const SizedBox(
                                                        width: 08,
                                                      ),
                                                      Text(
                                                        '\u{20B9}${parkingDetaisl.amount}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              } else {
                                return CircularProgressIndicator(
                                    color: appBackgroundColor);
                              }
                            },
                          ) */
                              ],
                            ),
                            if (get.getglobaldata['checkparking'])
                              Center(
                                child: Container(
                                  color: Colors.grey.shade200.withOpacity(0.5),
                                  child: Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        width: 150,
                                        height: 150,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset('assets/warning.png',
                                                width: 80),
                                            const Text("No Parking Avaiable",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            /* Center(
                  child: Padding(
                padding: const EdgeInsets.all(64.0),
                child: Container(
                  width: double.maxFinite,
                  color: Colors.white,
                  child: Column(children: [
                    Container(
                      color: appBackgroundColor,
                      height: 60,
                    ),
                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        debugPrint(rating.toString());
                      },
                    )
                  ]),
                ),
              )) */
                            checkOnlineentry
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 100),
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: SingleChildScrollView(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text("Online Slot",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24)),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: TextField(
                                                      cursorColor: Colors.white,
                                                      decoration: InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          0),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .white)),
                                                          suffixIcon: Icon(
                                                              Icons.search,
                                                              color: Colors
                                                                  .white))),
                                                ),
                                                ListView.builder(
                                                    itemCount: 20,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                                "MH-34-BS-6978",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .white)),
                                                            Checkbox(
                                                                value: checkbox,
                                                                onChanged:
                                                                    (value) {
                                                                  value =
                                                                      !checkbox;
                                                                })
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ]),
                                        )),
                                  )
                                : const SizedBox(),
                          ],
                        ))
                : const Center(
                    child: CircularProgressIndicator(color: Colors.black))),

    );
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

@immutable
class DrawerLabels extends StatelessWidget {
  final String drawerlabel;
  final IconData? icon;
  const DrawerLabels({super.key, required this.drawerlabel, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(04)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(icon),
                Text(
                  drawerlabel,
                  style: TextStyle(fontSize: 24, color: appBackgroundColor),
                )
              ],
            ),
          )),
    );
  }
}
