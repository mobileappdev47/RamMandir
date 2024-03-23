// To parse this JSON data, do
//
//     final parkingModel = parkingModelFromJson(jsonString);

import 'dart:convert';

List<ParkingModel> parkingModelFromJson(String str) => List<ParkingModel>.from(
    json.decode(str).map((x) => ParkingModel.fromJson(x)));

String parkingModelToJson(List<ParkingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ParkingModel {
  String? url;
  String? vehicleType;
  int? amount;

  ParkingModel({
    this.url,
    this.vehicleType,
    this.amount,
  });

  factory ParkingModel.fromJson(Map<dynamic, dynamic> json) => ParkingModel(
        url: json["Url"],
        vehicleType: json["Vehicle_Type"],
        amount: json["Amount"],
      );

  Map<dynamic, dynamic> toJson() => {
        "Url": url,
        "Vehicle_Type": vehicleType,
        "Amount": amount,
      };
}
