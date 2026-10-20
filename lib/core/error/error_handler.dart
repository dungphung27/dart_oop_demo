import 'package:dart_oop_demo/core/error/logger_mixin.dart';
import 'package:dart_oop_demo/domain/exceptions/app_exception.dart';

// LÝ THUYẾT: Centralized Error Handling Pipeline (xử lý lỗi tập trung)
// Ý tưởng: KHÔNG rải try-catch + print(e) khắp nơi. Mọi lỗi đều đổ về MỘT chỗ,
// đi qua các bước cố định:
//
//   Lỗi xảy ra ở bất kỳ đâu
//            |
//            v
//   +-------------------+
//   |   ErrorHandler    |
//   | 1. Phân loại      |  AppException (lỗi ta biết) hay lỗi lạ (bug)?
//   | 2. Ghi log        |
//   | 3. Tạo message    |  câu thân thiện cho người dùng
//   +-------------------+
//            |
//            v
//     UI hiển thị message
class ErrorHandler with LoggerMixin {
  // Singleton đơn giản: cả app dùng chung đúng 1 ErrorHandler.
  static final ErrorHandler instance = ErrorHandler();

  // Message của lỗi gần nhất, để UI lấy ra hiển thị.
  String lastUserMessage = '';

  // Cả 3 bước của pipeline nằm ở đây.
  String handle(Object error, StackTrace stack) {
    String userMessage;

    // Bước 1: phân loại
    if (error is AppException) {
      // Bước 2: ghi log (lỗi nghiệp vụ, đã lường trước)
      log('Lỗi nghiệp vụ ${error.runtimeType}: ${error.message}');
      userMessage = error.message;
    } else {
      // Bước 2: ghi log (lỗi lạ, nhiều khả năng là bug)
      log('Lỗi không lường trước ${error.runtimeType}: $error');
      log('Stack: ${stack.toString().split('\n').first}');
      userMessage = 'Có lỗi xảy ra, vui lòng thử lại sau.';
    }

    // Bước 3: message cho người dùng
    log('-> Hiển thị cho user: $userMessage');
    lastUserMessage = userMessage;
    return userMessage;
  }

  // Chạy một hành động, lỗi nào xảy ra cũng đi qua handle().
  // <T>: generics, hành động trả về kiểu gì thì run() trả về kiểu đó (hoặc null nếu lỗi).
  T? run<T>(T Function() action) {
    try {
      return action();
    } catch (e, s) {
      handle(e, s);
      return null;
    }
  }
}
