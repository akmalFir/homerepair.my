import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:home_repair_service/component/snack_bar_component.dart';
import 'package:home_repair_service/services/stripe.dart';
import 'package:home_repair_service/view/homeowner/receipt.dart';

class OrderRequest extends StatefulWidget {
  final String serviceName;
  final String serviceCategory;
  final String address;
  final String address2;
  final String state;
  final String city;
  final String? description;
  final String? price;
  final DateTime? time;
  final int? quantity;
  final String? imgPath;
  final String poscode;
  final String? reqId;
  final String? userId;
  final String? status;
  const OrderRequest({
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
    this.reqId,
    this.userId,
    this.status,
  });

  @override
  State<OrderRequest> createState() => _OrderRequestState();
}

class _OrderRequestState extends State<OrderRequest> {
  String? cardNumber;

  Widget _buildPaymentDetail(String label, String value) {
    return Text(
      "$label: $value",
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Colors.black,
      ),
    );
  }

  String orderIdGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }
/* 
  String? _getDisplayCardNumber(String? fullCardNumber) {
    if (fullCardNumber == null || fullCardNumber.length < 4) {
      return null;
    }
    return "XXXX-XXXX-XXXX-${fullCardNumber.substring(fullCardNumber.length - 4)}";
  }

  void _showAddCardBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Card Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              // Add form fields for card details input here
              TextFormField(
                decoration: const InputDecoration(labelText: "Card Number"),
                onChanged: (value) {
                  setState(() {
                    cardNumber = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: "Expiry Date"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: "CVC"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implement logic to save card details
                  Navigator.pop(context);
                },
                child: const Text("Save Card"),
              ),
            ],
          ),
        );
      },
    );
  } */

  Future<void> initPaymentSheet() async {
    final double priceDouble = double.tryParse(widget.price.toString()) ?? 0.0;
    final int roundedPrice = priceDouble.round();
    final String priceString = roundedPrice.toString();
    try {
      // 1. create payment intent on the server
      final data = await createPaymentIntent(
        name: "name", //tukar actual name
        address: '${widget.address} ${widget.address2}',
        poscode: widget.poscode,
        state: widget.state,
        city: widget.city,
        country: 'MY',
        currency: 'MYR',
        amount: (int.parse(priceString) * 100).toString(),

        // amount: widget.price.toString(),
      );

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Demo Contractor',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          // Extra options
          /*  applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'US',
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ), */
          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 10),
            const Text(
              "Payment Summary",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 134, 134, 134)),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPaymentDetail(
                      "Repair Category", widget.serviceCategory),
                  const SizedBox(height: 10),
                  _buildPaymentDetail("Repair Name", widget.serviceName),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Total Price: RM"),
                      Text(
                        "${widget.price}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            /* const Text(
              "Payment Method",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2), // changes the shadow position
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  _showAddCardBottomSheet(context);
                },
                child: ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text("Credit Card"),
                  subtitle: Text(
                    _getDisplayCardNumber(cardNumber) ?? "XXXX-XXXX-XXXX-1234",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), */
            MaterialButton(
              onPressed: () async {
                await initPaymentSheet();

                try {
                  await Stripe.instance.presentPaymentSheet();
                  SnackbarComponent.showSnackbar(context, 'Payment Done');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReceiptPage(
                          //insert the actual value here
                          totalAmount: widget.price.toString(),
                          items: widget.serviceName,
                          paymentMethod: "Card",
                          orderNumber: orderIdGenerator()),
                    ),
                  ); //
                } catch (e) {
                  SnackbarComponent.showSnackbar(context, 'Payment Fail');
                }

                //
              },
              color: const Color(0xff3a57e8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: const BorderSide(color: Colors.white, width: 1),
              ),
              padding: const EdgeInsets.all(16),
              textColor: Colors.white,
              height: 45,
              minWidth: MediaQuery.of(context).size.width,
              child: const Text(
                "Pay Now",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
