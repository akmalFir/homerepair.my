import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_repair_service/component/snack_bar_component.dart';
import 'package:home_repair_service/model/address.dart';
import 'package:home_repair_service/model/service_options.dart';
import 'package:home_repair_service/services/database/firestore.dart';
import 'package:home_repair_service/view/homeowner/hm_dashboard.dart';

class EditRequest extends StatefulWidget {
  final String requestId; // Add a field to store the request ID
  const EditRequest({
    super.key,
    required this.requestId,
  });

  @override
  State<EditRequest> createState() => _EditRequestState();
}

class _EditRequestState extends State<EditRequest> {
  FirestoreService firestoreService = FirestoreService();
  final user = FirebaseAuth.instance.currentUser!;

  final TextEditingController addressController = TextEditingController();
  final TextEditingController addressController2 = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController poscodeController = TextEditingController();

  //Service options
  ServiceOption serviceOption = ServiceOption();
  String selectedService = "Ceiling Fans Install";

  //City and States
  String selectedState = 'Selangor';
  String selectedCity = 'Gombak';
  Address address = Address();

  //Date Time Selector
  int _selectedHour = 11;
  String _selectedMinute = "00";
  String _selectedPeriod = 'AM';

  final List<int> hoursList = List.generate(11, (index) => index + 1);
  final List<String> minutesList = ["00", "30"];
  final List<String> periodList = ['AM', 'PM'];
  DateTime? finalDateTime;
  DateTime _selectedDate = DateTime.now();

//date function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

//handle time change
  void _handleHourChange(int? value) {
    setState(() {
      _selectedHour = value!;
    });
  }

  void _handleMinuteChange(String? value) {
    setState(() {
      _selectedMinute = value!;
    });
  }

  void _handlePeriodChange(String? value) {
    setState(() {
      _selectedPeriod = value!;
    });
  }

// get date and time
  DateTime _getSelectedDateTime() {
    int parsedMinute = int.parse(_selectedMinute);
    int hour = _selectedPeriod == 'PM' ? _selectedHour + 12 : _selectedHour;
    return DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day,
        hour, parsedMinute);
  }

  void updateSelectedDateTime() {
    DateTime selectedDateTime = _getSelectedDateTime();
    finalDateTime = selectedDateTime;
  }

  void fetchServiceRequest(String requestId) {
    // Fetch the service request data from Firestore using the request ID
    DocumentReference requestRef =
        FirebaseFirestore.instance.collection('requestForm').doc(requestId);

    requestRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> requestData =
            documentSnapshot.data() as Map<String, dynamic>;
        DateTime requestedData = DateTime.parse(requestData['time'] as String);
        // Populate the UI fields with the existing service request data
        setState(() {
          selectedService = requestData['serviceName'] ?? "";
          descriptionController.text = requestData['description'] ?? "";
          addressController.text = requestData['address'] ?? "";
          addressController2.text = requestData['address2'] ?? "";
          selectedState = requestData['state'] ?? "";
          selectedCity = requestData['city'] ?? "";
          poscodeController.text = requestData['poscode'] ?? "";
          _selectedDate = requestedData;
        });
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  // Function to update service request
  void updateServiceRequest() {
    String requestId = widget.requestId; // Use the provided request ID
    DocumentReference requestRef =
        FirebaseFirestore.instance.collection('requestForm').doc(requestId);

    requestRef.update({
      'serviceName': selectedService,
      'description': descriptionController.text,
      'address': addressController.text,
      'address2': addressController2.text,
      'city': selectedCity,
      'state': selectedState,
      'poscode': poscodeController.text,
      'time': finalDateTime,
    }).then((_) {
      // Show success message
      SnackbarComponent.showSnackbar(
          context, "Service request updated successfully");
    }).catchError((error) {
      // Show error message
      SnackbarComponent.showSnackbar(
          context, "Error updating service request: $error");
    });
  }

  // Function to delete service request
  void deleteServiceRequest() {
    String requestId = widget.requestId; // Use the provided request ID
    DocumentReference requestRef =
        FirebaseFirestore.instance.collection('requestForm').doc(requestId);

    requestRef.delete().then((_) {
      /* // Show success message
      SnackbarComponent.showSnackbar(
          context, "Service request deleted successfully"); */
      // Optionally, navigate back to the previous screen after deletion
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: ((context) => const HMDashboard())));
    }).catchError((error) {
      // Show error message
      SnackbarComponent.showSnackbar(
          context, "Error deleting service request: $error");
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch the existing service request data based on the provided request ID
    fetchServiceRequest(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, //When false, blocks the current route from being popped.
      onPopInvoked: (didPop) {
        //do your logic here:`
      },
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HMDashboard()));
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xff212435),
              size: 24,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                //Date Selector
                Text(
                    'Selected Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff000000),
                    )),
                const SizedBox(height: 10),
                MaterialButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  color: const Color(0xffffffff),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(color: Color(0xff3a57e8), width: 1),
                  ),
                  padding: const EdgeInsets.all(16),
                  textColor: const Color(0xff3a57e8),
                  height: 45,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Select Date",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                //Time Selector
                Text(
                  'Selected Time: ${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} $_selectedPeriod',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Hour
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                            color: const Color(0xff000000), width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          dropdownColor: Colors.blue[100],
                          elevation: 0,
                          isExpanded: true,
                          value: _selectedHour,
                          onChanged: _handleHourChange,
                          items: hoursList.map((value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString().padLeft(2, '0')),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    //Minute
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                            color: const Color(0xff000000), width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: Colors.blue[100],
                          elevation: 0,
                          isExpanded: true,
                          value: _selectedMinute,
                          onChanged: _handleMinuteChange,
                          items: minutesList.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.toString().padLeft(2, '0')),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    //Period
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                            color: const Color(0xff000000), width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: Colors.blue[100],
                          elevation: 0,
                          isExpanded: true,
                          value: _selectedPeriod,
                          onChanged: _handlePeriodChange,
                          items: periodList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                  width: 16,
                ),
                MaterialButton(
                  onPressed: () {
                    String requestId = widget.requestId;
                    updateSelectedDateTime();

                    firestoreService.updateServiceRequest(
                      reqId: requestId,

                      /* serviceName: selectedService,
                      description: descriptionController.text,
                      address: addressController.text,
                      address2: addressController2.text,
                      state: selectedState,
                      city: selectedCity,
                      serviceCategory: "Electrical",
                      poscode: poscodeController.text,
                      status: status, */
                      time: finalDateTime,
                      context: context,
                      userId: user.uid,
                    );
                  },
                  color: const Color(0xff3a57e8),
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
                    "Update",
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
                    // Show a confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text(
                              "Are you sure you want to cancel the request?"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("No"),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Dismiss the dialog
                              },
                            ),
                            TextButton(
                              child: const Text("Yes"),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Dismiss the dialog
                                deleteServiceRequest(); // Call the delete function
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Request has been successfully cancelled. Your payment will be refunded within 3-5 working days"),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  color: const Color(0xffffffff),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(color: Color(0xFFCC3434), width: 1),
                  ),
                  padding: const EdgeInsets.all(16),
                  textColor: const Color(0xFFCC3434),
                  height: 45,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Cancel Request",
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
      ),
    );
  }
}
