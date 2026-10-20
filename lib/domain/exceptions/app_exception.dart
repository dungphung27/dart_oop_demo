// LÝ THUYẾT: Custom exception
// Dart cho phép ném (throw) bất kỳ object nào, nhưng nên ném object của class
// kế thừa Exception. Ta tạo 1 lớp cha AppException cho mọi lỗi nghiệp vụ,
// để sau này ErrorHandler chỉ cần hỏi: "đây có phải AppException không?"
//
//            Exception
//                |
//          AppException            <- lớp cha của mọi lỗi nghiệp vụ
//     +----------+----------+---------------+
//     |          |          |               |
//  Network   NotFound   Validation       Unknown
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}
