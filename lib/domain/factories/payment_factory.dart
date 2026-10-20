import 'package:dart_oop_demo/domain/exceptions/validation_exception.dart';
import 'package:dart_oop_demo/domain/payments/card_payment.dart';
import 'package:dart_oop_demo/domain/payments/cash_payment.dart';
import 'package:dart_oop_demo/domain/payments/payment_method.dart';

// LÝ THUYẾT: Factory Pattern
// Ý tưởng: thay vì nơi gọi tự `new CashPayment()` hay `new CardPayment()`,
// ta nhờ "nhà máy" tạo giúp dựa trên một chuỗi (type).
//
//   PaymentFactory.create('cash') ---> CashPayment
//   PaymentFactory.create('card') ---> CardPayment
//   PaymentFactory.create('abc')  ---> ném ValidationException
//
// Nơi gọi chỉ cần biết PaymentMethod, thêm loại thanh toán mới chỉ sửa ở đây.
class PaymentFactory {
  static PaymentMethod create(String type) {
    if (type == 'cash') return CashPayment();
    if (type == 'card') return CardPayment();
    throw ValidationException('Không hỗ trợ phương thức thanh toán "$type"');
  }
}
