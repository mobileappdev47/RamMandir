import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../constants/constant.dart';
import '../utils/color.dart';
import '../widget/drawer_widget.dart';
import 'globalProvider.dart';

class OutTicket extends StatefulWidget {
  const OutTicket({super.key});

  @override
  State<OutTicket> createState() => _OutTicketState();
}

const MethodChannel channel = MethodChannel('com.imin.printerlib');

class _OutTicketState extends State<OutTicket> {
  TextEditingController searchticket = TextEditingController();
  TextEditingController searchvehicle = TextEditingController();
  String datenow = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  String value = '';
  FocusNode firstFocus = FocusNode();
  bool loaderdata = false;
  bool getloader = false;
  bool checkticketprint = false;
  bool checkVehicleprint = false;
  bool isavaible = true;
  String passTicketNo= '';

List vehicleList = [];
  @override
  void initState() {
    var set = context.read<GlobalProvider>();
    set.clearglobaldata('outticketDetails');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var get = context.watch<GlobalProvider>();
    String companyNumber = get.getglobaldata['companyNumber'];
    String sNo =
        get.getglobaldata['outControllerId'] ?? '';
    String deviceId = get.getglobaldata['uniqueId'] ?? '';
    String locationId = get.getglobaldata['locationid'].toString() ?? '';
    return /*PopScope(
      canPop: true,
      onPopInvoked: (bool canPop) {
        if (canPop) {
          return;
        }
      },*/
        // child:
        Scaffold(
            appBar: AppBar(actions: [
              GestureDetector(
                  onTap: () async {
                    String serialNo =
                        get.getglobaldata['outControllerId'] ?? '';
                    print(serialNo);
                    setState(() {
                      loaderdata = true;
                    });
                    var headers = {'Content-Type': 'application/json'};
                    var request = http.Request('POST',
                        Uri.parse('http://ac.vidaniautomations.com/cmd'));
                    request.body = json.encode({
                      // "serialNo": 'vio94e6868fe658',
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
                      loaderdata = false;
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
                  )),
            ]),
            drawer: const DrawWidget(),
            body: Stack(
              children: [
                !loaderdata
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Text("companyNumber---$companyNumber"),
                              // Text("sNo---$sNo"),
                              // Text("location---$locationId"),
                              // Text("ticketnumber ---${searchticket.text}"),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                    //  maxLength: 6,
                                    // keyboardType: TextInputType.number,
                                    controller: searchticket,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: appBackgroundColor),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: appBackgroundColor),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: "Enter Your Ticket Number",
                                      prefixIcon: const Icon(Icons.numbers),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            // passTicketNo = searchticket.text;
                                            // setState(() {
                                            //
                                            // });
                                            if (searchticket.text.length >=
                                                11) {
                                              FocusScope.of(context).unfocus();
                                              checkOutprintflagDetails(
                                                  ticketNo: searchticket.text);
                                              Future.delayed(const Duration(
                                                  milliseconds: 300));
                                            }
                                          },
                                          child: const Icon(Icons.search)),
                                    ),
                                    onChanged: (val) {
//                                       passTicketNo = val;
// setState(() {
//
// });
                                      if (val.length == 11 &&
                                          searchticket.text.isNotEmpty) {
                                        FocusScope.of(context).unfocus();
                                        checkOutprintflagDetails(
                                            ticketNo: searchticket.text);
                                        Future.delayed(
                                            const Duration(milliseconds: 300));
                                      }

                                      if (val.length == 0) {
                                        var set =
                                            context.read<GlobalProvider>();
                                        set.clearglobaldata('outticketDetails');
                                      }
                                      /* if (val.length == 9 &&
                                        searchticket.text.isNotEmpty) {
                                      FocusScope.of(context).unfocus();
                                      checkOutprintflagDetails(
                                          ticketNo: searchticket.text);
                                      Future.delayed(
                                          const Duration(milliseconds: 300));
                                    } else if (val.length > 9 &&
                                        searchticket.text.isNotEmpty) {
                                      FocusScope.of(context).unfocus();
                                      checkOutprintflagDetails(
                                          ticketNo: searchticket.text);
                                      Future.delayed(
                                          const Duration(milliseconds: 300));
                                    } */
                                    }),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                    //  maxLength: 6,
                                    // keyboardType: TextInputType.number,
                                    controller: searchvehicle,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: appBackgroundColor),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: appBackgroundColor),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: "Enter Your Vehicle Number",
                                      prefixIcon: const Icon(Icons.numbers),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            // if (searchticket.text.length >= 6) {
                                            //   FocusScope.of(context).unfocus();
                                            //   checkOutprintflagDetails(
                                            //       ticketNo: searchticket.text);
                                            //   Future.delayed(const Duration(
                                            //       milliseconds: 300));
                                            // }
                                            if (searchvehicle.text.length == 6 &&
                                                searchvehicle.text.isNotEmpty) {
                                              var set =
                                              context.read<GlobalProvider>();
                                              FocusScope.of(context).unfocus();

                                              set.clearglobaldata('outticketDetails');
                                              setState(() {

                                              });
                                              getVehicleNOApi(vehicleNo: searchvehicle.text );
                                              // newAPi(vehicleNo: searchvehicle.text);
                                              // Future.delayed(
                                              //     const Duration(milliseconds: 300));
                                            }

                                            if (searchvehicle.text.isEmpty) {
                                              var set =
                                              context.read<GlobalProvider>();
                                              set.clearglobaldata('outticketDetails');
                                            }
                                          },
                                          child: const Icon(Icons.search)),
                                    ),
                                    onChanged: (val) {
                                      if (val.length == 6 &&
                                          searchvehicle.text.isNotEmpty) {
                                        var set =
                                        context.read<GlobalProvider>();
                                        FocusScope.of(context).unfocus();

                                        set.clearglobaldata('outticketDetails');
                                     setState(() {

                                     });
                                        getVehicleNOApi(vehicleNo: searchvehicle.text );
                                        // newAPi(vehicleNo: searchvehicle.text);
                                        // Future.delayed(
                                        //     const Duration(milliseconds: 300));
                                      }

                                      if (val.length == 0) {
                                        var set =
                                            context.read<GlobalProvider>();
                                        set.clearglobaldata('outticketDetails');
                                      }

                                      /* if (val.length == 9 &&
                                        searchticket.text.isNotEmpty) {
                                      FocusScope.of(context).unfocus();
                                      checkOutprintflagDetails(
                                          ticketNo: searchticket.text);
                                      Future.delayed(
                                          const Duration(milliseconds: 300));
                                    } else if (val.length > 9 &&
                                        searchticket.text.isNotEmpty) {
                                      FocusScope.of(context).unfocus();
                                      checkOutprintflagDetails(
                                          ticketNo: searchticket.text);
                                      Future.delayed(
                                          const Duration(milliseconds: 300));
                                    } */
                                    }),
                              ),
                              get.getglobaldata['outticketDetails'] != null &&
                                      get.getglobaldata['outticketDetails']
                                              .length !=
                                          0 &&
                                      get.getglobaldata['outticketDetails']
                                          .isNotEmpty
                                  ? Column(
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                                color: appBackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Ticket Number",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  get.getglobaldata[
                                                          'outticketDetails']
                                                          ['Ticket_No']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )
                                              ],
                                            )),
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                                color: appBackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Parking Time",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  get.getglobaldata[
                                                          'outticketDetails']
                                                          ['Parking_Time']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )
                                              ],
                                            )),
                                        Container(
                                            padding: const EdgeInsets.all(12),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: appBackgroundColor,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Category Name",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  get.getglobaldata[
                                                          'outticketDetails']
                                                          ['Category_Name']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )
                                              ],
                                            )),
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                                color: appBackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Vehicle Number",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  get.getglobaldata[
                                                          'outticketDetails']
                                                          ['Vehicle_No']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )
                                              ],
                                            )),
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                                color: appBackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Vehicle Rate",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  "${get.getglobaldata['outticketDetails']['Vehicle_Rate']}₹",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )
                                              ],
                                            )),
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                                color: appBackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Ticket_Date",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  get.getglobaldata[
                                                          'outticketDetails']
                                                          ['Ticket_Date']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            )),
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                                color: appBackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Out date",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  get.getglobaldata[
                                                          'outticketDetails']
                                                          ['Out_date']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )
                                              ],
                                            )),
                                      ],
                                    )
                                  : const SizedBox(),
                           (   get.getglobaldata['outticketDetails'] ==
                                  null ||
                                  get.getglobaldata['outticketDetails'].length == 0 ||
                                  get.getglobaldata['outticketDetails'].isEmpty) && searchvehicle.text.isNotEmpty ?
                              ListView.separated(
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 10,
                                  );
                                },
                                itemCount: vehicleList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        searchticket.text = vehicleList[index]['Ticket_No'];
                                      });
                                      // passTicketNo= vehicleList[index]['Ticket_No'];
                                      // setState(() {
                                      //
                                      // });
                                      checkOutprintflagDetails(ticketNo: vehicleList[index]['Ticket_No']??'');
                                      Future.delayed(
                                          const Duration(milliseconds: 300));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 13, vertical: 13),
                                      decoration: BoxDecoration(
                                        color: appBackgroundColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Vehicle number:",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                vehicleList[index]['Vehicle_No']??'',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Vehicle Type",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                vehicleList[index]['Category_Name']??'',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Date:",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                vehicleList[index]['Ticket_Date'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "TicketNo",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                vehicleList[index]['Ticket_No'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ) : SizedBox(),
                            ],
                          ),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
                checkticketprint
                    ? AlertDialog(
                        backgroundColor: appBackgroundColor,
                        surfaceTintColor: appBackgroundColor,
                        title: const Text(
                          'Ticket is already out',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Okay',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              setState(() {
                                checkticketprint = false;
                              });
                            },
                          ),
                        ],
                      )
                    : const SizedBox(),
                checkVehicleprint
                    ? AlertDialog(
                        backgroundColor: appBackgroundColor,
                        surfaceTintColor: appBackgroundColor,
                        title: const Text(
                          'Vehicle is already out',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Okay',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              setState(() {
                                checkVehicleprint = false;
                              });
                            },
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
            floatingActionButton: get.getglobaldata['outticketDetails'] !=
                        null &&
                    get.getglobaldata['outticketDetails'].length != 0 &&
                    get.getglobaldata['outticketDetails'].isNotEmpty
                ?
            // (searchticket.text != ''&& searchticket.text.isNotEmpty)
            //         ?
            FloatingActionButton.small(
                        backgroundColor: appBackgroundColor,
                        onPressed: () async {
                          ticketUpdate(ticketNumber: searchticket.text);
                          await channel.invokeMethod("outPrint", {
                            "data": get.getglobaldata['outticketDetails'],
                            "company_Id": companyNumber,
                            "ticketNo": searchticket.text,
                            "locationId": locationId,
                            "type": "ticket",
                            "Ticket_Date": get.getglobaldata['outticketDetails']
                                    ['Ticket_Date']
                                .toString(),
                            "Out_date": get.getglobaldata['outticketDetails']
                                    ['Out_date']
                                .toString(),
                            "Parking_Time": get
                                .getglobaldata['outticketDetails']
                                    ['Parking_Time']
                                .toString(),
                            "Ticket_No": get.getglobaldata['outticketDetails']
                                    ['Ticket_No']
                                .toString(),
                            "Vehicle_Rate": get
                                .getglobaldata['outticketDetails']
                                    ['Vehicle_Rate']
                                .toString(),
                            "Vehicle_No": get.getglobaldata['outticketDetails']
                                    ['Vehicle_No']
                                .toString(),
                          });

                          getOpen();
                        },
                        child: const Icon(Icons.print, color: Colors.white))
            //         :
            // FloatingActionButton.small(
            //             backgroundColor: appBackgroundColor,
            //             onPressed: () async {
            //               print(passTicketNo);
            //               // ticketUpdateVehicle(
            //               //     vehicleNumber: searchvehicle.text);
            //               // await channel.invokeMethod("outPrint", {
            //               //   "data": get.getglobaldata['outticketDetails'],
            //               //   "company_Id": companyNumber,
            //               //   "ticketNo": searchvehicle.text,
            //               //   "locationId": locationId,
            //               //   "type": "vehicle",
            //               //   "Ticket_Date": get.getglobaldata['outticketDetails']
            //               //           ['Ticket_Date']
            //               //       .toString(),
            //               //   "Out_date": get.getglobaldata['outticketDetails']
            //               //           ['Out_date']
            //               //       .toString(),
            //               //   "Parking_Time": get
            //               //       .getglobaldata['outticketDetails']
            //               //           ['Parking_Time']
            //               //       .toString(),
            //               //   "Ticket_No": get.getglobaldata['outticketDetails']
            //               //           ['Ticket_No']
            //               //       .toString(),
            //               //   "Vehicle_Rate": get
            //               //       .getglobaldata['outticketDetails']
            //               //           ['Vehicle_Rate']
            //               //       .toString(),
            //               //   "Vehicle_No": get.getglobaldata['outticketDetails']
            //               //           ['Vehicle_No']
            //               //       .toString(),
            //               // });
            //               // getOpen();
            //               ticketUpdate(ticketNumber: passTicketNo);
            //               await channel.invokeMethod("outPrint", {
            //                 "data": get.getglobaldata['outticketDetails'],
            //                 "company_Id": companyNumber,
            //                 "ticketNo":passTicketNo,
            //                 "locationId": locationId,
            //                 "type": "ticket",
            //                 "Ticket_Date": get.getglobaldata['outticketDetails']
            //                 ['Ticket_Date']
            //                     .toString(),
            //                 "Out_date": get.getglobaldata['outticketDetails']
            //                 ['Out_date']
            //                     .toString(),
            //                 "Parking_Time": get
            //                     .getglobaldata['outticketDetails']
            //                 ['Parking_Time']
            //                     .toString(),
            //                 "Ticket_No": get.getglobaldata['outticketDetails']
            //                 ['Ticket_No']
            //                     .toString(),
            //                 "Vehicle_Rate": get
            //                     .getglobaldata['outticketDetails']
            //                 ['Vehicle_Rate']
            //                     .toString(),
            //                 "Vehicle_No": get.getglobaldata['outticketDetails']
            //                 ['Vehicle_No']
            //                     .toString(),
            //               });
            //
            //               getOpen();
            //             },
            //             child: const Icon(Icons.print, color: Colors.white))
                : const SizedBox());
  }
  Future<void> getVehicleNOApi({required String vehicleNo}) async {

    var get = Provider.of<GlobalProvider>(context, listen: false);
    String companyNumber = get.getglobaldata['companyNumber'];
    String locationId = get.getglobaldata['locationid'].toString() ?? '';
    loaderdata = true ;
    setState(() {

    });
    var reponse = await http.get(Uri.parse(
        '$baseUrl1/GetVehicleNo?Ticket_No=$vehicleNo&Company_Id=$companyNumber&LocationName=$locationId'));

    if (reponse.statusCode == 200) {
      var data = jsonDecode(reponse.body);
      if (data['status'].toString() == '1') {

        vehicleList=data['body'];
        setState(() {

        });
      } else {
        vehicleList.clear();
        if (mounted) FocusScope.of(context).requestFocus(firstFocus);
      }
    }
    loaderdata = false ;
    setState(() {

    });
  }
  Future<void> checkOutprintflagDetails({required String ticketNo}) async {
    var get = Provider.of<GlobalProvider>(context, listen: false);
    String companyNumber = get.getglobaldata['companyNumber'];
    var reponse = await http.get(Uri.parse(
        '$baseUrl1/getCheckOutprintflagDetails?Ticket_No=$ticketNo&Company_Id=$companyNumber'));

    if (reponse.statusCode == 200) {
      var data = jsonDecode(reponse.body);
      if (data['status'].toString() == '0') {
        sendOutdate();
      } else
      {
        searchticket.clear();
        setState(() {
          checkticketprint = true;
        });
        if (mounted) FocusScope.of(context).requestFocus(firstFocus);
      }
    }
  }


  Future<void> checkOutprintflagDetailsForVehicle({required String ticketNo}) async {
    var get = Provider.of<GlobalProvider>(context, listen: false);
    String companyNumber = get.getglobaldata['companyNumber'];
    var reponse = await http.get(Uri.parse(
        '$baseUrl1/getCheckOutprintflagDetails?Ticket_No=$ticketNo&Company_Id=$companyNumber'));

    if (reponse.statusCode == 200) {
      var data = jsonDecode(reponse.body);
      if (data['status'].toString() == '0') {
        sendOutdateVehicleNO(ticketNo);
      } else {
        searchticket.clear();
        setState(() {
          checkticketprint = true;
        });
        if (mounted) FocusScope.of(context).requestFocus(firstFocus);
      }
    }
  }


  Future<void> newAPi({required String vehicleNo}) async {
    var get = Provider.of<GlobalProvider>(context, listen: false);
    String companyNumber = get.getglobaldata['companyNumber'];
    var reponse = await http.get(Uri.parse(
        '$baseUrl1/getCheckOutprintflagDetails?Ticket_No=$vehicleNo&Company_Id=$companyNumber'));

    if (reponse.statusCode == 200) {
      var data = jsonDecode(reponse.body);
      if (data['status'].toString() == '0') {
        await newSendOutdate();
        // if(data['Message']=='Failure'){
        //   searchvehicle.clear();
        //   setState(() {
        //     checkVehicleprint = true;
        //   });
        //   if (mounted) FocusScope.of(context).requestFocus(firstFocus);
        // }
      } else {
        searchvehicle.clear();
        setState(() {
          checkVehicleprint = true;
        });
        if (mounted) FocusScope.of(context).requestFocus(firstFocus);
      }
    }
  }

  Future<void> ticketUpdate({required String ticketNumber}) async {
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    String companyNumber = get.getglobaldata['companyNumber'];
    var response = await http.get(
      Uri.parse(
          '$baseUrl1/UpdateOutPrintflag?Ticket_No=$ticketNumber&Company_Id=$companyNumber'),
    );
    if (response.statusCode == 200) {
      searchticket.clear();
      set.clearglobaldata('outticketDetails');
      if (mounted) FocusScope.of(context).requestFocus(firstFocus);
    }
  }

  Future<void> ticketUpdateVehicle({required String vehicleNumber}) async {
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    String companyNumber = get.getglobaldata['companyNumber'];
    var response = await http.get(
      Uri.parse(
          '$baseUrl1/UpdateOutPrintflagVehicleNo?Ticket_No=$vehicleNumber&Company_Id=$companyNumber'),
    );
    if (response.statusCode == 200) {
      searchvehicle.clear();
      set.clearglobaldata('outticketDetails');
      if (mounted) FocusScope.of(context).requestFocus(firstFocus);
    }
  }

  Future<void> sendOutdate() async {
    setState(() {
      loaderdata = true;
    });
    var ticketNo = searchticket.text;
    var get = Provider.of<GlobalProvider>(context, listen: false);
    String companyNumber = get.getglobaldata['companyNumber'];
    var response = await http.get(
      Uri.parse(
          '$baseUrl1/UpdateTicketOutDate?Ticket_No=$ticketNo&Out_Date=$datenow&paymentMode=cash&Company_Id=$companyNumber'),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "0") {
        setState(() {
          isavaible = false;

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text(
                    "Ticket no/Vehicle no not found",
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        loaderdata = false;
                        var set = context.read<GlobalProvider>();

                        set.clearglobaldata('outticketDetails');
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(fontSize: 12, color: yellow),
                      ),
                    )
                  ],
                );
              });
        });
      } else {
        setState(() {
          isavaible = true;
        });
        await Future.delayed(const Duration(milliseconds: 300));
        getOuterticket();
      }
    }
  }
  Future<void> sendOutdateVehicleNO(ticketNo) async {
    setState(() {
      loaderdata = true;
    });

    var get = Provider.of<GlobalProvider>(context, listen: false);
    String companyNumber = get.getglobaldata['companyNumber'];
    var response = await http.get(
      Uri.parse(
          '$baseUrl1/UpdateTicketOutDate?Ticket_No=$ticketNo&Out_Date=$datenow&paymentMode=cash&Company_Id=$companyNumber'),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "0") {
        setState(() {
          isavaible = false;

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text(
                    "Ticket no/Vehicle no not found",
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        loaderdata = false;
                        var set = context.read<GlobalProvider>();

                        set.clearglobaldata('outticketDetails');
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(fontSize: 12, color: yellow),
                      ),
                    )
                  ],
                );
              });
        });
      } else {
        setState(() {
          isavaible = true;
        });
        await Future.delayed(const Duration(milliseconds: 300));
        getOuterticketVehicle(ticketNo);
      }
    }
  }
  Future<void> newSendOutdate() async {
    setState(() {
      loaderdata = true;
    });
    var vehicleNO = searchvehicle.text;
    var get = Provider.of<GlobalProvider>(context, listen: false);
    String companyNumber = get.getglobaldata['companyNumber'];
    var response = await http.get(
      Uri.parse(
          '$baseUrl1/UpdateTicketOutDate?Ticket_No=$vehicleNO&Out_Date=$datenow&paymentMode=cash&Company_Id=$companyNumber'),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "0") {
        setState(() {
          isavaible = false;

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text(
                    "Vehicle no not found",
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        loaderdata = false;
                        var set = context.read<GlobalProvider>();

                        set.clearglobaldata('outticketDetails');
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(fontSize: 12, color: yellow),
                      ),
                    )
                  ],
                );
              });
        });
      } else {
        setState(() {
          isavaible = true;
        });
        await Future.delayed(const Duration(milliseconds: 300));
        newGetOuterticket();
      }
    }
  }

  Future<void> newGetOuterticket() async {
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    String companyNumber = get.getglobaldata['companyNumber'];
    var locationId = get.getglobaldata['locationid'] ?? '';
    var vehicleNO = searchvehicle.text;
    // var response = await http.get(
    //   Uri.parse('$baseUrl1/GetCalculateParkingPriceNew?Ticket_No=$ticketNo&Company_Id=$companyNumber&LocationName=$locationId'),
    // );
    // if (response.statusCode == 200) {
    //   var ticketNo = jsonDecode(response.body);
    //   set.setglobaldata('outticketDetails', ticketNo[0]);
    // }

    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl1/GetCalculateParkingPriceNewVehicleNo?Ticket_No=$vehicleNO&Company_Id=$companyNumber&LocationName=$locationId'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = (await response.stream.bytesToString());
      var ticketNo = jsonDecode(data);
      set.setglobaldata('outticketDetails', ticketNo[0]);

      if (get.getglobaldata['outticketDetails'] != null &&
          get.getglobaldata['outticketDetails'].length != 0 &&
          get.getglobaldata['outticketDetails'].isNotEmpty) {
        print('data is there');
      } else {
        searchvehicle.clear();
        setState(() {
          checkVehicleprint = true;
        });
        if (mounted) FocusScope.of(context).requestFocus(firstFocus);
      }
    } else {
      print(response.reasonPhrase);
    }

    setState(() {
      loaderdata = false;
    });
  }

  Future<void> getOuterticket() async {
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    String companyNumber = get.getglobaldata['companyNumber'];
    var locationId = get.getglobaldata['locationid'] ?? '';
    var ticketNo = searchticket.text;
    // var response = await http.get(
    //   Uri.parse('$baseUrl1/GetCalculateParkingPriceNew?Ticket_No=$ticketNo&Company_Id=$companyNumber&LocationName=$locationId'),
    // );
    // if (response.statusCode == 200) {
    //   var ticketNo = jsonDecode(response.body);
    //   set.setglobaldata('outticketDetails', ticketNo[0]);
    // }

    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl1/GetCalculateParkingPriceNewDynamic?Ticket_No=$ticketNo&Company_Id=$companyNumber&LocationName=$locationId'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = (await response.stream.bytesToString());
      var ticketNo = jsonDecode(data);
      set.setglobaldata('outticketDetails', ticketNo[0]);
    } else {
      print(response.reasonPhrase);
    }

    setState(() {
      loaderdata = false;
    });
  }

  Future<void> getOuterticketVehicle(ticketNO) async {
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    String companyNumber = get.getglobaldata['companyNumber'];
    var locationId = get.getglobaldata['locationid'] ?? '';

    // var response = await http.get(
    //   Uri.parse('$baseUrl1/GetCalculateParkingPriceNew?Ticket_No=$ticketNo&Company_Id=$companyNumber&LocationName=$locationId'),
    // );
    // if (response.statusCode == 200) {
    //   var ticketNo = jsonDecode(response.body);
    //   set.setglobaldata('outticketDetails', ticketNo[0]);
    // }

    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl1/GetCalculateParkingPriceNewDynamic?Ticket_No=$ticketNO&Company_Id=$companyNumber&LocationName=$locationId'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = (await response.stream.bytesToString());
      var ticketNo = jsonDecode(data);
      set.setglobaldata('outticketDetails', ticketNo[0]);
    } else {
      print(response.reasonPhrase);
    }

    setState(() {
      loaderdata = false;
    });
  }


  Future<void> getOpen() async {
    var get = Provider.of<GlobalProvider>(context, listen: false);
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('http://ac.vidaniautomations.com/cmd'));
    request.body = json.encode({
      "serialNo": get.getglobaldata['outControllerId'],
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
}
