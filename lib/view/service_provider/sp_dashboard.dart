import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_repair_service/component/service_category_card.dart';
import 'package:home_repair_service/services/auth/auth_service.dart';
import 'package:home_repair_service/component/snack_bar_component.dart';
import 'package:home_repair_service/services/database/firestore.dart';
import 'package:home_repair_service/view/service_provider/feedback.dart';
import 'package:home_repair_service/view/service_provider/setting.dart';
import 'package:home_repair_service/view/service_provider/eletrical_service.dart';

class SPDashboard extends StatefulWidget {
  const SPDashboard({super.key});

  @override
  State<SPDashboard> createState() => _SPDashboardState();
}

class _SPDashboardState extends State<SPDashboard> {
  final authService = AuthService();
  FirestoreService firestoreService = FirestoreService();
  final user = FirebaseAuth.instance.currentUser!;
  String? name;
  var status = "waiting";

  void getName() {
    User? user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          name = documentSnapshot.get('name');
        });
      } else {
        print('User does not exist on the database');
      }
    });
  }

  List<DocumentSnapshot> data = [];
  Future<List<DocumentSnapshot>> fetchData(String providerId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('requestForm')
        .where('providerId', isEqualTo: providerId)
        .get();

    return querySnapshot.docs;
  }

  // Function to update the status
  void updateStatus(
    DocumentReference documentReference,
    String newStatus,
  ) {
    documentReference.update({'status': newStatus}).then((value) {
      SnackbarComponent.showSnackbar(context, 'Status updated successfully');
    }).catchError((error) {
      SnackbarComponent.showSnackbar(context, 'Error updating status: $error');
    });
  }

  //format time
  String formatDateTime(String input) {
    DateTime dateTime = DateTime.parse(input);

    String formattedDate =
        "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
    int hour = dateTime.hour;
    String period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12 == 0 ? 12 : hour % 12;
    String formattedTime =
        "${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period";

    return "$formattedDate   |  $formattedTime";
  }

//get customer name
  Future<String> fetchCustomerName(String customerId) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(customerId);

    try {
      DocumentSnapshot documentSnapshot = await userRef.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;
        return userData['name'] ?? 'Unknown';
      } else {
        print('Document does not exist on the database');
        return '';
      }
    } catch (error) {
      print('Error fetching document: $error');
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    getName();
    fetchData(user.uid).then((List<DocumentSnapshot> result) {
      setState(() {
        data = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffffffff),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            decoration: BoxDecoration(
              color: Colors.purple[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  child: Image(
                      image: AssetImage(
                    'lib/assets/icons/profile.png',
                  )),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Provider',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$name',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Welcome Back!',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.feedback),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FeedbackPage()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Setting()));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Align(
              alignment: Alignment(-0.8, 0.0),
              child: Text(
                "Manage Your Services",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: Color(0xff000000),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            padding: const EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width,
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: const [
                ServiceCategoryComponent(
                  serviceCategory: "Electrical",
                  page: ElectricalService(),
                  colors: Color(0xFFE1BEE7),
                  imgPath: 'lib/assets/icons/electrical.png',
                ),
                ServiceCategoryComponent(
                  serviceCategory: "Plumbing",
                  colors: Color(0xFFA09C9C),
                  imgPath: 'lib/assets/icons/plumbing.png',
                ),
                ServiceCategoryComponent(
                  serviceCategory: "Aircond",
                  colors: Color(0xFFA09C9C),
                  imgPath: 'lib/assets/icons/air-conditioner.png',
                ),
                ServiceCategoryComponent(
                  serviceCategory: "Roof",
                  colors: Color(0xFFA09C9C),
                  imgPath: 'lib/assets/icons/roof.png',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Align(
              alignment: Alignment(-0.8, 0.0),
              child: Text(
                "Customer Request",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: Color(0xff000000),
                ),
              ),
            ),
          ),
          // Widget to display the fetched data
          Expanded(
            child: data.isEmpty
                ? const SizedBox(
                    child: Center(
                        child: Text("There is no service request available")),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var document = data[index];
                      var serviceCategory = document['serviceCategory'];
                      var serviceName = document['serviceName'];
                      var time = document['time'];
                      var status = document['status'];
                      var customerId = document['userId'];
                      // var serviceCompleted = document['serviceCompleted'];

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: GestureDetector(
                          onTap: () {
                            // Function to show confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm Action"),
                                  content: const Text(
                                      "Update your service progress to customer"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        updateStatus(
                                            document.reference, 'Dispatch');
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Dispatch'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        /* if (serviceCompleted == true) {
                                          updateStatus(
                                              document.reference, 'Complete');
                                        } else if (serviceCompleted == false) {
                                          SnackbarComponent.showSnackbar(
                                              context,
                                              "Customer must confirm first");
                                        } */
                                        updateStatus(
                                            document.reference, 'Complete');
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Complete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: FutureBuilder<String>(
                                future: fetchCustomerName(customerId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                      'Loading...',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text(
                                      'Error',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    );
                                  } else {
                                    return Text(
                                      snapshot.data ?? 'Unknown',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    );
                                  }
                                },
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('$serviceName [$serviceCategory]'),
                                  Text(formatDateTime(time)),
                                ],
                              ),
                              trailing: Text('$status'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
