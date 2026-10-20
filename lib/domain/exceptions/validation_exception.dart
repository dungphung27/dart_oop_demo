import 'package:dart_oop_demo/domain/exceptions/app_exception.dart';

// Lỗi dữ liệu đầu vào không hợp lệ.
class ValidationException extends AppException {
  ValidationException(String message) : super(message);
}
