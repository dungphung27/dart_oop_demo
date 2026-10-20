import 'package:dart_oop_demo/domain/payments/payment_method.dart';

class CardPayment implements PaymentMethod {
  @override
  String pay(double amount) => 'Đã trả $amount bằng thẻ';
}
