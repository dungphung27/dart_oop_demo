import 'package:dart_oop_demo/domain/payments/payment_method.dart';

class CashPayment implements PaymentMethod {
  @override
  String pay(double amount) => 'Đã trả $amount bằng tiền mặt';
}
