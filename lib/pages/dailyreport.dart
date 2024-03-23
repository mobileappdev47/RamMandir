import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as client;
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';
import '../constants/constant.dart';
import '../utils/color.dart';
import 'globalProvider.dart';

class DailyReport extends StatefulWidget {
  const DailyReport({super.key});

  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  var currentDate = DateTime.now();
  bool loader = false;

  TextEditingController dateData = TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    setState(() {
      loader = true;
    });
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != currentDate) {
      setState(() {
        currentDate = picked;
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(picked);
        dateData.text = formatted;
        getParkingALLDetails(date: formatted);
      });
    }
    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(currentDate);
    getParkingALLDetails(date: formatted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var get = Provider.of<GlobalProvider>(context, listen: false);
    return Placeholder(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
                "Daily Report"), /* actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  getParkingDailyTtalCollectionDetails();
                  getParkingALLDetails();
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.refresh),
              ),
            )
          ] */
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: dateData,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  selectDate(context);
                                },
                                child: const Icon(Icons.calendar_month)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.grey,
                margin: const EdgeInsets.all(12),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(children: [
                            Text(
                              "Cash",
                              style: TextStyle(color: Colors.white),
                            ),
                            Divider(),
                            Text(
                              "₹ 200",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ]),
                        ),
                        Expanded(
                          child: Column(children: [
                            Text(
                              "Online",
                              style: TextStyle(color: Colors.white),
                            ),
                            Divider(),
                            Text(
                              "₹ 200",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ]),
                        ),
                        Expanded(
                          child: Column(children: [
                            Text(
                              "FastTag",
                              style: TextStyle(color: Colors.white),
                            ),
                            Divider(),
                            Text(
                              "₹ 200",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ]),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              get.getglobaldata['GetParkingALLDetails'].toString() != "[]"
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: DataTable2(
                            columnSpacing: 10,
                            dataRowColor:
                                MaterialStateProperty.all(appBackgroundColor),
                            dataTextStyle: const TextStyle(fontSize: 14),
                            minWidth: 600,
                            dividerThickness: 1.0,
                            sortColumnIndex: 4,
                            headingRowColor:
                                MaterialStateProperty.all(Colors.grey),
                            headingTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            columns: const [
                              DataColumn2(
                                label: Text('Ticket No'),
                                size: ColumnSize.L,
                              ),
                              DataColumn(
                                label: Text('Vehicle No'),
                              ),
                              DataColumn(
                                label: Text('In Date'),
                              ),
                              DataColumn(
                                label: Text('Out Date'),
                              ),
                              DataColumn(
                                label: Text('Parking Charges'),
                                numeric: true,
                              ),
                            ],
                            rows: List<DataRow>.generate(
                                get.getglobaldata['GetParkingALLDetails']
                                    .length, (index) {
                              var report = get
                                  .getglobaldata['GetParkingALLDetails'][index];
                              return DataRow(cells: [
                                DataCell(Text(report['Ticket_No'].toString())),
                                DataCell(Text(report['Vehicle_No'].toString())),
                                DataCell(
                                    Text(report['Ticket_Date'].toString())),
                                DataCell(Text(report['Out_Date'].toString())),
                                DataCell(
                                    Text(report['Vehicle_Rate'].toString()))
                              ]);
                            })),
                      ),
                    )
                  : const Expanded(child: Center(child: Text("Data Not Found")))
            ],
          )),
    );
  }

  Future<void> getParkingALLDetails({required String date}) async {
    setState(() {
      loader = true;
    });
    var set = context.read<GlobalProvider>();
    var get = Provider.of<GlobalProvider>(context, listen: false);
    var companyNumber = get.getglobaldata['companyNumber'];
    var deviceId = get.getglobaldata['uniqueId'];
    var response = await client.get(Uri.parse(
        '$baseUrl1/GetParkingALLDetails?Company_Id=$companyNumber&Ticket_Date=$date&Device_Id=$deviceId'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "1") {
        set.setglobaldata('GetParkingALLDetails', data['body']);
      } else {
        set.setglobaldata('GetParkingALLDetails', []);
        const snackBar = SnackBar(
          content: Text('Not Found Data'),
        );
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    setState(() {
      loader = false;
    });
  }
}
