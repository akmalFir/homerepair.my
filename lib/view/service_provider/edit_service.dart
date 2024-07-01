import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_repair_service/component/snack_bar_component.dart';
import 'package:home_repair_service/model/service_options.dart';
import 'package:home_repair_service/services/database/firestore.dart';

class EditService extends StatefulWidget {
  final String serviceId;
  const EditService({super.key, required this.serviceId});

  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController serviceDescriptionController = TextEditingController();
  TextEditingController servicePriceController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  final User user = FirebaseAuth.instance.currentUser!;

  //Service options
  ServiceOption serviceOption = ServiceOption();
  String selectedService = "Ceiling Fans Install";

  void fetchService(String serviceId) {
    // Fetch the service request data from Firestore using the request ID
    DocumentReference requestRef = FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(user.uid)
        .collection('services')
        .doc(serviceId);

    requestRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> requestData =
            documentSnapshot.data() as Map<String, dynamic>;
        // Populate the UI fields with the existing service request data
        setState(() {
          selectedService = requestData['serviceName'];
          serviceDescriptionController.text = requestData['serviceDescription'];
          servicePriceController.text = requestData['servicePrice'].toString();
        });
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  // Function to update service
  void updateService() {
    String serviceId = widget.serviceId;
    DocumentReference requestRef = FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(user.uid)
        .collection('services')
        .doc(serviceId);

    requestRef.update({
      'serviceName': selectedService,
      'serviceDescription': serviceDescriptionController.text,
      'servicePrice': servicePriceController.text,
      'serviceCategory': "Electrical",
    }).then((_) {
      // Show success message
      SnackbarComponent.showSnackbar(context, "Service successfully updated");
    }).catchError((error) {
      // Show error message
      SnackbarComponent.showSnackbar(context, "Error updating service: $error");
    });
  }

  // Function to delete service
  void deleteService() {
    String serviceId = widget.serviceId;
    DocumentReference requestRef = FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(user.uid)
        .collection('services')
        .doc(serviceId);

    requestRef.delete().then((_) {
      Navigator.pop(context);
    }).catchError((error) {
      // Show error message
      SnackbarComponent.showSnackbar(context, "Error deleting service: $error");
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch the existing service request data based on the provided request ID
    fetchService(widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffffffff),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Electrical Service",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xff000000),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff212435),
            size: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Align(
                alignment: Alignment(-0.9, 0.0),
                child: Text(
                  "Select Repair Type",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  border: Border.all(color: const Color(0xff000000), width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedService,
                    items: serviceOption.services.map((services) {
                      return DropdownMenuItem<String>(
                        value: services,
                        child: Text(
                          services,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedService = value!;
                      });
                    },
                    dropdownColor: Colors.purple[50],
                    elevation: 0,
                    isExpanded: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
                width: 16,
              ),
              const Align(
                alignment: Alignment(-0.9, 0.0),
                child: Text(
                  "Description",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              TextFormField(
                controller: serviceDescriptionController,
                obscureText: false,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        const BorderSide(color: Color(0xff000000), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        const BorderSide(color: Color(0xff000000), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        const BorderSide(color: Color(0xff000000), width: 1),
                  ),
                  hintText: "",
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  isDense: false,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description of the repair';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
                width: 16,
              ),
              const Align(
                alignment: Alignment(-0.9, 0.0),
                child: Text(
                  "Price",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              TextFormField(
                controller: servicePriceController,
                obscureText: false,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        const BorderSide(color: Color(0xff000000), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        const BorderSide(color: Color(0xff000000), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        const BorderSide(color: Color(0xff000000), width: 1),
                  ),
                  hintText: "",
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  isDense: false,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
                width: 16,
              ),
              const SizedBox(height: 20),
              MaterialButton(
                onPressed: () {
                  updateService();
                },
                color: Colors.purple,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(color: Color(0xffffffff), width: 1),
                ),
                padding: const EdgeInsets.all(16),
                textColor: const Color(0xffffffff),
                height: 45,
                minWidth: MediaQuery.of(context).size.width,
                child: const Text(
                  "Update Service",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              MaterialButton(
                onPressed: () {
                  deleteService();
                },
                color: Colors.purple,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(color: Color(0xffffffff), width: 1),
                ),
                padding: const EdgeInsets.all(16),
                textColor: const Color(0xffffffff),
                height: 45,
                minWidth: MediaQuery.of(context).size.width,
                child: const Text(
                  "Delete Service",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
