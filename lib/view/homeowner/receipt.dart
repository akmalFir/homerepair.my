import 'package:flutter/material.dart';
import 'package:home_repair_service/view/homeowner/hm_dashboard.dart';

class ReceiptPage extends StatelessWidget {
  final String totalAmount; // Total amount paid
  final String items;
  final String paymentMethod; // Selected payment method
  final String orderNumber; // Order number or ID

  const ReceiptPage({
    super.key,
    required this.totalAmount,
    required this.items,
    required this.paymentMethod,
    required this.orderNumber,
  });

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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HMDashboard(),
              ),
            );
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReceiptItem('Total Amount:', '\RM$totalAmount'),
            const SizedBox(height: 16),
            const Text(
              'Service Purchased:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(items),
            const SizedBox(height: 16),
            _buildReceiptItem('Payment Method:', paymentMethod),
            const SizedBox(height: 16),
            _buildReceiptItem('Order Number:', orderNumber),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value),
      ],
    );
  }

  /* List<Widget> _buildItemList() {
    return items.map((item) => Text('- $item')).toList();
  } */
}
