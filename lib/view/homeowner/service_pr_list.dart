import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_repair_service/view/homeowner/order.dart';

class ServiceProviderListPage extends StatefulWidget {
  final String serviceName;
  final String serviceCategory;
  final String address;
  final String address2;
  final String state;
  final String city;
  final String? description;
  final double? price;
  final DateTime? time;
  final int? quantity;
  final String? imgPath;
  final String poscode;
  final String? userId;
  final String? status;
  final String? requestTime;
  const ServiceProviderListPage({
    super.key,
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
    this.userId,
    this.status,
    this.requestTime,
  });

  @override
  State<ServiceProviderListPage> createState() =>
      _ServiceProviderListPageState();
}

class _ServiceProviderListPageState extends State<ServiceProviderListPage> {
  Future<void> updateServiceRequest(
      // String price,
      String reqTime,
      String providerId) async {
    // Create a reference to the requestForm collection
    CollectionReference requestForm =
        FirebaseFirestore.instance.collection('requestForm');

    try {
      // Query to find the document(s) with the specified field value
      QuerySnapshot querySnapshot =
          await requestForm.where('requestTime', isEqualTo: reqTime).get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming the query returns a single document)
        DocumentSnapshot doc = querySnapshot.docs.first;
        DocumentReference docRef = doc.reference;

        // Create a map containing the new field to be added
        Map<String, dynamic> dataToUpdate = {
          'providerId': providerId,
          // 'price': price,
        };

        // Update the document with the new data
        await docRef.update(dataToUpdate);
        print('Document updated successfully');
      } else {
        print('No documents found with the specified field value');
      }
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Order Request",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: widget.serviceName.isNotEmpty
                    ? FirebaseFirestore.instance
                        .collection('serviceProviders')
                        .snapshots()
                    : null,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (widget.serviceName.isEmpty) {
                    return const Center(
                        child: Text('Enter a service name to search'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error loading service providers'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No service providers found'));
                  }

                  final serviceProviders = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: serviceProviders.length,
                    itemBuilder: (context, index) {
                      final serviceProvider = serviceProviders[index];

                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('serviceProviders')
                            .doc(serviceProvider.id)
                            .collection('services')
                            .where('serviceName', isEqualTo: widget.serviceName)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> serviceSnapshot) {
                          if (serviceSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (serviceSnapshot.hasError) {
                            return const Text('Error loading services');
                          }
                          if (!serviceSnapshot.hasData ||
                              serviceSnapshot.data!.docs.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          final services = serviceSnapshot.data!.docs;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    serviceProvider['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ...services.map((service) {
                                    return ListTile(
                                      title: Text(service['serviceName']),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(service['serviceCategory']),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'RM${service['servicePrice']}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      trailing: MaterialButton(
                                        onPressed: () {
                                          final servicePrice =
                                              service['servicePrice'];
                                          String selectedPrice = "0";
                                          if (servicePrice is double) {
                                            selectedPrice =
                                                service['servicePrice']
                                                    .toString();
                                          } else if (servicePrice is String) {
                                            selectedPrice =
                                                service['servicePrice'];
                                          }

                                          final serviceProviderId =
                                              serviceProvider.id;
                                          updateServiceRequest(
                                              // selectedPrice,
                                              widget.requestTime!,
                                              serviceProviderId);
                                          //payment page
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderRequest(
                                                        serviceName:
                                                            widget.serviceName,
                                                        description:
                                                            widget.description,
                                                        address: widget.address,
                                                        address2:
                                                            widget.address2,
                                                        state: widget.state,
                                                        city: widget.city,
                                                        serviceCategory: widget
                                                            .serviceCategory,
                                                        time: widget.time,
                                                        poscode: widget.poscode,
                                                        status: widget.status,
                                                        price: selectedPrice,
                                                      )));
                                        },
                                        color: const Color(0xffffffff),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          side: const BorderSide(
                                              color: Color(0xff808080),
                                              width: 1),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        textColor: const Color(0xff000000),
                                        height: 45,
                                        minWidth: 50,
                                        child: const Text(
                                          "Select",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
