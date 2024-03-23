import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool status;
  Data data;
  String message;

  Welcome({
    required this.status,
    required this.data,
    required this.message,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  int id;
  String name;
  String email;
  String amount;
  String merchantTxn;
  String phone;
  int paymentMade;
  String state;
  int smsCount;
  int emailCount;
  dynamic message;
  dynamic udf1;
  dynamic udf2;
  dynamic udf3;
  dynamic udf4;
  dynamic udf5;
  String expiryDate;
  dynamic quickPayTransactionDate;
  dynamic offlinePaymentId;
  dynamic offlinePaymentDesc;
  dynamic offlinePaymentMode;
  DateTime createdDate;
  DateTime updatedDate;
  String minAmount;
  String maxAmount;
  int smsChannelCount;
  int emailChannelCount;
  int smsCredit;
  int emailCredit;
  String transactionId;
  dynamic submerchantId;
  int whatsappCount;
  int whatsappChannelCount;
  int whatsappCredit;
  dynamic splitPayments;
  int obdCount;
  int obdCredit;
  String paymentType;
  bool isAutoDebitLink;
  dynamic authDetails;
  bool isAutoDebitSeamless;
  String entityType;
  String paymentUrl;

  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.amount,
    required this.merchantTxn,
    required this.phone,
    required this.paymentMade,
    required this.state,
    required this.smsCount,
    required this.emailCount,
    this.message,
    this.udf1,
    this.udf2,
    this.udf3,
    this.udf4,
    this.udf5,
    required this.expiryDate,
    this.quickPayTransactionDate,
    this.offlinePaymentId,
    this.offlinePaymentDesc,
    this.offlinePaymentMode,
    required this.createdDate,
    required this.updatedDate,
    required this.minAmount,
    required this.maxAmount,
    required this.smsChannelCount,
    required this.emailChannelCount,
    required this.smsCredit,
    required this.emailCredit,
    required this.transactionId,
    this.submerchantId,
    required this.whatsappCount,
    required this.whatsappChannelCount,
    required this.whatsappCredit,
    this.splitPayments,
    required this.obdCount,
    required this.obdCredit,
    required this.paymentType,
    required this.isAutoDebitLink,
    this.authDetails,
    required this.isAutoDebitSeamless,
    required this.entityType,
    required this.paymentUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        amount: json["amount"],
        merchantTxn: json["merchant_txn"],
        phone: json["phone"],
        paymentMade: json["payment_made"],
        state: json["state"],
        smsCount: json["sms_count"],
        emailCount: json["email_count"],
        message: json["message"],
        udf1: json["udf1"],
        udf2: json["udf2"],
        udf3: json["udf3"],
        udf4: json["udf4"],
        udf5: json["udf5"],
        expiryDate: json["expiry_date"],
        quickPayTransactionDate: json["quick_pay_transaction_date"],
        offlinePaymentId: json["offline_payment_id"],
        offlinePaymentDesc: json["offline_payment_desc"],
        offlinePaymentMode: json["offline_payment_mode"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedDate: DateTime.parse(json["updated_date"]),
        minAmount: json["min_amount"],
        maxAmount: json["max_amount"],
        smsChannelCount: json["sms_channel_count"],
        emailChannelCount: json["email_channel_count"],
        smsCredit: json["sms_credit"],
        emailCredit: json["email_credit"],
        transactionId: json["transaction_id"],
        submerchantId: json["submerchant_id"],
        whatsappCount: json["whatsapp_count"],
        whatsappChannelCount: json["whatsapp_channel_count"],
        whatsappCredit: json["whatsapp_credit"],
        splitPayments: json["split_payments"],
        obdCount: json["obd_count"],
        obdCredit: json["obd_credit"],
        paymentType: json["payment_type"],
        isAutoDebitLink: json["is_auto_debit_link"],
        authDetails: json["auth_details"],
        isAutoDebitSeamless: json["is_auto_debit_seamless"],
        entityType: json["entity_type"],
        paymentUrl: json["payment_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "amount": amount,
        "merchant_txn": merchantTxn,
        "phone": phone,
        "payment_made": paymentMade,
        "state": state,
        "sms_count": smsCount,
        "email_count": emailCount,
        "message": message,
        "udf1": udf1,
        "udf2": udf2,
        "udf3": udf3,
        "udf4": udf4,
        "udf5": udf5,
        "expiry_date": expiryDate,
        "quick_pay_transaction_date": quickPayTransactionDate,
        "offline_payment_id": offlinePaymentId,
        "offline_payment_desc": offlinePaymentDesc,
        "offline_payment_mode": offlinePaymentMode,
        "created_date": createdDate.toIso8601String(),
        "updated_date": updatedDate.toIso8601String(),
        "min_amount": minAmount,
        "max_amount": maxAmount,
        "sms_channel_count": smsChannelCount,
        "email_channel_count": emailChannelCount,
        "sms_credit": smsCredit,
        "email_credit": emailCredit,
        "transaction_id": transactionId,
        "submerchant_id": submerchantId,
        "whatsapp_count": whatsappCount,
        "whatsapp_channel_count": whatsappChannelCount,
        "whatsapp_credit": whatsappCredit,
        "split_payments": splitPayments,
        "obd_count": obdCount,
        "obd_credit": obdCredit,
        "payment_type": paymentType,
        "is_auto_debit_link": isAutoDebitLink,
        "auth_details": authDetails,
        "is_auto_debit_seamless": isAutoDebitSeamless,
        "entity_type": entityType,
        "payment_url": paymentUrl,
      };
}
