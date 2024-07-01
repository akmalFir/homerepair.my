import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_repair_service/component/request_history_card.dart';
import 'package:home_repair_service/model/request_model.dart';
import 'package:home_repair_service/services/database/firestore.dart';

class GetRequestHistory extends StatefulWidget {
  final String user;

  const GetRequestHistory({
    super.key,
    required this.user,
  });

  @override
  State<GetRequestHistory> createState() => _GetRequestHistoryState();
}

class _GetRequestHistoryState extends State<GetRequestHistory> {
  @override
  void initState() {
    super.initState();
  }

  Stream<QuerySnapshot> getRequestHistory(String user) {
    FirestoreService firestoreService = FirestoreService();
    CollectionReference requestFormCollection = firestoreService.rf;

    if (user.isEmpty) {
      return const Stream.empty();
    }
    return requestFormCollection.where('userId', isEqualTo: user).snapshots();
  }

  Future<String> fetchProviderName(String providerId) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(providerId);

    try {
      DocumentSnapshot documentSnapshot = await userRef.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;
        return userData['name'] ?? 'Unknown';
      } else {
        return 'no data';
      }
    } catch (error) {
      return 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: StreamBuilder<QuerySnapshot>(
        stream: getRequestHistory(widget.user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return const SizedBox();
          }

          if (snapshot.data!.docs.isEmpty) {
            return const SizedBox(
              child:
                  Center(child: Text("You haven't made any service request")),
            );
          }

          if (snapshot.hasData) {
            List<RequestModel> reqList = [];

            for (var doc in snapshot.data!.docs) {
              final reqData =
                  RequestModel.fromJson(doc.data() as Map<String, dynamic>);
              reqList.add(reqData);
            }

            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: reqList.length,
              itemBuilder: (context, index) {
                return FutureBuilder<String>(
                  future: fetchProviderName(reqList[index].providerId!),
                  builder: (context, providerSnapshot) {
                    if (providerSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (providerSnapshot.hasError) {
                      return const Text('Error fetching provider name');
                    }

                    return RequestHistoryCard(
                      requestModel: reqList[index],
                      providerName: providerSnapshot.data ?? '',
                    );
                  },
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
