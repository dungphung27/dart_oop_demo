import 'package:dart_oop_demo/domain/exceptions/validation_exception.dart';

// LÝ THUYẾT: Mixin
// Dart chỉ cho kế thừa 1 class cha (extends). Muốn "mượn" thêm code từ nhiều
// nơi thì dùng mixin: viết sẵn các hàm dùng chung, class nào cần thì thêm
// `with TênMixin`.
//
//   class Product with ValidationMixin   -> Product dùng được validateNotEmpty()
//   class Order   with ValidationMixin   -> Order cũng dùng được
mixin ValidationMixin {
  void validateNotEmpty(String value, String field) {
    if (value.trim().isEmpty) {
      throw ValidationException('$field không được để trống');
    }
  }

  void validatePositive(double value, String field) {
    if (value <= 0) {
      throw ValidationException('$field phải lớn hơn 0');
    }
  }
}
