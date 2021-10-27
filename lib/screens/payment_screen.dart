import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  static const routeName = "/payment";
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Payment',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        body: Container());
  }
}
