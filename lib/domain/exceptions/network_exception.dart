import 'package:dart_oop_demo/domain/exceptions/app_exception.dart';

// Lỗi mạng: mất kết nối, timeout...
class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}
