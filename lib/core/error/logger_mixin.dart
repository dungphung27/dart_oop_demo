// Mixin ghi log: class nào cần log thì thêm `with LoggerMixin`.
// runtimeType = tên class đang chạy, nên log tự biết "ai đang nói".
mixin LoggerMixin {
  // Danh sách log dùng chung, để giao diện lấy ra hiển thị (đơn giản, không dùng Stream).
  static final List<String> logs = [];

  void log(String message) {
    final line = '[$runtimeType] $message';
    logs.add(line);
    // ignore: avoid_print
    print(line);
  }
}
