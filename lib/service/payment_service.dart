// import 'package:flutter_stripe/flutter_stripe.dart';
//
// class PaymentService {
//   final int amount;
//   final String url;
//
//   PaymentService({
//     required this.amount,
//     required this.url
//   });
//
//   static init() {
//     Stripe.publishableKey =
//     'pk_test_51K7c3jLZFf69SCa4UmIugNRO6W3vNQ5FXRo6EfhkWd4OOZjiIBhFID1bz1j59qv2QuJdQVf4xYwFSkXnuo6kQ2JH002Yp4txgs';
//   }
//
//   Future<PaymentMethod?> createPaymentMethod() async {
//     print('The transaction amount to be charged is: $amount');
//     PaymentMethod paymentMethod = await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//             paymentIntentClientSecret:));
//   }
//
//   Future<void> processPayment(PaymentMethod paymentMethod) async {
//
//   }
// }