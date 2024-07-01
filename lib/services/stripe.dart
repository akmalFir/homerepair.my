import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future createPaymentIntent({
  required String name,
  required String address,
  required String poscode,
  required String city,
  required String state,
  required String country,
  required String currency,
  required String amount,
}) async {
  final url = Uri.parse("https://api.stripe.com/v1/payment_intents");
  final secretKey = dotenv.env["STRIPE_SECRET_KEY"]!;
  final body = {
    'amount': amount,
    'currency': 'MYR',
    'automatic_payment_methods[enabled]': 'true',
    'description': 'Electrical services',
    'shipping[name]': name,
    'shipping[address][line1]': address,
    'shipping[address][postal_code]': poscode,
    'shipping[address][city]': city,
    'shipping[address][state]': state,
    'shipping[address][country]': 'MY',
  };

  final respose = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $secretKey",
      "Content-Type": 'application/x-www-form-urlencoded',
    },
    body: body,
  );

  if (respose.statusCode == 200) {
    var json = jsonDecode(respose.body);
    print(json);
    return json;
  } else {
    print("error in calling payment intent");
  }
}
