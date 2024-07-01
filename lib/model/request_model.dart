import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String serviceName;
  final String serviceCategory;
  final String address;
  final String address2;
  final String state;
  final String city;
  final String? description;
  final double? price;
  final DateTime time;
  final int? quantity;
  final String? imgPath;
  final String poscode;
  final String? reqId;
  final String? userId;
  final String? status;
  final String? requestTime;
  final String? providerId;

  RequestModel({
    required this.serviceName,
    required this.serviceCategory,
    required this.address,
    required this.address2,
    required this.state,
    required this.city,
    this.description,
    this.price,
    required this.time,
    this.quantity,
    this.imgPath,
    required this.poscode,
    this.reqId,
    this.userId,
    this.status,
    this.requestTime,
    this.providerId,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      serviceName: json['serviceName'] as String,
      description: json['description'] as String?,
      price: json['price'] as double?,
      time: json['time'] != null
          ? (json['time'] is Timestamp
              ? (json['time'] as Timestamp)
                  .toDate() // Convert Timestamp to DateTime
              : DateTime.parse(
                  json['time'] as String)) // Parse DateTime from String
          : DateTime.now(),
      serviceCategory: json['serviceCategory'] as String,
      quantity: json['quantity'] as int?,
      imgPath: json['imgPath'] as String?,
      address: json['address'] as String,
      address2: json['address2'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
      poscode: json['poscode'] as String,
      reqId: json['reqId'] as String?,
      userId: json['userId'] as String?,
      status: json['status'] as String?,
      requestTime: json['requestTime'] as String?,
      providerId: json['providerId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceName,
      'description': description,
      'price': price,
      'time': time.toIso8601String(),
      'serviceCategory': serviceCategory,
      'address': address,
      'address2': address2,
      'state': state,
      'city': city,
      'poscode': poscode,
      'reqId': reqId,
      'userId': userId,
      'status': status,
      'requestTime': requestTime,
      'providerId': providerId,
    };
  }

  String getDate() {
    return "${time.day}-${time.month}-${time.year}";
  }

  String getTime() {
    String period;
    int times = time.hour;
    if (times < 13) {
      period = "AM";
    } else {
      times = times - 12;
      period = "PM";
    }

    String min;
    if (time.minute == 0) {
      min = "00";
    } else {
      min = time.minute.toString();
    }
    // return "${time.hour.toString()}:$min";
    return "$times:$min $period";
  }
}
