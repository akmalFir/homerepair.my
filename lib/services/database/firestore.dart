import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_repair_service/model/request_model.dart';
import 'package:home_repair_service/services/auth/auth_service.dart';

class FirestoreService {
  FirebaseAuth auth = FirebaseAuth.instance;

  // get collection of users
  final CollectionReference rf =
      FirebaseFirestore.instance.collection('requestForm');

  // get collection of users
  final CollectionReference ar =
      FirebaseFirestore.instance.collection('addRepair');

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  //Instantiate Firestore
  final db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getRequestFormId() async {
    QuerySnapshot snapshot = await db.collection('requestForm').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // Function to Add data to database
  void requestService({
    serviceName,
    description,
    price,
    time,
    serviceCategory,
    address,
    address2,
    state,
    city,
    poscode,
    reqId,
    userId,
    status,
    requestTime,
    providerId,
  }) async {
    final docRef = db.collection('requestForm').doc();

    RequestModel requestForm = RequestModel(
      serviceName: serviceName,
      description: description,
      price: price,
      time: time,
      serviceCategory: serviceCategory,
      address: address,
      address2: address2,
      state: state,
      city: city,
      poscode: poscode,
      reqId: docRef.id,
      userId: userId,
      status: status,
      requestTime: requestTime,
      providerId: providerId,
    );

    //Add document to Firestore with an auto-generated Id
    await docRef.set(requestForm.toJson()).then(
        (value) => print("Request service successful!"),
        onError: (e) => print("Error request service: $e"));
  }

// Delete request data from database
  void cancelRequest({reqId}) async {
    final docRef = db.collection('requestForm').doc(reqId);

    // Delete document from Firestore
    await docRef.delete().then(
        (value) => print("Request deleted successfully!"),
        onError: (e) => print("Error deleting request: $e"));
  }

  // Function to Update profile from database
  void updateProfile(String name, String phone) {
    //Set updated data for selected appointment
    AuthService authService = AuthService();
    final users = authService.getCurrentUser();
    db.collection('users').doc(users!.uid)
      ..update({'name': name})
      ..update({'phone': phone}).then(
          (value) => print("Profile Updated Successfully!"),
          onError: (e) => print("Error updating profile: $e"));
  }

  Future<void> updateServiceRequest({
    time,
    reqId,
    userId,
    required BuildContext context,
  }) async {
    try {
      DocumentReference requestRef =
          FirebaseFirestore.instance.collection('requestForm').doc(reqId);

      await requestRef.update({
        'time': time.toString(),
        'reqId': reqId,
        'userId': userId,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Service request updated successfully"),
        ),
      );
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating service request: $error"),
        ),
      );
    }
  }
}
