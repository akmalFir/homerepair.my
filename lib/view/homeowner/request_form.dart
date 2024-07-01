import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_repair_service/component/snack_bar_component.dart';
import 'package:home_repair_service/model/location.dart';
import 'package:home_repair_service/model/service_options.dart';
import 'package:home_repair_service/services/database/firestore.dart';
import 'package:home_repair_service/view/homeowner/service_pr_list.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  FirestoreService firestoreService = FirestoreService();
  final user = FirebaseAuth.instance.currentUser!;
  String reqId = '';

  final TextEditingController addressController = TextEditingController();
  final TextEditingController addressController2 = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController poscodeController = TextEditingController();
  final String status = "Waiting";
  final String category = "Electrical";

  //Service options
  ServiceOption serviceOption = ServiceOption();
  String selectedService = "Ceiling Fans Install";

  //City and States
  Location address = Location();
  String selectedState = 'Selangor';
  String selectedCity = 'Gombak';

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

//time function
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
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
                    dropdownColor: Colors.blue[100],
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
                  "Description(Optional)",
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
              TextField(
                controller: descriptionController,
                textAlign: TextAlign.start,
                maxLines: 2,
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
                  hintText: "Description",
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
              ),
              const SizedBox(
                height: 20,
                width: 16,
              ),
              MaterialButton(
                onPressed: () {},
                color: const Color(0xffffffff),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(color: Color(0xff3a57e8), width: 1),
                ),
                padding: const EdgeInsets.all(16),
                textColor: const Color(0xff3a57e8),
                height: 50,
                minWidth: MediaQuery.of(context).size.width,
                child: const Text(
                  "Attach Image",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
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
                  "Address",
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
              TextField(
                controller: addressController,
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
                  hintText: "Line 1",
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
              ),
              const SizedBox(
                height: 16,
                width: 16,
              ),
              TextField(
                controller: addressController2,
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
                  hintText: "Line 2",
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
              ),
              const SizedBox(
                height: 16,
                width: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.44,
                    height: 50,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border:
                          Border.all(color: const Color(0xff000000), width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedState,
                        items: address.states.map((state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: Text(
                              state,
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
                            selectedState = value!;
                            selectedCity = address.cityMap[value]![
                                0]; // Set the first city of the selected state as default
                          });
                        },
                        dropdownColor: Colors.blue[100],
                        elevation: 0,
                        isExpanded: true,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                    width: 16,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.44,
                    height: 50,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border:
                          Border.all(color: const Color(0xff000000), width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCity,
                        items: address.cityMap[selectedState]!.map((city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(
                              city,
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
                            selectedCity = value!;
                          });
                        },
                        dropdownColor: Colors.blue[100],
                        elevation: 0,
                        isExpanded: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
                width: 16,
              ),
              Align(
                alignment: const Alignment(-1, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.44,
                  child: TextField(
                    controller: poscodeController,
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
                        borderSide: const BorderSide(
                            color: Color(0xff000000), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            color: Color(0xff000000), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            color: Color(0xff000000), width: 1),
                      ),
                      hintText: "Poscode",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      filled: true,
                      fillColor: const Color(0xffffffff),
                      isDense: false,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
                width: 16,
              ),
              //Date and Time Selector component
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border:
                          Border.all(color: const Color(0xff000000), width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        dropdownColor: Colors.blue[100],
                        elevation: 0,
                        isExpanded: true,
                        value: _selectedHour,
                        onChanged: _handleHourChange,
                        items: hoursList.map((int value) {
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border:
                          Border.all(color: const Color(0xff000000), width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.blue[100],
                        elevation: 0,
                        isExpanded: true,
                        value: _selectedMinute,
                        onChanged: _handleMinuteChange,
                        items: minutesList.map((String value) {
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border:
                          Border.all(color: const Color(0xff000000), width: 1),
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
                height: 30,
                width: 16,
              ),
              MaterialButton(
                onPressed: () {
                  final String reqTime = DateTime.now().toString();
                  updateSelectedDateTime();
                  firestoreService.requestService(
                    serviceName: selectedService,
                    description: descriptionController.text,
                    address: addressController.text,
                    address2: addressController2.text,
                    state: selectedState,
                    city: selectedCity,
                    serviceCategory: category,
                    userId: user.uid,
                    time: finalDateTime,
                    poscode: poscodeController.text,
                    status: status,
                    requestTime: reqTime,
                    providerId: 'not set',
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServiceProviderListPage(
                                serviceName: selectedService,
                                description: descriptionController.text,
                                address: addressController.text,
                                address2: addressController2.text,
                                state: selectedState,
                                city: selectedCity,
                                serviceCategory: category,
                                time: finalDateTime,
                                poscode: poscodeController.text,
                                status: status,
                                userId: user.uid,
                                requestTime: reqTime,
                              )));
                  SnackbarComponent.showSnackbar(
                      context, "Request service successful");
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
                  "Search",
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
