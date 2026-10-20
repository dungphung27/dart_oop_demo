import 'dart:async';

import 'package:dart_oop_demo/core/error/error_handler.dart';
import 'package:dart_oop_demo/data/repositories/in_memory_product_repository.dart';
import 'package:dart_oop_demo/domain/entities/product.dart';
import 'package:dart_oop_demo/domain/factories/payment_factory.dart';
import 'package:dart_oop_demo/domain/repositories/product_repository.dart';

void title(String text) {
  print('');
  print('=== $text ===');
}

void main() {
  // LÝ THUYẾT: Error boundary
  // Là "lưới an toàn" ngoài cùng: lỗi nào không ai bắt thì rơi vào đây
  // thay vì làm app sập. Trong Dart thuần dùng runZonedGuarded.
  // (Trong Flutter thì dùng FlutterError.onError, xem ghi chú cuối bài.)
  runZonedGuarded(demo, (error, stack) {
    ErrorHandler.instance.handle(error, stack);
  });
}

void demo() {
  final handler = ErrorHandler.instance;

  // Biến khai báo kiểu abstract (ProductRepository), gán object cụ thể bên phải.
  final ProductRepository repo = InMemoryProductRepository();
  final ProductRepository offlineRepo = InMemoryProductRepository(offline: true);

  title('1. Thành công');
  final product = handler.run(() => repo.getById(1));
  print('Kết quả: $product');

  title('2. NotFoundException');
  handler.run(() => repo.getById(999));

  title('3. NetworkException');
  handler.run(() => offlineRepo.getById(1));

  title('4. ValidationException (factory constructor: JSON thiếu trường)');
  handler.run(() => Product.fromJson({'id': 3, 'price': 100}));

  title('5. ValidationException (mixin: tên rỗng)');
  handler.run(() => Product(4, '', 100));

  title('6. Named constructor');
  print(Product.empty());

  title('7. Factory Pattern (thành công)');
  final result = handler.run(() => PaymentFactory.create('card').pay(100000));
  print('Kết quả: $result');

  title('8. Factory Pattern (loại không hỗ trợ)');
  handler.run(() => PaymentFactory.create('bitcoin').pay(100000));

  title('9. Lỗi không lường trước (bug)');
  handler.run(() => [1, 2, 3][10]);

  title('10. Lỗi async không ai bắt -> error boundary bắt');
  Future.delayed(const Duration(milliseconds: 100), () {
    throw Exception('Lỗi async không ai bắt');
  });
}

// GHI CHÚ: Nếu chuyển sang Flutter, error boundary tương ứng là 3 dòng trong main():
//   FlutterError.onError = (d) => ErrorHandler.instance.handle(d.exception, d.stack!);
//   PlatformDispatcher.instance.onError = (e, s) { ErrorHandler.instance.handle(e, s); return true; };
//   ErrorWidget.builder = (details) => const Text('Giao diện bị lỗi');
