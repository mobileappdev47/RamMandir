import "package:flutter/material.dart";

class GlobalProvider extends ChangeNotifier {


  final Map<String, dynamic> _globaldata = {
    'hideField': true,
    'testNumber': 2,
    'checkparking': false,
    'selectstate': '',
    'disable': false,
    'selectvehical': false,
    'errorHanlde': false,
    'mallEntrytime': '',
    'paymentUrl': '',
    'paymenturl': [],
    'uniqueId': '',
    'appbarTitle': '',
    'paymentMode': '',
    'ticketNo': '',
    'GetParkingALLDetails': [],
    'totalCollect': '',
    'numberplaterNumber': '',
    'imagename': '',
    'btnopt': false,
    'selectState': '',
    'amount': '',
    'inputerror': false,
    'selectVehicle': '',
    'printFlag': '',
    'starRate': '',
    'decryptTicketNumber': '',
    'Contractor_Id': 0,
    'outticketDetails': [],
    'menuIndex': 0,
    'companyLocationName': '',
    'companyNumber': '',
    'companyLocationaddress': '',
    'userId': '',
    'inprintdata': [],
    'vehiclerate': [],
    'controllerId': '',
    'locationid': '',
    'outControllerId': ''
  };
  get getglobaldata => _globaldata;

  void setglobaldata(name, val) {
    _globaldata[name] = val;
    notifyListeners();
  }

  void clearglobaldata(name) {
    _globaldata[name] = [];
    notifyListeners();
  }
}
