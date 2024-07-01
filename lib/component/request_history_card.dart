import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_repair_service/model/request_model.dart';
import 'package:home_repair_service/view/homeowner/edit_request.dart';

class RequestHistoryCard extends StatefulWidget {
  final RequestModel requestModel;
  final String providerName;

  const RequestHistoryCard({
    super.key,
    required this.requestModel,
    required this.providerName,
  });

  @override
  State<RequestHistoryCard> createState() => _RequestHistoryCardState();
}

class _RequestHistoryCardState extends State<RequestHistoryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE3F2FD),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: ListTile(
          title: Text(widget.providerName),
          subtitle: Text(
              "${widget.requestModel.serviceName} [${widget.requestModel.serviceCategory}]\n${widget.requestModel.getDate()}  |  ${widget.requestModel.getTime()}"),
          onTap: () {
            final reqId = widget.requestModel.reqId!;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => EditRequest(
                          requestId: reqId,
                        )));
          },
          trailing: GestureDetector(
              onTap: () {
                showConfirmationDialog(context);
              },
              child: Text(widget.requestModel.status!))),
    );
  }

  // Function to update service request
  void updateDatabase(bool confirmation) {
    // Replace this with your Firestore collection and document ID
    FirebaseFirestore.instance
        .collection('requestForm')
        .doc(widget.requestModel.reqId)
        .update({'serviceCompleted': confirmation}).then((_) {
      print('Database updated successfully');
    }).catchError((error) {
      print('Failed to update database: $error');
    });
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Does the services has been completed?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                updateDatabase(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                updateDatabase(true);

                // Add your confirmation action here
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
