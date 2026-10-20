import 'package:dart_oop_demo/domain/exceptions/app_exception.dart';

// Lỗi không tìm thấy dữ liệu.
class NotFoundException extends AppException {
  NotFoundException(String message) : super(message);
}
